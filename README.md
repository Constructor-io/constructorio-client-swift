<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" /> <img src="https://img.shields.io/badge/Swift-3.0+-blue.svg" alt="Swift 3+ compatible" /> <img src="https://img.shields.io/badge/Objective--C-compatible-blue.svg" alt="Objective-C compatible" /> <img  src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />

# Constructor.io Swift Client

An iOS Client for [Constructor.io](http://constructor.io/).  [Constructor.io](http://constructor.io/) provides search as a service that optimizes results using artificial intelligence (including natural language processing, re-ranking to optimize for conversions, and user personalization).

## Documentation
Full API documentation is available on [Github Pages](https://constructor-io.github.io/constructorio-client-swift/)

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

### 1.c Import using Swift Package Manager

To install using SwiftPM. Go into Xcode and click on `File` > `Add Package Dependency` and enter [Constructor's Swift Client repository URL](https://github.com/constructor-io/constructorio-client-swift).

If you develop frameworks and would like to utilize the Swift API Client as a dependency, update your `Package.swift` file with the following:

```swift
let package = Package(
    // 3.3.12 ..< 4.0.0
    dependencies: [
        .package(url: "https://github.com/constructor-io/constructorio-client-swift", from: "3.3.12")
    ],
    // ...
)
```

Lastly, you'll just need to import `ConstructorAutocomplete` to your source files to begin using it.

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
let constructorIO = ConstructorIO(config: config)

// Set the user ID (for a logged in user) used for cross device personalization
constructorIO.userID = "abcdefghijk-123"
```

## 4. Retrieving the clientID and sessionID
If you are retrieving results from your backend servers instead of direclty using our SDK, there are certain personalization parameters that are needed to be passed along with your requests. And those parameters can be accessed from the Constructor instance.

1. **Client Id**

```swift
let constructorClientId = constructorIO.clientID
```
2. **Session Id**

```swift
let constructorSessionId = constructorIO.sessionID
```

In most cases, you will want to store those parameters as cookies preferably as **ConstructorioID_client_id** and **ConstructorioID_session_id** to be sent with your requests to your backend servers.

## 5. Setting test cell information for A/B tests
When A/B testing, it is important to specify which cell the user is being assigned to. Information about the test cell can be set through the `ConstructorIOConfig` object.

```kotlin
let testCell = CIOABTestCell

let config = ConstructorIOConfig(
   apiKey: "YOUR API KEY",
   testCells: [CIOABTestCell(key: "constructorio_test", value: "control_1")]
)

// Create the client instance
let constructorIO = ConstructorIO(config: config)

// The test cells in the config can be edited after instantiating the client instance
constructorIO.config.testCells = [CIOABTestCell(key: "constructorio_test", value: "experiment_1")]
```

## 6. Request Autocomplete Results

```swift
let query = CIOAutocompleteQuery(query: "apple", numResultsForSection: ["Products": 6, "Search Suggestions": 8])

constructorIO.autocomplete(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 7. Request Search Results

```swift
let filters = CIOQueryFilters(groupFilter: "Bread", facetFilters: [
  (key: "Nutrition", value: "Organic"),
  (key: "Nutrition", value: "Natural"),
  (key: "Nutrition", value: "Whole-grain")
])
let query = CIOSearchQuery(query: "Dave's Bread", page: 5, filters: filters)

// Specify the sort order in which groups are returned
let groupsSortOption = CIOGroupsSortOption(sortBy: CIOGroupsSortBy.value, sortOrder: CIOGroupsSortOrder.ascending)

constructorIO.search(forQuery: query, filters: filters, groupsSortOption: groupsSortOption) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 8. Request Browse Results

```swift
let query = CIOBrowseQuery(filterName: "potato", filterValue: "russet")

// Specify the sort order in which groups are returned
let groupsSortOption = CIOGroupsSortOption(sortBy: CIOGroupsSortBy.value, sortOrder: CIOGroupsSortOrder.ascending)

constructorIO.browse(forQuery: query, groupsSortOption: groupsSortOption) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 9. Request Recommendation Results

```swift
let query = CIORecommendationsQuery(podID: "pdp_best_sellers", filters: filters)

constructorIO.recommendations(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

### With an item id for the alternative/complementary items recommendations strategy
```swift
let itemId = "P18232"
let query = CIORecommendationsQuery(podID: "pdp_complementary_items", itemID: itemId)

constructorIO.recommendations(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

### With filters for the filtered item recommendations strategy
```swift
let filters = CIOQueryFilters(groupFilter: "cat_1234", facetFilters: [
  (key: "Nutrition", value: "Organic"),
  (key: "Nutrition", value: "Natural"),
  (key: "Brand", value: "Kroger")
])
let query = CIORecommendationsQuery(podID: "pdp_filtered_items", filters: filters)

constructorIO.recommendations(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 10. Request Quiz Next Question

```swift
let query = CIOQuizQuery(quizID: "quiz-1", answers: [["1"], ["2"]])

constructorIO.getQuizNextQuestion(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 11. Request Quiz Results

```swift
let query = CIOQuizQuery(quizID: "quiz-1", answers: [["1"], ["2"]])

constructorIO.getQuizResults(forQuery: query) { (response) in
  let data = response.data!
  let error = response.error!
  // ...
}
```

## 12. Instrument Behavioral Events

The iOS Client sends behavioral events to [Constructor.io](http://constructor.io/) in order to continuously learn and improve results for future Autosuggest and Search requests.  The Client only sends events in response to being called by the consuming app or in response to user interaction . For example, if the consuming app never calls the SDK code, no events will be sent.  Besides the explicitly passed in event parameters, all user events contain a GUID based user ID that the client sets to identify the user as well as a session ID.

Three types of these events exist:

1. **General Events** are sent as needed when an instance of the Client is created or initialized
2. **Autocomplete Events** measure user interaction with autocomplete results
3. **Search Events** measure user interaction with search results
4. **Browse Events** measure user interaction with browse results
5. **Recommendation Events** measure user interaction with recommendations
6. **Quiz Events** measure user interaction with quiz results
7. **Conversion Events** measure user events like `add to cart` or `purchase`

### Autocomplete Events

```swift
// Track when the user focuses into the search bar
constructorIO.trackInputFocus(searchTerm: "")

// Track when the user selects an autocomplete suggestion
constructorIO.trackAutocompleteSelect(searchTerm: "toothpicks", originalQuery: "tooth", sectionName: "Search Suggestions", group: CIOGroup(displayName: "Dental Health", groupID: "dental-92dk2", path: "health-2911e/dental-92dk2"), resultID: "179b8a0e-3799-4a31-be87-127b06871de2")

// Track when the user submits a search (either by selecting a suggestion or not selecting a suggestion)
constructorIO.trackSearchSubmit(searchTerm: "toothpicks", originalQuery: "tooth")
```

### Search Events

```swift
// Track when search results are loaded into view (customer ID's are the ID's of shown items)
constructorIO.trackSearchResultsLoaded(searchTerm: "tooth", resultCount: 789, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"])

// Track when a search result is clicked
constructorIO.trackSearchResultClick(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-7463", searchTerm: "tooth", sectionName: "Products",  resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
```

### Browse Events

```swift
// Track when browse results are loaded into view
constructorIO.trackBrowseResultsLoaded(filterName: "Category", filterValue: "Snacks", resultCount: 674)

// Track when browse results are loaded into view with items array (supported in v3.1.2 and above)
constructorIO.trackBrowseResultsLoaded(filterName: "Category", filterValue: "Snacks", resultCount: 674, customerIDs: ["1234567-AB", "1234765-CD", "1234576-DE"])

// Track when a browse result is clicked
constructorIO.trackBrowseResultClick(filterName: "Category", filterValue: "Snacks", customerID: "7654321-BA", variationID: "7654321-BA-738", resultPositionOnPage: 4, sectionName: "Products", resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
```

### Recommendations Events

```swift
// Track when recommendation results are viewed
constructorIO.trackRecommendationResultsView(podID: "pdp_best_sellers", numResultsViewed: 5, resultPage: 1, resultCount: 10, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")

// Track when a recomendation result is clicked
constructorIO.trackRecommendationResultClick(podID: "pdp_best_sellers", strategyID: "best_sellers", customerID: "P183021", variationID: "7281930", numResultsPerPage: 30, resultPage: 1, resultCount: 15, resultPositionOnPage: 1, resultID: "179b8a0e-3799-4a31-be87-127b06871de2")
```

### Quiz Events

```swift
// Track when a quiz result is clicked
ConstructorIo.trackQuizResultClick(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "123", customerID: "123", itemName: "espresso")

// Track when quiz results are loaded
ConstructorIo.trackQuizResultsLoaded(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "123", resultCount: 20)

// Track when a quiz result is converted on
ConstructorIo.trackQuizConversion(quizID: "coffee-quiz", quizVersionID: "1231244", quizSessionID: "123", customerID: "123", variationID: "167", itemName: "espresso", revenue: 20.0)

```

### Conversion Events

```swift
// Track when an item converts (a.k.a. is added to cart) regardless of the user journey that led to adding to cart
constructorIO.trackConversion(itemName: "Fashionable Toothpicks", customerID: "1234567-AB", variationID: "1234567-AB-47398", revenue: 12.99, searchTerm: "tooth", conversionType: "add_to_cart")

// Track when items are purchased
constructorIO.trackPurchase(customerIDs: ["123-AB", "456-CD"], revenue: 34.49, orderID: "343-315")

// Tracking items w/ variations in purchases (supported in v2.5.5 and above)
let purchaseItems = [
  CIOItem(customerID: "custID1", variationID: "varID1", quantity: 2),
  CIOItem(customerID: "custID2", variationID: "varID2", quantity: 3)
]
constructorIO.trackPurchase(items: purchaseItems, revenue: 93.89, orderID: "423-2432")
```

### Miscellaneous Events

```swift
// Track when a product detail page is loaded (a.k.a after a user clicks on an item)
constructorIO.trackItemDetailLoad(customerID: "10001", itemName: "item1", variationID: "var1", sectionName: "Products")
```
