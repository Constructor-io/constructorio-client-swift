# Maintainers

> [!NOTE]
> Only CocoaPods maintainers (trunk owners of `ConstructorAutocomplete`) can deploy to CocoaPods. Anyone with push access to `master` can run the other steps, so if you aren't an owner, run the script with `--until release` and ask an owner to publish to CocoaPods. See [One-time setup](#one-time-setup) to become one.

## Publishing a release

Releases are cut locally with `./publish.sh`, run from `master` after the PR is merged. It runs the tests, bumps the version, regenerates the docs, tags the release, creates the GitHub release and publishes to CocoaPods.

```bash
# Pick a version strategy (patch/minor/major, or an exact X.Y.Z) and a release title
./publish.sh minor "Add Product Insights Agent tracking"

# Rehearse it: makes the local commit, but only prints the push / release / pod commands
./publish.sh minor "Add Product Insights Agent tracking" --dry-run
```

The script runs these milestones in order, and `--until <milestone>` stops after any of them:

1. `test` runs the unit tests on the newest iPhone simulator, before anything changes. Add `--with-integration` to also run the integration tests, which hit the live API
2. `bump` updates the version in `AutocompleteClient/Info.plist` and `ConstructorAutocomplete.podspec`
3. `docs` regenerates `docs/` with jazzy
4. `commit` commits the "Version Bump" locally
5. `push` tags `vX.Y.Z` and pushes `master` with the tag. This is also the Swift Package Manager release, since SPM resolves versions from tags
6. `release` creates the GitHub release with generated notes
7. `pod` runs `pod spec lint` and `pod trunk push` (the default)

It asks for confirmation before the bump, the push and the CocoaPods push (`--yes` skips this). `--skip-tests` and `--skip-docs` skip those steps, and `TEST_DESTINATION` picks a different simulator. See `./publish.sh --help` for every option.

### One-time setup

- **GitHub CLI**: `gh auth login`
- **jazzy**: the docs use the jazzy pinned in `Gemfile.lock`, run through Bundler on Homebrew's Ruby 3.4. The macOS system Ruby can't build its native gems on Apple Silicon, and Ruby 4 breaks the pinned gems.
  ```bash
  brew install ruby@3.4 && /opt/homebrew/opt/ruby@3.4/bin/bundle install
  ```
- **CocoaPods trunk**: you need a trunk session as an owner of `ConstructorAutocomplete`. Register with `pod trunk register <email> '<name>'`, then ask an existing owner (`pod trunk info ConstructorAutocomplete`) to run `pod trunk add-owner ConstructorAutocomplete <email>`.

The script checks all of these before it changes anything, so a missing login stops the run before the tag and release are out.

### Xcode 27 and CocoaPods

The project and podspec target iOS 11, and Xcode 27+ can't build for it, so `pod spec lint` fails there. Install Xcode 26 next to your current Xcode (this needs your Apple ID). The script switches to it whenever Xcode 27+ is selected, so the tests, docs and CocoaPods publish all build for the real iOS 11 target:

```bash
brew install xcodes aria2
xcodes install 26.6 --experimental-unxip --directory /Applications
DEVELOPER_DIR=/Applications/Xcode-26.6.0.app/Contents/Developer xcodebuild -downloadPlatform iOS
```

It leaves your selected Xcode alone. Set `DEVELOPER_DIR` to choose another Xcode for the run.

Without Xcode 26, the script builds the tests and docs for iOS 15 instead. That only affects those local builds, so they can't catch an API newer than iOS 11 used without an `@available` check. The `pod` milestone can't run at all, so stop before it and have an owner with Xcode 26 publish from the tag:

```bash
./publish.sh minor "..." --until release

# Later, with Xcode 26
git checkout vX.Y.Z
pod spec lint --allow-warnings
pod trunk push --allow-warnings
```

### Before you release

- New public types need adding to `.jazzy.yaml` (`include` and `custom_categories`) in the same PR, or they won't appear in the docs. Picking the category is up to you, but the script lists any public type added since the last release tag that `.jazzy.yaml` doesn't mention, and asks before it continues
- When `--until` stops a run, the script prints what state the repo is in and how to undo it. If a step fails instead, check `git log` and `git ls-remote --tags origin` to see how far it got before re-running
