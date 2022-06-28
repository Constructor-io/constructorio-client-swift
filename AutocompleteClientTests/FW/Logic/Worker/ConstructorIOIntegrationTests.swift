//
//  ConstructorIOIntegrationTests.swift
//  AutocompleteClientTests
//
//  Copyright © Constructor.io. All rights reserved.
//  http://constructor.io/
//

import XCTest
import ConstructorAutocomplete

// swiftlint:disable type_body_length
class ConstructorIOIntegrationTests: XCTestCase {

    fileprivate let testACKey = "key_K2hlXt5aVSwoI1Uw"
    fileprivate let unitTestKey = "ZqXaOfXuBWD4s3XzCI1q"
    fileprivate let searchTerm = "pork"
    fileprivate let session = 90
    fileprivate let filterName = "group_id"
    fileprivate let filterValue = "544"
    fileprivate let resultCount = 123
    fileprivate let resultPositionOnPage = 3
    fileprivate let revenue = 7.99
    fileprivate let orderID = "234641"
    fileprivate let sectionName = "Products"
    fileprivate let itemName = "Boneless Pork Shoulder Roast"
    fileprivate let customerID = "prrst_shldr_bls"
    fileprivate let customerIDs = ["prrst_shldr_bls", "prrst_crwn"]
    fileprivate let originalQuery = "pork#@#??!!asd"
    fileprivate let group = CIOGroup(displayName: "groupName1", groupID: "groupID2", path: "path/to/group")
    fileprivate let podID = "item_page_1"
    fileprivate let strategyID = "alternative_items"
    fileprivate let numResultsPerPage = 5
    fileprivate let numResultsViewed = 5
    fileprivate let resultPage = 1
    fileprivate let conversionType = "add_to_cart"

    var constructor: ConstructorIO!

    override func setUp() {
        super.setUp()
        self.constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
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
        self.constructor.trackAutocompleteSelect(searchTerm: searchTerm, originalQuery: originalQuery, sectionName: sectionName, group: group, resultID: nil, completionHandler: { response in
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

    func testSearchResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackSearchResultClick(itemName: itemName, customerID: customerID, searchTerm: searchTerm, sectionName: sectionName, resultID: nil, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultsLoaded() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultsLoaded(filterName: filterName, filterValue: filterValue, resultCount: resultCount, resultID: nil, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackBrowseResultClick(customerID: customerID, filterName: filterName, filterValue: filterValue, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: nil, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendationsResultsView() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackRecommendationResultsView(podID: podID, numResultsViewed: numResultsViewed, resultPage: resultPage, resultCount: resultCount, sectionName: sectionName, resultID: nil, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testRecommendationsResultClick() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackRecommendationResultClick(podID: podID, strategyID: strategyID, customerID: customerID, numResultsPerPage: numResultsPerPage, resultPage: resultPage, resultCount: resultCount, resultPositionOnPage: resultPositionOnPage, sectionName: sectionName, resultID: nil, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testConversion() {
        let expectation = XCTestExpectation(description: "Tracking 204")
        self.constructor.trackConversion(itemName: itemName, customerID: customerID, revenue: revenue, searchTerm: searchTerm, sectionName: sectionName, conversionType: conversionType, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
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

    func testAutocomplete() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOAutocompleteQuery(query: "a", filters: nil, numResults: 20)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "A&W")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: "a", filters: queryFilters, numResults: 20)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["price_US", "price_CA"]
        let query = CIOAutocompleteQuery(query: "a", numResults: 20, hiddenFields: hiddenFields)
        self.constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let products = responseData.sections["Products"]!
            let autocompleteResult = products[0].result
            let resultData = autocompleteResult.data
            let price = resultData.metadata["price"] as? String
            let hiddenPriceUSValue = resultData.metadata["price_US"] as? String
            let hiddenPriceCAValue = resultData.metadata["price_CA"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenPriceCAValue)
            XCTAssertEqual(price, hiddenPriceUSValue, "Hidden price value matches the visible price value")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testAutocomplete_WithVariationsMap() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")
        
        let query = CIOAutocompleteQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url" : valueOption], Dtype: "array"))
        constructorClient.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.sections["Products"]?[0];
            let variationsMap = searchResult?.result.variationsMap as? [JSONObject] ?? nil;

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap);
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testAutocomplete_WithInvalidKey() {
        let expectation = XCTestExpectation(description: "Request 400")
        let facetFilters = [
            (key: "Brand", value: "A&W")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: nil, facetFilters: facetFilters)
        let query = CIOAutocompleteQuery(query: "a", filters: queryFilters, numResults: 20)
        let constructor = ConstructorIO(config: ConstructorIOConfig(apiKey: "bad_api_key"))
        constructor.autocomplete(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "We have no record of this key. You can find your key at app.constructor.io/dashboard.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOSearchQuery(query: "a", filters: nil)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithFilters() {
        let expectation = XCTestExpectation(description: "Request 204")
        let facetFilters = [
            (key: "Brand", value: "A&W")
        ]
        let queryFilters = CIOQueryFilters(groupFilter: "101", facetFilters: facetFilters)
        let query = CIOSearchQuery(query: "a", filters: queryFilters)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["price_US", "price_CA"]
        let query = CIOSearchQuery(query: "a", hiddenFields: hiddenFields)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let resultData = searchResult.data
            let price = resultData.metadata["price"] as? String
            let hiddenPriceUSValue = resultData.metadata["price_US"] as? String
            let hiddenPriceCAValue = resultData.metadata["price_CA"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenPriceCAValue)
            XCTAssertEqual(price, hiddenPriceUSValue, "Hidden price value matches the visible price value")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFacets = ["Brand", "hiddenFacet"]
        let query = CIOSearchQuery(query: "item1", hiddenFacets: hiddenFacets)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let hiddenFacetIndex = responseData.facets.firstIndex{$0.name == hiddenFacets[0]}

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.facets[hiddenFacetIndex!].name, hiddenFacets[0])
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testSearch_WithVariationsMap() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")
        
        let query = CIOSearchQuery(query: "item1", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url" : valueOption], Dtype: "array"))
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let variationsMap = searchResult.variationsMap as? [JSONObject] ?? nil;

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap);
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithInvalidParameterValue() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOSearchQuery(query: "a", filters: nil, perPage: 500)
        self.constructor.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "num_results_per_page must be at most 100")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithGroupSortOptionValueAscending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOSearchQuery(query: "pork", groupsSortOption: groupsSortOption)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "Dairy")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testSearch_WithGroupSortOptionValueDescending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .descending)
        let query = CIOSearchQuery(query: "pork", groupsSortOption: groupsSortOption)
        constructorClient.search(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "Meat & Poultry")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431")
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowseWithCollections() {
        let expectation = XCTestExpectation(description: "Request 204")
        let query = CIOBrowseQuery(filterName: "collection_id", filterValue: "fresh-fruits")
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let displayName = responseData.collection?.display_name
            let collectionId = responseData.collection?.id

            XCTAssertNil(cioError)
            XCTAssertEqual(displayName, "fresh fruits", "Collection display name matches the provided collection display name")
            XCTAssertEqual(collectionId, "fresh-fruits", "Collection id matches the provided collection id")
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
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431", filters: queryFilters)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNil(cioError)
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithHiddenFields() {
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFields = ["price_US", "price_CA"]
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431", hiddenFields: hiddenFields)
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let resultData = browseResult.data
            let price = resultData.metadata["price"] as? String
            let hiddenPriceUSValue = resultData.metadata["price_US"] as? String
            let hiddenPriceCAValue = resultData.metadata["price_CA"] as? String

            XCTAssertNil(cioError)
            XCTAssertNotNil(hiddenPriceCAValue)
            XCTAssertEqual(price, hiddenPriceUSValue, "Hidden price value matches the visible price value")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithHiddenFacets() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let hiddenFacets = ["Brand", "hiddenFacet2"]
        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ", hiddenFacets: hiddenFacets)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let browseResult = responseData.results[0]
            let hiddenFacetIndex = responseData.facets.firstIndex{$0.name == hiddenFacets[0]}

            XCTAssertNil(cioError)
            XCTAssertNotNil(browseResult)
            XCTAssertEqual(responseData.facets[hiddenFacetIndex!].name, hiddenFacets[0])
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
    
    func testBrowse_WithVariationsMap() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: unitTestKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupByOptions = [GroupByOption(name: "variation_id", field: "data.variation_id")]
        let valueOption = ValueOption(aggregation: "all", field: "data.url")
        
        let query = CIOBrowseQuery(filterName: "Brand", filterValue: "XYZ", variationsMap: CIOQueryVariationsMap(GroupBy: groupByOptions, Values: ["url" : valueOption], Dtype: "array"))
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]
            let variationsMap = searchResult.variationsMap as? [JSONObject] ?? nil;

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertNotNil(variationsMap);
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithUnknownSection() {
        let expectation = XCTestExpectation(description: "Request 400")
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431", section: "bad_section")
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
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "")
        self.constructor.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            XCTAssertNotNil(cioError)
            XCTAssertEqual(cioError?.errorMessage, "You\'re trying to access an invalid endpoint. Please check documentation for allowed endpoints.")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithGroupSortOptionValueAscending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .ascending)
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431", groupsSortOption: groupsSortOption)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "Grocery")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Baby")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }

    func testBrowse_WithGroupSortOptionValueDescending() {
        let constructorClient = ConstructorIO(config: ConstructorIOConfig(apiKey: testACKey))
        let expectation = XCTestExpectation(description: "Request 204")
        let groupsSortOption = CIOGroupsSortOption(sortBy: .value, sortOrder: .descending)
        let query = CIOBrowseQuery(filterName: "group_id", filterValue: "431", groupsSortOption: groupsSortOption)
        constructorClient.browse(forQuery: query, completionHandler: { response in
            let cioError = response.error as? CIOError
            let responseData = response.data!
            let searchResult = responseData.results[0]

            XCTAssertNil(cioError)
            XCTAssertNotNil(searchResult)
            XCTAssertEqual(responseData.groups[0].displayName, "Grocery")
            XCTAssertEqual(responseData.groups[0].children[0].displayName, "Pet")
            expectation.fulfill()
        })
        self.wait(for: expectation)
    }
}
