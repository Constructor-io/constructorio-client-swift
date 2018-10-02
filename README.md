<img src="https://img.shields.io/badge/platform-iOS-blue.svg?style=flat" alt="Platform iOS" /> <img src="https://img.shields.io/badge/Swift-3.0+-blue.svg" alt="Swift 3+ compatible" /> <img src="https://img.shields.io/badge/Objective--C-compatible-blue.svg" alt="Objective-C compatible" /> <img  src="http://img.shields.io/badge/license-MIT-blue.svg?style=flat" alt="License: MIT" />

# Constructor.io Swift Library

An iOS Client library for [Constructor.io](http://constructor.io/).  [Constructor.io](http://constructor.io/) provides search as a service that optimizes results using artificial intelligence (including natural language processing, re-ranking to optimize for conversions, and user personalization).

## 1. Import

### via CocoaPods
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

### via Carthage
First, make sure you have [Carthage installed](https://github.com/Carthage/Carthage#installing-carthage). Then create an empty text file called ‘Cartfile’ in your project root directory. Now, add the following lines:

```
github "Constructor-io/constructorio-client-swift"
```

Open the terminal (make sure you’re located in the project root) and type

```bash
carthage update
```

Drag the ```ConstructorIO.framework``` from Carthage/Build/iOS into your project and link it with your application target. Also, make sure to copy the framework by adding a new Copy Files phase.

<img src="https://constructor.io/images/ios_screenshots/ss_copy_frameworks.png" width="60%">

## 2. Retrieve an autocomplete key
You can find this in your [Constructor.io dashboard](https://constructor.io/dashboard).  Contact sales if you'd like to sign up, or support if you believe your company already has an account.

## 3. Implement the Autocomplete UI
Make sure to import the `ConstructorAutocomplete` module at the top of your source file and then write the following

```swift
// Create the config
let config = ConstructorIOConfig(
   apiKey: "YOUR API KEY",
   resultCount: AutocompleteResultCount(numResultsForSection: ["Search Suggestions" : 3, "Products" : 0])
)

// Instantiate the autocomplete controller
let viewController = CIOAutocompleteViewController(config: config)

// set the delegate to react to user events... must conform to `CIOAutocompleteDelegate`
viewController.delegate = self

// set the delegate to customize the ui ... must conform to `CIOAutocompleteUICustomization`
viewController.uiCustomization = self

// push the view controller to the stack
self.navigationController.pushViewController(viewController, animated: true)
```

You should now see your autocomplete view controller.  `CIOAutocompleteDelegate` contains methods that notify you about autocomplete events and control autocomplete results. We’ll touch on a couple of them.

### Selecting Results
To respond to a user selecting an autocomplete result, implement the `didSelectResult` method.  The view controller will not dismiss automatically. It’s entirely up to you whether you’d like to push another controller to the stack or dismiss the existing one and do something with the result.  

If the autocomplete result has both a suggested term to search for and a group to search within (as in `Apples in Juice Drinks`), the group will be a property of the result.

``` swift
func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult){
   if let group = result.group{
      // user tapped on search-in-group result
      print("User tapped on \(result.autocompleteResult.value) in group \(group.displayName)")
   }else{
      // user tapped on an autocomplete result
      print("User tapped on \(result.autocompleteResult.value)")
   }
}
```

### Performing Searches
To respond to a user performing a search (instead of selecting an autocomplete result), implement the `didPerformSearch` method. The view controller will not dismiss automatically. It’s entirely up to you whether you’d like to push another controller to the stack or dismiss the existing one and do something with the result. 

``` swift
func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String){
   print("User searched for \(searchTerm)")
}
```
 
### Filtering Results
To filter out certain results or groups, implement the `shouldParseResult` method.

```swift
func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResult result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool {
   // ignore all results that contain the word "guitar"
   if result.value.contains("guitar") {
      return false
   }
   
   return true
}
```

## 4. Customize the Autocomplete UI
The `CIOAutocompleteUICustomization` protocol contains methods to customize the look and feel of the autocomplete interface.

### Customizing the Search Bar
You can customize how UISearchController behaves in the autocomplete controller by implementing the `customizeSearchController` method.

```swift
func customizeSearchController(searchController: UISearchController, in autocompleteController: CIOAutocompleteViewController) {
    // customize search bar
    searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
    searchController.searchBar.returnKeyType = .search
        
    // customize search controller behaviour
    searchController.dimsBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = true
}
```

### Customizing Results With Methods
The framework provides default `UITableViewCells` in which the results will be shown. You can customize these cells by implementing the following methods:

```swift
func styleResultLabel(label: UILabel, in autocompleteController: CIOAutocompleteViewController){
    label.backgrounColor = UIColor.clear
}

func styleResultCell(cell: UITableViewCell, indexPath: IndexPath, in autocompleteController: CIOAutocompleteViewController){
    cell.contentView.backgroundColor = UIColor.lightGray
}

func fontNormal(in autocompleteController: CIOAutocompleteViewController) -> UIFont{
    return UIFont.systemFont(ofSize: 15)
}

func fontBold(in autocompleteController: CIOAutocompleteViewController) -> UIFont{
    return UIFont.boldSystemFont(ofSize: 15)
}
```

### Customizing Results With Cells
If you decide to use a fully custom cell, you can either pass the UINib using

```swift
func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib{
    return UINib(nibName: "CustomTableViewCell", bundle: nil)
}
```

... or the custom cell class, if your cell is instantiated in code

```swift
func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass{
    return MyCustomCell.self
}
```

Your custom cells must conform to the `CIOAutocompleteCell` protocol.

```swift
class MyCustomCell: UITableViewCell, CIOAutocompleteCell {
    @IBOutlet weak var imageViewIcon: UIImageView!
    @IBOutlet weak var labelText: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(result: CIOResult, searchTerm: String, highlighter: CIOHighlighter) {
        self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: result.value)
        self.imageViewIcon.image = UIImage(named: "icon-autocomplete")
    }
}
```

The framework will call this method on your cell and pass the necessary data.

<img src="https://constructor.io/images/ios_screenshots/ss_custom_cell.png" width="60%">

### Customizing the Background View
The background view appears behind your autocomplete results. You can replace the default  view by implementing the `backgroundView` method.

```swift
func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView?{
    return MyCustomBackgroundView()
}
```

### Customizing the Error View
The error view appears if an error occurs when requesting autocomplete results.  No default error view exists but you can add one by implementing the `errorView` method. Your custom error view must conform to the `CIOErrorView` protocol.

```swift
func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView?{
    return MyCustomErrorView()
}
```
