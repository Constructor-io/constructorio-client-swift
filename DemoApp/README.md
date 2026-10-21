# Constructor Demo App

A small SwiftUI shop for trying out the SDK's tracking **debug mode**, and later, user journey validation. It builds the SDK from this repo's source as a local Swift package, so it always runs your current changes.

## Running it

1. Open `DemoApp/ConstructorDemo.xcodeproj`. Open this project directly, not `AutocompleteClient.xcworkspace`.
2. Select the `ConstructorDemo` scheme and an iOS 16+ simulator.
3. Run.

The demo starts with debug mode **on** and uses the public demo index (`key_K2hlXt5aVSwoI1Uw`), which is a grocery store. Change the key under **Events → ⚙︎**.

## The search journey

Each step fires the tracking call a real integration should make:

| Step in the app | Event |
| --- | --- |
| Tap the search field | `input_focus` |
| Tap a suggestion | `autocomplete_select` |
| Press Search on the keyboard | `search_submit` |
| Results appear | `search_results_loaded` |
| Tap a result | `search_result_click` |
| Product page opens | `item_detail_load` |
| Add to Cart | `conversion` (`add_to_cart`) |
| Place Order (Cart tab) | `purchase` |

The **Events** tab lists every event live, newest first, with its order number and success or failure. Tap an event to see its URL, query parameters and POST body, or to share it. The same events are printed to the Xcode console with the `[ConstructorIO]: [Debug]` prefix. Flip **Debug mode** off to confirm nothing gets recorded.

If the API can't be reached, search falls back to a small built-in grocery catalog so the journey can still be walked through. Tracking calls are still made and appear in Events as failed.

## UI tests

`ConstructorDemoUITests` walks the whole journey and checks that every event appears in the Events tab:

```sh
xcodebuild test -project DemoApp/ConstructorDemo.xcodeproj -scheme ConstructorDemo \
  -destination 'platform=iOS Simulator,name=iPhone 16'
```

These tests hit the live API.

## Where things are

```
ConstructorDemo/
  App/          entry point, tabs, config (API key)
  Services/     ConstructorService (owns the client), DebugEventStore (CIODebugEventListener),
                SearchModel (search journey + tracking), SampleCatalog (offline fallback)
  Models/       Product, Cart
  Views/        Search, Cart, Events
```

`DebugEventStore` is the integration point for upcoming work. A journey validator will be another `CIODebugEventListener`, registered the same way in `ConstructorService`.
