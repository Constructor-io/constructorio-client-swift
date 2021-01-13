<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" /> <img src="https://img.shields.io/badge/Swift-3.0+-blue.svg" alt="Swift 3+ compatible" /> <img src="https://img.shields.io/badge/Objective--C-compatible-blue.svg" alt="Objective-C compatible" /> <img  src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />

# Constructor.io Swift Client

An iOS Client for [Constructor.io](http://constructor.io/).  [Constructor.io](http://constructor.io/) provides search as a service that optimizes results using artificial intelligence (including natural language processing, re-ranking to optimize for conversions, and user personalization).

## 1. Import

### 1.a Import using CocoaPods

First make sure you have [CocoaPods installed](https://guides.cocoapods.org/using/getting-started.html).  Then create an empty text file in your project’s root directory called ‘Podfile’. Add the following lines to the file:

```use_frameworks!
target ‘YOUR_TARGET_NAME’ do
   pod ‘ConstructorAutocomplete'
end
```

Open the terminal (make sure you’re located in the project root) and type

```bash
pod install
```

### 1.b Import using Carthage

First, make sure you have [Carthage installed](https://github.com/Carthage/Carthage#installing-carthage). Then create an empty text file called ‘Cartfile’ in your project root directory. Now, add the following lines:

```
github "Constructor-io/constructorio-client-swift"
```

Open the terminal (make sure you’re located in the project root) and type

```bash
carthage update
```

Drag the ```ConstructorIO.framework``` from Carthage/Build/iOS into your project and link it with your application target. Also, make sure to copy the framework by adding a new Copy Files phase.

## 2. Retrieve an API key

You can find this in your [Constructor.io dashboard](https://constructor.io/dashboard).  Contact sales if you'd like to sign up, or support if you believe your company already has an account.

## 3. Create a Client Instance

Make sure to import the `ConstructorAutocomplete` module at the top of your source file and then write the following

```swift
// Create the client config
let config = ConstructorIOConfig(
   apiKey: "YOUR API KEY",
   resultCount: AutocompleteResultCount(numResultsForSection: ["Search Suggestions" : 3, "Products" : 0])
)

// Create the client instance
let constructor = ConstructorIO(config: config)

// Set the user ID (if a logged in and known user) for cross device personalization
constructor.userID = "abcdefghijk-123"
```

## 4. Request Autocomplete Results

```swift
let query = CIOAutocompleteQuery(query: "Dav")
constructor.autocomplete(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 5. Request Search Results

```swift
let filters = SearchFilters(groupFilter: "Bread", facetFilters: [
  (key: "Nutrition", value: "Organic"),
  (key: "Nutrition", value: "Natural"),
  (key: "Nutrition", value: "Whole-grain")
])
let query = CIOSearchQuery(query: "Dave's Bread", page: 5, filters: filters)
constructor.search(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 6. Request Browse Events

```swift
let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet")
constructor.browse(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 7. Instrument Behavioral Events

The iOS Client sends behavioral events to [Constructor.io](http://constructor.io/) in order to continuously learn and improve results for future Autosuggest and Search requests.  The Client only sends events in response to being called by the consuming app or in response to user interaction . For example, if the consuming app never calls the SDK code, no events will be sent.  Besides the explicitly passed in event parameters, all user events contain a GUID based user ID that the client sets to identify the user as well as a session ID.

Three types of these events exist:

1. **General Events** are sent as needed when an instance of the Client is created or initialized
1. **Autocomplete Events** measure user interaction with autocomplete results
1. **Search Events** measure user interaction with search results

### Autocomplete Events

```swift
// Track when the user focuses into the search bar
constructorIO.trackInputFocus(searchTerm: "")

// Track when the user selects an autocomplete suggestion
constructorIO.trackAutocompleteSelect(searchTerm: "toothpicks", originalQuery: "tooth", sectionName: "Search Suggestions", resultID: "179b8a0e-3799-4a31-be87-127b06871de2")

// Track when the user submits a search (either by selecting a suggestion or not selecting a suggestion)
constructorIO.trackSearchSubmit(searchTerm: "toothpicks", originalQuery: "tooth")
```

### Search Events

```swift
// Track when search results are loaded into view
constructorIO.trackSearchResultsLoaded(searchTerm: "tooth", resultCount: 789)

// Track when a search result is clicked
constructorIO.trackSearchResultClick(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", searchTerm: "tooth", sectionName: "Products",  resultID: "179b8a0e-3799-4a31-be87-127b06871de2")

// Track when a search result converts (a.k.a. is added to cart)
constructorIO.trackConversion(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", revenue: 12.99, searchTerm: "tooth")

// Track when products are purchased
constructorIO.trackPurchase(customerIDs: ["123-AB", "456-CD"])
```

### Browse Events

```swift
// Track when browse results are loaded into view
constructorIO.trackBrowseResultsLoaded(filterName: "Category", filterValue: "Snacks", resultCount: 674)

// Track when a browse result is clicked
constructorIO.trackBrowseResultClick(filterName: "Category", filterValue: "Snacks", customerID: "7654321-BA", resultPositionOnPage: 4, sectionName: "Products", resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
```
