# Constructor Demo App

A small SwiftUI shop for trying out the SDK's tracking **debug mode**, and later, user journey validation. It builds the SDK from this repo's source as a local Swift package, so it always runs your current changes.

## Running it

1. Open `DemoApp/ConstructorDemo.xcodeproj`. Open this project directly, not `AutocompleteClient.xcworkspace`.
2. Select the `ConstructorDemo` scheme and an iOS 16+ simulator.
3. Run.

The demo opens on the **Home** tab. Tap the green **FreshCart** logo at the top of any screen to come back to it. Home shows a carousel of featured products. **Start shopping** opens the Shop tab with an empty search, closing any search or product page left open there. It starts with debug mode **on** and uses the public demo index (`key_K2hlXt5aVSwoI1Uw`), which is a grocery store. Change the key in the **Settings** tab.

## The search journey

Each step fires the tracking call a real integration should make:

| Step in the app | Event |
| --- | --- |
| Tap the search field | `input_focus` |
| Tap a popular search (shown while the field is empty) | `autocomplete_select` + `search_submit` |
| Tap a suggestion | `autocomplete_select` |
| Press Search on the keyboard | `search_submit` |
| Results appear | `search_results_loaded` |
| Tap a result | `search_result_click` |
| Product page opens | `item_detail_load` |
| Add to Cart | `conversion` (`add_to_cart`) |
| Place Order (Cart tab) | `purchase` |

Tap the SDK's floating debug button to open the debug screen. It has two tabs, **Events** and **Tracking Journeys**:

- **Events** lists every event live, newest first, with its order number and success or failure. Tap an event to see its URL, query parameters and POST body, or to share it.
- **Tracking Journeys** lists the journeys to test. Tap **Search to purchase** to see its steps, then tap **Record** and walk the steps above in the app. While recording, the button shows a red ring and progress such as `3/6`. Tap it to come back and tap **Stop**. The results show each step as valid and in order, out of order, with parameter issues, rejected by the API, or missing, plus any duplicate events or events outside the journey. Tap a step to see every parameter check.

Everything is also printed to the Xcode console with the `[ConstructorIO]: [Debug]` prefix, including each journey check and the full report when recording stops. Flip **SDK debug mode** off in Settings to confirm nothing gets recorded.

The journey checks `input_focus`, `search_submit`, `search_results_loaded`, `search_result_click`, `item_detail_load`, `conversion` (`add_to_cart`) and `purchase`. Autocomplete select isn't part of the journey, so it appears under "Other events". The demo's product page sends an empty item ID, so the `item_detail_load` step shows a parameter issue. To match the journey, type a search and press Search on the keyboard. Tapping a suggestion fires `autocomplete_select` instead of `search_submit`, so the submit step shows as missing.

If the API can't be reached, search falls back to a small built-in grocery catalog so the journey can still be walked through. Tracking calls are still made and appear in Events as failed, and as rejected steps in a journey recording.

## UI tests

`ConstructorDemoUITests` walks the whole journey and checks that every event appears in the SDK's event log:

```sh
xcodebuild test -project DemoApp/ConstructorDemo.xcodeproj -scheme ConstructorDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

These tests hit the live API.

## Where things are

```
ConstructorDemo/
  App/          entry point, tabs, config (API key)
  Services/     ConstructorService (owns the client),
                SearchModel (search journey + tracking), FeaturedModel (Home carousel),
                SampleCatalog (offline fallback)
  Models/       Product, Cart
  Views/        Home, Search, Cart, Settings
```

## Journey file

Journeys are defined in [`debug/journeys.json`](../debug/journeys.json) at the repo root. The demo passes that local file to the SDK through `ConstructorIOConfig(debugJourneysURL:)`, and the SDK loads it when debug mode turns on and each time the Tracking Journeys tab opens. Edit the JSON, then pull down on the Tracking Journeys list to reload it without rebuilding.

The demo finds the file from its own source path, so this works in the simulator only. In a real integration `debugJourneysURL` would point to a hosted file.
