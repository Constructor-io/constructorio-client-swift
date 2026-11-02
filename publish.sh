#!/usr/bin/env bash

# Version bump, tag, GitHub release and CocoaPods publish for ConstructorAutocomplete.
#
# Usage: ./publish.sh <patch|minor|major|X.Y.Z> "<release message>" [options]
#   e.g. ./publish.sh minor "Add Product Insights Agent tracking"   (4.9.3 -> 4.10.0)
#
#   patch        Bug fixes            (X.Y.Z -> X.Y.Z+1)
#   minor        New, compatible API  (X.Y.Z -> X.Y+1.0)
#   major        Breaking changes     (X.Y.Z -> X+1.0.0)
#   X.Y.Z        Exact version, e.g. 4.10.0. Must be higher than the current version.
#
# Milestones, in order:
#   test         Unit tests passed (nothing changed yet)
#   bump         Version updated in Info.plist and the podspec (not committed)
#   docs         Docs regenerated with jazzy (not committed)
#   commit       "Version Bump" committed locally
#   push         Tagged and pushed to origin/master
#   release      GitHub release created
#   pod          Linted and published to CocoaPods trunk (default, the full publish)
#
# Options:
#   --until <milestone>  Stop after reaching <milestone>
#   --dry-run            Run the local milestones, but only print the push / release / pod commands
#   --yes                Don't ask for confirmation before the bump and outward-facing steps
#   --skip-docs          Don't regenerate docs with jazzy
#   --skip-tests         Don't run the tests
#   --with-integration   Also run the integration tests. They hit the live API and depend on live
#                        index data, so they're skipped by default.
#   -h, --help           Show this help
#
# Environment:
#   TEST_DESTINATION     xcodebuild destination for the tests. Defaults to the newest iPhone simulator.
#   DEVELOPER_DIR        Xcode to use for the whole run, e.g. /Applications/Xcode-26.6.0.app/Contents/Developer.
#                        Defaults to the newest installed Xcode 26 or older when Xcode 27+ is selected.
#
# Requirements:
#   Docs use the jazzy pinned in Gemfile.lock, run through Bundler. One-time setup:
#     brew install ruby@3.4 && /opt/homebrew/opt/ruby@3.4/bin/bundle install
#   The system Ruby (2.6) can't build jazzy's native gems on Apple Silicon, and Ruby 4 breaks
#   the pinned rouge, so this script uses Homebrew's ruby@3.4 when it's installed.
#
#   The pod milestone needs a CocoaPods trunk session as an owner of the pod (pod trunk register).
#
#   Xcode 27+ can't build for the project's iOS 11 target, so install Xcode 26 next to it. The
#   script switches to it on its own. One-time setup (needs your Apple ID):
#     brew install xcodes aria2 && xcodes install 26.6 --experimental-unxip --directory /Applications
#     DEVELOPER_DIR=/Applications/Xcode-26.6.0.app/Contents/Developer xcodebuild -downloadPlatform iOS
#   Without it, the pod milestone can't run, and the tests and docs build for iOS 15 instead
#   (local only; the project and podspec keep iOS 11).

set -euo pipefail

PODSPEC="ConstructorAutocomplete.podspec"
INFO_PLIST="AutocompleteClient/Info.plist"
DOCS_DIR="docs"
JAZZY_CONFIG=".jazzy.yaml"
MAIN_BRANCH="master"
REMOTE="origin"
MILESTONES="test bump docs commit push release pod"
POD_NAME="ConstructorAutocomplete"
WORKSPACE="AutocompleteClient.xcworkspace"
SCHEME="ConstructorAutocomplete"
TEST_TARGET="AutocompleteClientTests"
INTEGRATION_TEST_CLASSES="ConstructorIOIntegrationTests ConstructorIOQuizIntegrationTests"
# The newest Xcode major version that can still build for the project's iOS 11 target, and the
# target the local test and docs builds use on newer Xcodes
MAX_IOS11_XCODE=26
NEW_XCODE_IOS_TARGET="15.0"

DRY_RUN=false
ASSUME_YES=false
SKIP_DOCS=false
SKIP_TESTS=false
WITH_INTEGRATION=false
UNTIL="pod"
POSITIONAL=()

usage() { sed -n '3,/^$/s/^# \{0,1\}//p' "$0"; }

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=true ;;
    --yes) ASSUME_YES=true ;;
    --skip-docs) SKIP_DOCS=true ;;
    --skip-tests) SKIP_TESTS=true ;;
    --with-integration) WITH_INTEGRATION=true ;;
    --until) [ "$#" -ge 2 ] || { echo "--until needs a milestone" >&2; exit 1; }; UNTIL="$2"; shift ;;
    --until=*) UNTIL="${1#--until=}" ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; exit 1 ;;
    *) POSITIONAL+=("$1") ;;
  esac
  shift
done

if [ "${#POSITIONAL[@]}" -ne 2 ]; then
  echo "Usage: ./publish.sh <patch|minor|major|X.Y.Z> \"<release message>\" [options]  (see --help)" >&2
  exit 1
fi

BUMP="${POSITIONAL[0]#v}"
MESSAGE="${POSITIONAL[1]}"

step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }
warn() { printf '\033[1;33mWARNING: %s\033[0m\n' "$*"; }
fail() { printf '\033[1;31mERROR: %s\033[0m\n' "$*" >&2; exit 1; }

# Position of a milestone in MILESTONES, starting at 1. 0 if it isn't one.
milestone_index() {
  local i=1 m
  for m in $MILESTONES; do
    [ "$m" = "$1" ] && { echo "$i"; return; }
    i=$((i + 1))
  done
  echo 0
}

# True if the run goes as far as the given milestone
runs_until() { [ "$(milestone_index "$1")" -le "$(milestone_index "$UNTIL")" ]; }

# Called after each milestone. Exits cleanly if it's the one passed to --until.
reached() {
  [ "$1" = "$UNTIL" ] || return 0

  step "Stopped after milestone '$1' ($TAG)"
  case "$1" in
    test)
      echo "Nothing has been changed." ;;
    bump|docs)
      echo "The version files$( [ "$1" = docs ] && echo " and docs" ) are changed but not committed."
      echo "To undo: git checkout -- $INFO_PLIST $PODSPEC $DOCS_DIR && git clean -fd -- $DOCS_DIR" ;;
    commit)
      echo "The 'Version Bump' commit is local only."
      echo "To undo: git reset --hard $REMOTE/$MAIN_BRANCH" ;;
    push|release)
      $DRY_RUN && echo "Dry run: nothing was pushed. To undo the local commit: git reset --hard $REMOTE/$MAIN_BRANCH" ;;
  esac
  exit 0
}

# Runs outward-facing commands, or just prints them in dry-run mode
remote_run() {
  if $DRY_RUN; then
    printf '[dry-run]'
    local a
    for a in "$@"; do
      case "$a" in *[[:space:]]*) printf " '%s'" "$a" ;; *) printf ' %s' "$a" ;; esac
    done
    printf '\n'
  else
    "$@"
  fi
}

# Names of the top-level public types in the SDK at a given commit, sorted
public_types_at() {
  git grep -hE '^(@objc(\([A-Za-z]+\))? )?(public|open) (final )?(class|struct|enum|protocol) [A-Za-z_][A-Za-z0-9_]*' "$1" -- AutocompleteClient \
    | sed -E 's/^(@objc(\([A-Za-z]+\))? )?(public|open) (final )?(class|struct|enum|protocol) ([A-Za-z0-9_]+).*/\6/' \
    | LC_ALL=C sort -u
}

confirm() {
  $ASSUME_YES && return 0
  $DRY_RUN && return 0
  read -r -p "$1 [y/N] " reply || reply=""
  [[ "$reply" =~ ^[Yy]$ ]] || fail "Aborted."
}

cd "$(git rev-parse --show-toplevel)"

if [ -d /opt/homebrew/opt/ruby@3.4/bin ]; then
  export PATH="/opt/homebrew/opt/ruby@3.4/bin:$PATH"
fi

# 1. Preflight checks
step "Preflight checks"

if [[ "$BUMP" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  STRATEGY="explicit"
else
  case "$BUMP" in
    patch|minor|major) STRATEGY="$BUMP" ;;
    *) fail "Bump type must be patch, minor, major or an exact X.Y.Z version (got '$BUMP')" ;;
  esac
fi

[ -n "$MESSAGE" ] || fail "Release message must not be empty"

[ "$(milestone_index "$UNTIL")" -gt 0 ] || fail "Unknown milestone '$UNTIL'. Use one of: $MILESTONES"

IOS_TARGET="$(sed -n "s/^ *spec\.platform *= *:ios, *'\(.*\)'.*/\1/p" "$PODSPEC")"
[ -n "$IOS_TARGET" ] || fail "Couldn't read the iOS deployment target from $PODSPEC"

xcode_major() { xcodebuild -version 2>/dev/null | sed -n 's/^Xcode \([0-9]*\).*/\1/p' || true; }

XCODE_MAJOR="$(xcode_major)"
[ -n "$XCODE_MAJOR" ] || fail "Couldn't read the Xcode version from 'xcodebuild -version'"

# Xcode 27+ can't build for iOS 11. Unless DEVELOPER_DIR picks an Xcode, switch the whole run to
# the newest installed one that still can, so every step builds for the project's real target.
if [ "$XCODE_MAJOR" -gt "$MAX_IOS11_XCODE" ] && [ -z "${DEVELOPER_DIR:-}" ]; then
  OLD_XCODE="$(for app in /Applications/Xcode*.app; do
      version="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$app/Contents/Info.plist" 2>/dev/null)" || continue
      [ "${version%%.*}" -le "$MAX_IOS11_XCODE" ] && echo "$version|$app"
    done | sort -V | tail -n1 || true)"

  if [ -n "$OLD_XCODE" ]; then
    export DEVELOPER_DIR="${OLD_XCODE#*|}/Contents/Developer"
    XCODE_MAJOR="$(xcode_major)"
    [ -n "$XCODE_MAJOR" ] || fail "Couldn't read the Xcode version of $DEVELOPER_DIR"
    echo "Using Xcode ${OLD_XCODE%%|*} (${OLD_XCODE#*|}), since Xcode 27+ can't build for iOS 11"
  fi
fi

# A side-by-side Xcode doesn't come with its iOS platform until it's downloaded
xcrun --sdk iphonesimulator --show-sdk-path >/dev/null 2>&1 \
  || fail "Xcode $XCODE_MAJOR has no iOS platform installed. Run: DEVELOPER_DIR=\"${DEVELOPER_DIR:-$(xcode-select -p)}\" xcodebuild -downloadPlatform iOS"

if ! $SKIP_TESTS; then
  if [ -z "${TEST_DESTINATION:-}" ]; then
    # Picks the newest iOS this Xcode's SDK can run, preferring a simulator that's already booted,
    # since a cold one's first test launch can be slow enough to time out. simctl is used rather
    # than `xcodebuild -showdestinations`, which can list no simulators while CoreSimulator starts.
    # Lines look like: "-- iOS 26.5 --", then "    iPhone 17 (<uuid>) (Booted)"
    SIM_SDK="$(xcrun --sdk iphonesimulator --show-sdk-version)"
    TEST_SIM="$(xcrun simctl list devices available 2>/dev/null | awk -v sdk="$SIM_SDK" '
        function ver(v,  p) { split(v, p, "."); return p[1] * 1000 + p[2] }
        /^-- iOS [0-9.]+ --$/ { os = (ver($3) <= ver(sdk)) ? $3 : ""; next }
        /^-- / { os = ""; next }
        os != "" && /^ +iPhone/ && match($0, / \([0-9A-F-]+\) \(/) {
          name = substr($0, 1, RSTART - 1); sub(/^ +/, "", name)
          id = substr($0, RSTART + 2, RLENGTH - 5)
          print os "|" ($0 ~ /\(Booted\) *$/ ? 1 : 0) "|" name "|" id
        }' | sort -V | tail -n1 || true)"
    [ -n "$TEST_SIM" ] \
      || fail "No iPhone simulator found for the tests. Install one in Xcode, set TEST_DESTINATION, or pass --skip-tests"
    IFS='|' read -r TEST_SIM_OS _ TEST_SIM_NAME TEST_SIM_ID <<< "$TEST_SIM"
    TEST_DESTINATION="platform=iOS Simulator,id=$TEST_SIM_ID"
    TEST_DESTINATION_LABEL="$TEST_SIM_NAME (iOS $TEST_SIM_OS)"
  else
    TEST_DESTINATION_LABEL="$TEST_DESTINATION"
  fi
fi

if runs_until docs && ! $SKIP_DOCS; then
  command -v bundle >/dev/null || fail "'bundle' is not installed. See Requirements in --help"
  bundle exec jazzy --version >/dev/null 2>&1 \
    || fail "jazzy doesn't run through Bundler. Run 'bundle install' (see Requirements in --help) and 'bundle exec jazzy --version' to see why, or pass --skip-docs"
fi

if runs_until release; then
  command -v gh >/dev/null || fail "'gh' is not installed"
  $DRY_RUN || gh auth status >/dev/null 2>&1 || fail "gh is not authenticated. Run 'gh auth login'"
fi

# Checked up front so a missing login or an unsupported Xcode stops the run before anything
# is pushed, not after the tag and release are already out.
if runs_until pod; then
  command -v pod >/dev/null || fail "'pod' is not installed"

  POD_SKIP_HINT="Or pass --until release and publish to CocoaPods later."

  # A dry run only prints the pod commands, so these problems are warnings there
  pod_preflight_fail() { if $DRY_RUN; then warn "$1 (ignored for --dry-run)"; else fail "$1 $POD_SKIP_HINT"; fi; }

  if ! TRUNK_ME="$(pod trunk me 2>/dev/null)"; then
    pod_preflight_fail "Not logged in to CocoaPods trunk. Run 'pod trunk register <email> \"<name>\"' and click the email link."
  elif ! grep -q -- "- $POD_NAME\$" <<< "$TRUNK_ME"; then
    pod_preflight_fail "Your CocoaPods trunk account isn't an owner of $POD_NAME. Ask an owner (see 'pod trunk info $POD_NAME') to run 'pod trunk add-owner $POD_NAME <your-email>'."
  fi

  if [ "$XCODE_MAJOR" -gt "$MAX_IOS11_XCODE" ]; then
    pod_preflight_fail "Xcode $XCODE_MAJOR can't build for the podspec's iOS 11 target, so 'pod spec lint' would fail. Install Xcode $MAX_IOS11_XCODE next to it (see Requirements in --help)."
  fi
fi

if ! git diff --quiet || ! git diff --cached --quiet; then
  fail "You have uncommitted changes to tracked files. Commit or discard them first."
fi

# 2. Get onto an up-to-date master
step "Updating $MAIN_BRANCH"

if [ "$(git rev-parse --abbrev-ref HEAD)" != "$MAIN_BRANCH" ]; then
  git checkout "$MAIN_BRANCH"
fi
git pull --ff-only "$REMOTE" "$MAIN_BRANCH"
git fetch --tags "$REMOTE"

CURRENT_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$INFO_PLIST")"
PODSPEC_VERSION="$(sed -n "s/^ *spec\.version *= *'\(.*\)'.*/\1/p" "$PODSPEC")"

[ "$CURRENT_VERSION" = "$PODSPEC_VERSION" ] \
  || fail "$INFO_PLIST ($CURRENT_VERSION) and $PODSPEC ($PODSPEC_VERSION) disagree on the current version"

[[ "$CURRENT_VERSION" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]] \
  || fail "Current version '$CURRENT_VERSION' doesn't look like X.Y.Z"

MAJOR="${BASH_REMATCH[1]}"
MINOR="${BASH_REMATCH[2]}"
PATCH="${BASH_REMATCH[3]}"

case "$STRATEGY" in
  patch) PATCH=$((PATCH + 1)) ;;
  minor) MINOR=$((MINOR + 1)); PATCH=0 ;;
  major) MAJOR=$((MAJOR + 1)); MINOR=0; PATCH=0 ;;
esac

if [ "$STRATEGY" = "explicit" ]; then
  NEW_VERSION="$BUMP"
  [ "$NEW_VERSION" != "$CURRENT_VERSION" ] || fail "Version is already $CURRENT_VERSION"
  HIGHEST="$(printf '%s\n%s\n' "$CURRENT_VERSION" "$NEW_VERSION" | sort -V | tail -n1)"
  [ "$HIGHEST" = "$NEW_VERSION" ] || fail "New version $NEW_VERSION is lower than current version $CURRENT_VERSION"
else
  NEW_VERSION="$MAJOR.$MINOR.$PATCH"
fi
TAG="v$NEW_VERSION"

if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
  fail "Tag $TAG already exists"
fi

echo "Current version: $CURRENT_VERSION"
echo "New version:     $NEW_VERSION ($TAG, $STRATEGY)"
echo "Release message: $MESSAGE"
echo "Run until:       $UNTIL$($DRY_RUN && echo " (dry run)")"

# jazzy only documents the files matched by `include` in .jazzy.yaml and sorts types by its
# `custom_categories`. Public types added since the last release that it doesn't mention would
# be missing from the docs or listed under "Other", so flag them before anything changes.
if runs_until docs && ! $SKIP_DOCS; then
  step "Checking $JAZZY_CONFIG for new public types"
  PREV_TAG="v$CURRENT_VERSION"

  if git rev-parse -q --verify "refs/tags/$PREV_TAG" >/dev/null; then
    MISSING_TYPES="$(LC_ALL=C comm -13 <(public_types_at "$PREV_TAG") <(public_types_at HEAD) \
      | while read -r type; do grep -qE "^ *- $type\$" "$JAZZY_CONFIG" || echo "$type"; done)"

    if [ -n "$MISSING_TYPES" ]; then
      warn "These public types are new since $PREV_TAG but aren't in $JAZZY_CONFIG."
      warn "Add them to 'include' and 'custom_categories', or they'll be missing from the docs or listed under \"Other\":"
      sed 's/^/  - /' <<< "$MISSING_TYPES"
      confirm "Continue without them?"
    else
      echo "Every public type added since $PREV_TAG is in $JAZZY_CONFIG."
    fi
  else
    warn "Tag $PREV_TAG not found, so new public types can't be checked against $JAZZY_CONFIG"
  fi
fi

runs_until bump && confirm "Bump $CURRENT_VERSION -> $NEW_VERSION?"

# 3. Tests. Run before anything changes, so a failure leaves the repo as it was.
if $SKIP_TESTS; then
  step "Skipping tests"
else
  step "Running $($WITH_INTEGRATION && echo "unit and integration" || echo "unit") tests on $TEST_DESTINATION_LABEL"

  TEST_ARGS=(test -workspace "$WORKSPACE" -scheme "$SCHEME" -destination "$TEST_DESTINATION" -quiet)
  if ! $WITH_INTEGRATION; then
    for test_class in $INTEGRATION_TEST_CLASSES; do
      TEST_ARGS+=("-skip-testing:$TEST_TARGET/$test_class")
    done
  fi
  # A cold simulator can take long enough to boot that the test runner times out, so boot the
  # one we picked and wait for it first
  if [ -n "${TEST_SIM_ID:-}" ]; then
    echo "Booting the simulator..."
    xcrun simctl bootstatus "$TEST_SIM_ID" -b >/dev/null || fail "Couldn't boot the $TEST_DESTINATION_LABEL simulator"
  fi

  if [ "$XCODE_MAJOR" -gt "$MAX_IOS11_XCODE" ]; then
    warn "Xcode $XCODE_MAJOR can't build for iOS 11, so the tests build for iOS $NEW_XCODE_IOS_TARGET (local only)"
    TEST_ARGS+=("IPHONEOS_DEPLOYMENT_TARGET=$NEW_XCODE_IOS_TARGET")
  else
    # The OHHTTPStubs test pod targets iOS 8, which recent Xcodes can't link (no libarclite).
    # Building every target for the podspec's iOS target lifts it without changing the SDK's.
    TEST_ARGS+=("IPHONEOS_DEPLOYMENT_TARGET=$IOS_TARGET")
  fi

  TEST_LOG="$(mktemp -t publish-tests)"
  run_tests() { xcodebuild "${TEST_ARGS[@]}" 2>&1 | tee "$TEST_LOG"; }
  TESTS_FAILED="Tests failed, so nothing has been changed. Fix them, or pass --skip-tests to release anyway"

  if ! run_tests; then
    # A simulator's first test launch can outlast xcodebuild's startup timeout. It's warm after that.
    grep -q "test runner timed out while preparing" "$TEST_LOG" || fail "$TESTS_FAILED"
    warn "The test runner timed out starting up, which a simulator's first launch can do. Trying once more"
    run_tests || fail "$TESTS_FAILED"
  fi
  rm -f "$TEST_LOG"
fi
reached test

# 4. Replace the version. Only the plist and podspec are touched on purpose, so
# Gemfile.lock, project.pbxproj and README.md never get caught by a find & replace.
step "Bumping version in $INFO_PLIST and $PODSPEC"

/usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $NEW_VERSION" "$INFO_PLIST"
sed -i '' \
  -e "s/^\( *spec\.version *= *\)'$CURRENT_VERSION'/\1'$NEW_VERSION'/" \
  -e "s/:tag => 'v$CURRENT_VERSION'/:tag => '$TAG'/" \
  "$PODSPEC"

[ "$(sed -n "s/^ *spec\.version *= *'\(.*\)'.*/\1/p" "$PODSPEC")" = "$NEW_VERSION" ] \
  || fail "Failed to update spec.version in $PODSPEC"
grep -q ":tag => '$TAG'" "$PODSPEC" || fail "Failed to update :tag in $PODSPEC"

git --no-pager diff --stat -- "$INFO_PLIST" "$PODSPEC"
reached bump

# 5. Regenerate documentation
if $SKIP_DOCS; then
  step "Skipping docs generation"
else
  step "Regenerating docs with jazzy"
  # Same as the docs' `-b CODE_SIGN_IDENTITY="",CODE_SIGNING_REQUIRED=NO` once the shell drops the quotes
  JAZZY_BUILD_ARGS="CODE_SIGN_IDENTITY=,CODE_SIGNING_REQUIRED=NO"
  if [ "$XCODE_MAJOR" -gt "$MAX_IOS11_XCODE" ]; then
    warn "Xcode $XCODE_MAJOR can't build for iOS 11, so the docs build for iOS $NEW_XCODE_IOS_TARGET (local only)"
    JAZZY_BUILD_ARGS="$JAZZY_BUILD_ARGS,IPHONEOS_DEPLOYMENT_TARGET=$NEW_XCODE_IOS_TARGET"
  fi
  bundle exec jazzy -b "$JAZZY_BUILD_ARGS"
fi
reached docs

# 6. Commit. Only the version files and docs are staged, so stray untracked files stay out.
step "Committing version bump"

git add "$INFO_PLIST" "$PODSPEC" "$DOCS_DIR"
git commit -m "Version Bump"
reached commit

# 7. Tag and push
step "Tagging $TAG and pushing to $REMOTE/$MAIN_BRANCH"

confirm "Push the 'Version Bump' commit and tag $TAG to $REMOTE/$MAIN_BRANCH?"
remote_run git tag -a "$TAG" -m "$MESSAGE"
remote_run git push "$REMOTE" "$MAIN_BRANCH" --follow-tags
reached push

# 8. GitHub release
step "Creating GitHub release $TAG"

remote_run gh release create "$TAG" --title "$MESSAGE" --generate-notes --verify-tag --latest
reached release

# 9. CocoaPods
step "Linting podspec"
remote_run pod spec lint "$PODSPEC" --allow-warnings

step "Publishing to CocoaPods trunk"
confirm "Push $PODSPEC $NEW_VERSION to CocoaPods trunk?"
remote_run pod trunk push "$PODSPEC" --allow-warnings

step "Done: $TAG"
if $DRY_RUN; then
  echo "Dry run: the 'Version Bump' commit was made locally but nothing was pushed."
  echo "To undo it: git reset --hard $REMOTE/$MAIN_BRANCH"
fi
