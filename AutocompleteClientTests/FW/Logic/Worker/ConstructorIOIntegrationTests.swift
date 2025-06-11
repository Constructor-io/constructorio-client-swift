//
//  ConstructorIOIntegrationTests.swift
//  AutocompleteClientTests
//
//  Copyright (c) Constructor.io Corporation. All rights reserved.
//  http://constructor.io/
//

import ConstructorAutocomplete
import XCTest

// swiftlint:disable type_body_length file_length
class ConstructorIOIntegrationTests: XCTestCase {

    fileprivate let testACKey = "key_vM4GkLckwiuxwyRA"
    fileprivate let searchTerm = "item"
    fileprivate let session = 90
    fileprivate let groupFilterName = "group_id"
    fileprivate let groupFilterValue = "BrandA"
    fileprivate let collectionFilterName = "collection_id"
    fileprivate let collectionFilterValue = "test"
    fileprivate let resultCount = 123
    fileprivate let resultPositionOnPage = 3
    fileprivate let revenue = 7.99
    fileprivate let orderID = "234641"
    fileprivate let sectionName = "Products"
    fileprivate let itemName = "Item1"
    fileprivate let customerID = "10001"
    fileprivate let customerIDs = ["10001", "10002"]
    fileprivate let originalQuery = "pork#@#??!!asd"
    fileprivate let group = CIOGroup(displayName: "groupName1", groupID: "groupID2", path: "path/to/group")
    fileprivate let podID = "item_page_1"
    fileprivate let strategyID = "alternative_items"
    fileprivate let numResultsPerPage = 5
    fileprivate let numResultsViewed = 5
    fileprivate let resultPage = 1
    fileprivate let conversionType = "add_to_cart"
    fileprivate let isCustomType = true
    fileprivate let displayName = "bongo"
    fileprivate let itemIds = ["10003", "10004", "10005", "10006", "10007"]
    fileprivate let groupId = "All"
    fileprivate let resultID = "result-id"

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey, segments: ["123", "234"], defaultAnalyticsTags: ["appVersion": "123", "appPlatform": "ios"]))
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testTrackInputFocus() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackInputFocus(searchTerm: searchTerm, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackAutocompleteSelect() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackSearchSubmit() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchSubmit(searchTerm: searchTerm, originalQuery: originalQuery, group: group, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testTrackSearchResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testSearchResultsLoaded_withItems() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, customerIDs: customerIDs, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearchResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearchResultClick_WithVariationID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackSearchResultClick(itemName: "Item1", customerID: "10001", variationID: "20001", searchTerm: "item", sectionName: "Products", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
    }

    func testBrowseResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultsLoaded(filterName: groupFilterName, filterValue: groupFilterValue, resultCount: resultCount, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testBrowseResultsLoaded_withItems() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultsLoaded(filterName: groupFilterName, filterValue: groupFilterValue, resultCount: resultCount, customerIDs: customerIDs, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: groupFilterName, filterValue: groupFilterValue, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultClick_WithVariationID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackBrowseResultClick(customerID: "10001", variationID: "20001", filterName: "Brand", filterValue: "XYZ", resultPositionOnPage: 1, sectionName: "Products", resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
    }

    func testRecommendationsResultsView() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackRecommendationResultsView(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendationsResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackRecommendationResultClick(podID: podID, strategyID: strategyID, customerID: customerID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testConversion() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName, conversionType: conversionType, displayName: displayName, isCustomType: isCustomType, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testConversion_WithVariationID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackConversion(itemName: "Item 1", customerID: "10001", variationID: "20001", revenue: 10, searchTerm: "item", sectionName: "Products", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
    }

    func testPurchase() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackPurchase(customerIDs: customerIDs, sectionName: sectionName, revenue: revenue, orderID: orderID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testPurchase_WithVariationIDs() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Tracking 204")
        let items = [
            CIOItem(customerID: "10001", variationID: "20001"),
            CIOItem(customerID: "luistrenker-jacket-K245511299-cream", variationID: "M0E20000000E2ZJ")
        ]
        constructorClient.trackPurchase(items: items, sectionName: sectionName, revenue: revenue, orderID: orderID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testPurchase_WithQuantity() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Tracking 204")
        let items = [
            CIOItem(customerID: "10001", variationID: "20001", quantity: 2)
        ]
        constructorClient.trackPurchase(items: items, sectionName: sectionName, revenue: revenue, orderID: orderID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testItemDetailLoad() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackItemDetailLoad(customerID: "10001", itemName: "item1", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testItemDetailLoad_WithVariationID() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackItemDetailLoad(customerID: "10001", itemName: "item1", variationID: "20001", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testItemDetailLoad_WithSection() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        constructorClient.trackItemDetailLoad(customerID: "10001", itemName: "item1", sectionName: "Products", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIORecommendationsQuery(podID: podID, itemID: customerID, section: sectionName)
        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            XCTAssertEqual(responseData.pod.id, self.podID, "Pod ID should match the JSON response")
            XCTAssertTrue(responseData.totalNumResults >= 0, "Recommendations count exists")

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let filters = CIOQueryFilters(groupFilter: "Styles", facetFilters: nil)
        let hiddenFields = ["testField"]
        let query = CIORecommendationsQuery(podID: "filtered_items", filters: filters, section: sectionName, hiddenFields: hiddenFields)
        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let recommendationResult = responseData.results[0]
            let resultData = recommendationResult.data
            let hiddenTestFieldValue = resultData.metadata["testField"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenTestFieldValue)
            XCTAssertEqual(hiddenTestFieldValue, "hiddenFieldValue")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_WithInvalidPodId() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIORecommendationsQuery(podID: "bad_pod_id", itemID: customerID, section: sectionName)
        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "Recommendations pod not found with id: bad_pod_id")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_WithPreFilterExpression() {
        let expectation = XCTestExpectation(description: "Request 204")
        let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"

        let query = CIORecommendationsQuery(podID: podID, itemID: customerID, section: sectionName, preFilterExpression: preFilterExpression)
        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let request = responseData.request
            let requestPreFilterExpression = request["pre_filter_expression"]
            XCTAssertNil(cioError)
            XCTAssertNotNil(requestPreFilterExpression)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_WithVariationsMap() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIORecommendationsQuery(podID: podID, itemID: customerID, variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "array"))

        constructorClient.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let request = responseData.request
            let requestVariationsMap = request["variations_map"]

            XCTAssertNil(cioError)
            XCTAssertNotNil(requestVariationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendations_ShouldReturnResultsWithLabels() {
        let expectation = XCTestExpectation(description: "Request 204")
        let filters = CIOQueryFilters(groupFilter: "Styles", facetFilters: nil)
        let query = CIORecommendationsQuery(podID: "filtered_items", filters: filters, section: sectionName)
        self.constructor.recommendations(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let recommendationResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(recommendationResult)
            XCTAssertNotNil(recommendationResult.labels)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testRecommendations_withItems() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackRecommendationResultsView(podID: podID, numResultsViewed: numResultsViewed, customerIDs: customerIDs, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOAutocompleteQuery(query: "item", filters: nil, numResults: 20)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let results = responseData.sections["Products"]!
            XCTAssertFalse(results.isEmpty)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "XYZ")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: "item", filters: queryFilters, numResults: 20)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let results = responseData.sections["Products"]!
            XCTAssertFalse(results.isEmpty)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithSectionSpecificFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "XYZ")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "BrandXY", facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: "item", sectionFilters: ["Products" : queryFilters], numResults: 20)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let productResults = responseData.sections["Products"]!
            XCTAssertFalse(productResults.isEmpty)
            let suggestionResults = responseData.sections["Search Suggestions"]!
            XCTAssertFalse(productResults.isEmpty)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["testField"]
        let query = CIOAutocompleteQuery(query: "item1", numResults: 20, hiddenFields: hiddenFields)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let products = responseData.sections["Products"]!
            let autocompleteResult = products[0].result
            let resultData = autocompleteResult.data
            let testHiddenFieldValue = resultData.metadata["testField"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(testHiddenFieldValue)
            XCTAssertEqual(testHiddenFieldValue, "hiddenFieldValue")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithVariationsMapWithArrayDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOAutocompleteQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "array"))
        constructorClient.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.sections["Products"]?[0]
            let variationsMap = searchResult?.result.variationsMap as? [JSONObject]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithVariationsMapWithObjectDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOAutocompleteQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "object"))
        constructorClient.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.sections["Products"]?[0]
            let variationsMap = searchResult?.result.variationsMap as? JSONObject

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithInvalidKey() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOAutocompleteQuery(query: "a")
        let constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "bad_api_key"))
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "You have supplied an invalid `key` or `autocomplete_key`. You can find your key at app.constructor.io/dashboard/accounts/api_integration.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_ShoulReturnResultsWithLabels() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOAutocompleteQuery(query: "item")
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            if let responseData = response.data,
               let autocompleteResult = responseData.sections["Products"]?.first,
               let isSponsored = autocompleteResult.result.labels["is_sponsored"] as? Bool {
                
                XCTAssertNil(cioError)
                XCTAssertNotNil(autocompleteResult)
                XCTAssertEqual(isSponsored, true)
            } else {
                XCTFail("Expected valid response data, autocomplete result, and 'is_sponsored' label")
            }

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item", filters: nil)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let results = responseData.results
            XCTAssertFalse(results.isEmpty)

            let request = responseData.request
            XCTAssertNotNil(request)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnResultSources() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let embeddingsMatch = responseData.resultSources?.embeddingsMatch.count ?? 0
            let tokenMatch = responseData.resultSources?.tokenMatch.count ?? 0

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(embeddingsMatch + tokenMatch, responseData.totalNumResults)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnGroupsWithParentsAndChildren() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let groups = responseData.groups

            XCTAssertFalse(groups[0].children.isEmpty)
            XCTAssertFalse(groups[0].children[0].parents.isEmpty)
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "ABC")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "All", facetFilters: facetFilters)
        let query = CIOSearchQuery(query: "item", filters: queryFilters)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let results = responseData.results
            XCTAssertFalse(results.isEmpty)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithPreFilterExpression() {
        let expectation = XCTestExpectation(description: "Request 204")
        let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"

        let query = CIOSearchQuery(query: "item", preFilterExpression: preFilterExpression)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let request = responseData.request
            let requestPreFilterExpression = request["pre_filter_expression"]
            XCTAssertNil(cioError)
            XCTAssertNotNil(requestPreFilterExpression)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["testField"]
        let query = CIOSearchQuery(query: "item", hiddenFields: hiddenFields)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let resultData = searchResult.data
            let hiddenTestFieldValue = resultData.metadata["testField"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenTestFieldValue)
            XCTAssertEqual(hiddenTestFieldValue, "hiddenFieldValue")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFacets = ["Brand"]
        let query = CIOSearchQuery(query: "item1", hiddenFacets: hiddenFacets)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let hiddenFacetIndex = responseData.facets.firstIndex { $0.name == hiddenFacets[0] }

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.facets[hiddenFacetIndex!].name, hiddenFacets[0])
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithVariationsMapWithArrayDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOSearchQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "array"))
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let variationsMap = searchResult.variationsMap as? [JSONObject]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithVariationsMapWithObjectDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOSearchQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "object"))
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let variationsMap = searchResult.variationsMap as? JSONObject

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithInvalidParameterValue() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOSearchQuery(query: "item", filters: nil, perPage: 500)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "num_results_per_page: ensure this value is less than or equal to 200")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithGroupSortOptionValueAscending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOSearchQuery(query: "item", groupsSortOption: groupsSortOption)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Brands")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithGroupSortOptionValueDescending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .descending)
        let query = CIOSearchQuery(query: "item", groupsSortOption: groupsSortOption)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Styles")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnResultsWithLabels() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            
            if let responseData = response.data,
               let searchResult = responseData.results.first,
               let isSponsored = searchResult.labels["is_sponsored"] as? Bool {
                
                XCTAssertNil(cioError)
                XCTAssertNotNil(searchResult)
                XCTAssertEqual(isSponsored, true)
            } else {
                XCTFail("Expected valid response data, search result, and 'is_sponsored' label")
            }
            
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnRefinedContent() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let refinedContent = responseData.refinedContent[0]
            let refinedContentData = refinedContent.data
            let header = refinedContentData["header"] as? String
            let body = refinedContentData["body"] as? String
            let altText = refinedContentData["altText"] as? String
            let assetUrl = refinedContentData["assetUrl"] as? String
            let mobileAssetUrl = refinedContentData["mobileAssetUrl"] as? String
            let mobileAssetAltText = refinedContentData["mobileAssetAltText"] as? String
            let ctaLink = refinedContentData["ctaLink"] as? String
            let ctaText = refinedContentData["ctaText"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(refinedContent)
            XCTAssertEqual(header, "Content 1 Header")
            XCTAssertEqual(body, "Content 1 Body")
            XCTAssertEqual(altText, "Content 1 desktop alt text")
            XCTAssertEqual(assetUrl, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(mobileAssetUrl, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(mobileAssetAltText, "Content 1 mobile alt text")
            XCTAssertEqual(ctaLink, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(ctaText, "Content 1 CTA Button")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnRefinedContentWithArtbitraryData() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let refinedContent = responseData.refinedContent[0]
            let refinedContentData = refinedContent.data
            let tag1Value = refinedContentData["tag-1"] as? String
            let tag2Value = refinedContentData["tag-2"] as? String
            let arbitraryDataObject = refinedContentData["arbitraryDataObject"] as? [String: String] ?? [:]

            XCTAssertNil(cioError)
            XCTAssertNotNil(refinedContent)
            XCTAssertEqual(tag1Value, "tag-1-value")
            XCTAssertEqual(tag2Value, "tag-2-value")
            XCTAssertEqual(arbitraryDataObject["pizza"], "pie")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_ShouldReturnFacetsData() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "item")
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let facet = responseData.facets.first
            let facetData = facet?.data
            let facetHidden = facet?.hidden

            XCTAssertNil(cioError)
            XCTAssertNotNil(facetData)
            XCTAssertEqual(facetHidden, false)
            XCTAssertEqual(facetData?["cheese"] as? String, "pizza")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let responseData = response.data!
            let results = responseData.results
            XCTAssertFalse(results.isEmpty)

            let request = responseData.request
            XCTAssertNotNil(request)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ShouldReturnResultSources() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let embeddingsMatch = responseData.resultSources?.embeddingsMatch.count ?? 0
            let tokenMatch = responseData.resultSources?.tokenMatch.count ?? 0

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(embeddingsMatch + tokenMatch, responseData.totalNumResults)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseShouldReturnGroupsWithParentsAndChildren() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let groups = responseData.groups

            XCTAssertFalse(groups[0].parents.isEmpty)
            XCTAssertFalse(groups[0].children.isEmpty)
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseWithCollections() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: collectionFilterName, filterValue: collectionFilterValue)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let displayName = responseData.collection?.display_name
            let collectionId = responseData.collection?.id

            XCTAssertNil(cioError)
            XCTAssertEqual(displayName, "test", "Collection display name matches the provided collection display name")
            XCTAssertEqual(collectionId, "test", "Collection id matches the provided collection id")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "A&W")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: facetFilters)
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue, filters: queryFilters)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithPreFilterExpression() {
        let expectation = XCTestExpectation(description: "Request 204")
        let preFilterExpression = "{\"or\":[{\"and\":[{\"name\":\"group_id\",\"value\":\"electronics-group-id\"},{\"name\":\"Price\",\"range\":[\"-inf\",200.0]}]},{\"and\":[{\"name\":\"Type\",\"value\":\"Laptop\"},{\"not\":{\"name\":\"Price\",\"range\":[800.0,\"inf\"]}}]}]}"

        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue, preFilterExpression: preFilterExpression)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let request = responseData.request
            let requestPreFilterExpression = request["pre_filter_expression"]
            XCTAssertNil(cioError)
            XCTAssertNotNil(requestPreFilterExpression)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["testField"]
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue, hiddenFields: hiddenFields)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let resultData = browseResult.data
            let hiddenTestFieldValue = resultData.metadata["testField"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenTestFieldValue)
            XCTAssertEqual(hiddenTestFieldValue, "hiddenFieldValue")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFacets = ["Brand"]
        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ", hiddenFacets: hiddenFacets)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let hiddenFacetIndex = responseData.facets.firstIndex { $0.name == hiddenFacets[0] }

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.facets[hiddenFacetIndex!].name, hiddenFacets[0])
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithVariationsMapWithArrayDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "array"))
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let variationsMap = browseResult.variationsMap as? [JSONObject]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithVariationsMapWithObjectDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "object"))
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let variationsMap = browseResult.variationsMap as? JSONObject

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithUnknownSection() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: "431", section: "bad_section")
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "Unknown section: bad_section")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithEmptyFilterValue() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: "")
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "You are trying to access an invalid endpoint. Please check documentation for allowed endpoints.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithGroupSortOptionValueAscending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: "All", groupsSortOption: groupsSortOption)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Brands")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithGroupSortOptionValueDescending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .descending)
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: "All", groupsSortOption: groupsSortOption)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Styles")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ShouldReturnResultsWithLabels() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ")
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            if let responseData = response.data,
               let browseResult = responseData.results.first,
               let isSponsored = browseResult.labels["is_sponsored"] as? Bool {

                XCTAssertNil(cioError)
                XCTAssertNotNil(browseResult)
                XCTAssertEqual(isSponsored, true)
            } else {
                XCTFail("Expected valid response data, browse result, and 'is_sponsored' label")
            }

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ShouldReturnRefinedContent() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let refinedContent = responseData.refinedContent[0]
            let refinedContentData = refinedContent.data
            let header = refinedContentData["header"] as? String
            let body = refinedContentData["body"] as? String
            let altText = refinedContentData["altText"] as? String
            let assetUrl = refinedContentData["assetUrl"] as? String
            let mobileAssetUrl = refinedContentData["mobileAssetUrl"] as? String
            let mobileAssetAltText = refinedContentData["mobileAssetAltText"] as? String
            let ctaLink = refinedContentData["ctaLink"] as? String
            let ctaText = refinedContentData["ctaText"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(refinedContent)
            XCTAssertEqual(header, "Content 1 Header")
            XCTAssertEqual(body, "Content 1 Body")
            XCTAssertEqual(altText, "Content 1 desktop alt text")
            XCTAssertEqual(assetUrl, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(mobileAssetUrl, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(mobileAssetAltText, "Content 1 mobile alt text")
            XCTAssertEqual(ctaLink, "https://constructor.io/wp-content/uploads/2022/09/groceryshop-2022-r2.png")
            XCTAssertEqual(ctaText, "Content 1 CTA Button")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ShouldReturnRefinedContentWithArtbitraryData() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: groupFilterName, filterValue: groupFilterValue)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let refinedContent = responseData.refinedContent[2]
            let refinedContentData = refinedContent.data
            let tag1Value = refinedContentData["tag-1"] as? String
            let tag2Value = refinedContentData["tag-2"] as? String
            let arbitraryDataObject = refinedContentData["arbitraryDataObject"] as? [String: String] ?? [:]

            XCTAssertNil(cioError)
            XCTAssertNotNil(refinedContent)
            XCTAssertEqual(tag1Value, "tag-1-value")
            XCTAssertEqual(tag2Value, "tag-2-value")
            XCTAssertEqual(arbitraryDataObject["pizza"], "pie")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseItemsQuery(ids: itemIds)
        self.constructor.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            for result in response.data?.results ?? [] {
                XCTAssertTrue(self.itemIds.contains(result.data.id!))
            }
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItemsShouldReturnGroupsWithParentsAndChildren() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseItemsQuery(ids: itemIds)
        self.constructor.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let groups = responseData.groups

            for result in response.data?.results ?? [] {
                XCTAssertTrue(self.itemIds.contains(result.data.id!))
            }
            XCTAssertFalse(groups[0].children[0].parents.isEmpty)
            XCTAssertFalse(groups[0].children.isEmpty)
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_ShouldReturnFacetsData() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseItemsQuery(ids: itemIds)
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let facet = responseData.facets.first
            let facetData = facet?.data
            let facetHidden = facet?.hidden

            XCTAssertNil(cioError)
            XCTAssertNotNil(facetData)
            XCTAssertEqual(facetHidden, false)
            XCTAssertEqual(facetData?["cheese"] as? String, "pizza")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "A&W")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: facetFilters)
        let query = CIOBrowseItemsQuery(ids: itemIds, filters: queryFilters)
        self.constructor.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            for result in response.data?.results ?? [] {
                XCTAssertTrue(self.itemIds.contains(result.data.id!))
            }
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["testField"]
        let query = CIOBrowseItemsQuery(ids: itemIds, hiddenFields: hiddenFields)
        self.constructor.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let resultData = browseResult.data
            let hiddenTestFieldValue = resultData.metadata["testField"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenTestFieldValue)
            XCTAssertEqual(hiddenTestFieldValue, "hiddenFieldValue")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFacets = ["Brand"]
        let query = CIOBrowseItemsQuery(ids: ["10001", "10002", "10009"], hiddenFacets: hiddenFacets)
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let hiddenFacetIndex = responseData.facets.firstIndex { $0.name == hiddenFacets[0] }

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.facets[hiddenFacetIndex!].name, hiddenFacets[0])
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithVariationsMapWithArrayDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOBrowseItemsQuery(ids: ["10001", "10002", "10009"], variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "array"))
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let variationsMap = browseResult.variationsMap as? [JSONObject]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithVariationsMapWithObjectDtype() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")

        let query = CIOBrowseItemsQuery(ids: ["10001", "10002", "10009"], variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url": valueOption], Dtype: "object"))
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let variationsMap = browseResult.variationsMap as? JSONObject

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertNotNil(variationsMap)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithUnknownSection() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOBrowseItemsQuery(ids: ["10001"], section: "bad_section")
        self.constructor.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "Unknown section: bad_section")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithGroupSortOptionValueAscending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOBrowseItemsQuery(ids: itemIds, groupsSortOption: groupsSortOption)
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Brands")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseItems_WithGroupSortOptionValueDescending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .descending)
        let query = CIOBrowseItemsQuery(ids: itemIds, groupsSortOption: groupsSortOption)
        constructorClient.browseItems(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.groups[0].displayName, "All")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Styles")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseGroups() {
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOBrowseGroupsQuery()

        self.constructor.config.segments = nil
        self.constructor.browseGroups(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let groupIds = response.data?.groups.compactMap { $0.groupID }

            XCTAssertNil(cioError)
            XCTAssertNotNil(groupIds)
            XCTAssertTrue(groupIds?.contains(self.groupId) == true)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseGroups_WithSpecificGroupId() {
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOBrowseGroupsQuery(groupId: "Styles")

        self.constructor.config.segments = nil
        self.constructor.browseGroups(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let parentGroup = response.data?.groups[0]
            let grandparentsGroupIds = parentGroup?.parents.compactMap { $0.groupID }
            let childGroupIds = parentGroup?.children.compactMap { $0.groupID }

            XCTAssertTrue(grandparentsGroupIds?.contains(self.groupId) ?? false)
            XCTAssertTrue(childGroupIds?.contains("StyleA") ?? false)
            XCTAssertTrue(childGroupIds?.contains("StyleB") ?? false)

            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseGroups_WithMaxDepth() {
        let expectation = XCTestExpectation(description: "Request 200")
        let query = CIOBrowseGroupsQuery(groupsMaxDepth: 2)

        self.constructor.config.segments = nil
        self.constructor.browseGroups(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)

            let parentGroup = response.data?.groups[0]
            XCTAssertNotNil(parentGroup?.children)
            XCTAssertFalse(parentGroup?.children.isEmpty ?? true)

            let childGroup = parentGroup?.children[0]
            XCTAssertNotNil(childGroup?.children)
            XCTAssertFalse(childGroup?.children.isEmpty ?? true)

            let grandchildGroup = childGroup?.children[0]
            XCTAssertNotNil(grandchildGroup?.children)
            XCTAssertTrue(grandchildGroup?.children.isEmpty ?? false)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetsQuery()
        constructorClient.browseFacets(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!

            XCTAssertNil(cioError)
            XCTAssertNotNil(responseData.facets)
            XCTAssertTrue(!(responseData.facets.isEmpty))
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_WithShowHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetsQuery(showHiddenFacets: true)
        constructorClient.browseFacets(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNil(cioError)
            XCTAssertNotNil(response.data?.facets)
            XCTAssertTrue(!(response.data?.facets.isEmpty)!)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_WithPageAndPerPage() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetsQuery(page: 100, perPage: 10)
        constructorClient.browseFacets(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNil(cioError)
            XCTAssertNotNil(response.data?.facets)
            XCTAssertTrue(((response.data?.facets.isEmpty) != nil))
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacets_WithOffset() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetsQuery(offset: 100)
        constructorClient.browseFacets(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNil(cioError)
            XCTAssertNotNil(response.data?.facets)
            XCTAssertTrue(((response.data?.facets.isEmpty) != nil))
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacetOptions() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetOptionsQuery(facetName: "Color")
        constructorClient.browseFacetOptions(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNil(cioError)
            XCTAssertNotNil(response.data?.facets)
            XCTAssertNotNil(response.data?.facets[0].options)
            XCTAssertTrue(!(response.data?.facets.isEmpty)!)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseFacetOptions_WithShowHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseFacetOptionsQuery(facetName: "Brand", showHiddenFacets: true)
        constructorClient.browseFacetOptions(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError

            XCTAssertNil(cioError)
            XCTAssertNotNil(response.data?.facets)
            XCTAssertNotNil(response.data?.facets[0].options)
            XCTAssertTrue(!(response.data?.facets.isEmpty)!)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    // MARK: - New Sponsored Listings & Items Tests

    func testSearchResultsLoaded_withItemsParam() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        let items = [CIOItem(customerID: "10001"), CIOItem(customerID: "10002", variationID: "var2")]
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, items: items, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultsLoaded_withItemsParam() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        let items = [CIOItem(customerID: "10001"), CIOItem(customerID: "10002", variationID: "var2")]
        self.constructor.trackBrowseResultsLoaded(filterName: groupFilterName, filterValue: groupFilterValue, resultCount: resultCount, items: items, resultID: resultID, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearchResultsLoaded_withSponsoredListingsParams() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultsLoaded(searchTerm: searchTerm, resultCount: resultCount, slAdvertiser: "adv123", slCampaignID: "cmp456", slCampaignOwner: "owner789", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultsLoaded_withSponsoredListingsParams() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultsLoaded(filterName: groupFilterName, filterValue: groupFilterValue, resultCount: resultCount, resultID: resultID, slAdvertiser: "adv123", slCampaignID: "cmp456", slCampaignOwner: "owner789", completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
// swiftlint:enable type_body_length file_length
