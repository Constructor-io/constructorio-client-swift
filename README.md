## Prerequisites

* An Xcode project targeting iOS 8.0 or above
* Objective-C or
* Swift project using swift 3.0 or later
* A constructor.io account

## 1a. Import using CocoaPods
First make sure you have CocoaPods installed. If not, you can follow the installation guide from https://guides.cocoapods.org/using/getting-started.html.
Next step is to create an empty text file in your project’s root directory called ‘Podfile’. Add the following lines to the file:

```use_frameworks!
target ‘YOUR_TARGET_NAME’ do
   pod ‘ConstructorAutocomplete'
end
```
Open the terminal and make sure you’re located in the project root(where your Podfile is located) and type
```pod install```

That’s it! Make sure to open the ```.xcworkspace``` file instead of the ```.xcodeproj``` you may have been using so far.

## 1b. Import using Carthage
Framework can be also installed via Carthage. First, make sure you have [Carthage installed](https://github.com/Carthage/Carthage#installing-carthage). Then, create an empty text file called ‘Cartfile’ in your project root directory. Now, add the following lines:

```github "Constructor-io/constructorio-client-swift"```

Run ```carthage update```

Drag the ```ConstructorIO.framework``` from Carthage/Build/iOS into your project and link it with your application target. Also, make sure to copy the framework by adding a new Copy Files phase.

<img src="https://constructor.io/images/ios_screenshots/ss_copy_frameworks.png" width="60%">

## 1c. Manual import
* Get the lastest source code from ```https://github.com/Constructor-io/constructorio-client-swift.git```
* Open and build the project in Xcode
* Drag the ```ConstructorAutocomplete.framework``` file into your project and link it with your application target.
* Make sure to copy the framework by adding a new Copy Files phase(image above).

That’s it! You are now ready to use constructor.io autocomplete framework.

## 2. Get the autocomplete key from constructor.io dashboard
[Register an account](https://constructor.io/users/sign_up) and acquire the autocomplete key.

## 3. Implement the autocomplete features in your app
Make sure to import the ConstructorAutocomplete module at the top of your source file

Swift ```import ConstructorAutocomplete```

Objective-C ```@import ConstructorAutocomplete;```

```
// Instantiate the autocomplete controller
let viewController = CIOAutocompleteViewController(autocompleteKey: “YOUR AUTOCOMPLETE KEY")

// set the delegate in order to react to various events
viewController.delegate = self

// set the data source to customize the look and feel of the UI
viewController.dataSource = self

// push the view controller to the stack
self.navigationController.pushViewController(viewController, animated: true)
```

You should now see your autocomplete view controller.

## Reacting to user events
```CIOAutocompleteDelegate``` contains methods that notify you about autocomplete events. We’ll touch on a couple of them:

```optional func autocompleteControllerDidLoad(controller: CIOAutocompleteViewController)```

* This method is called when the view controller’s view is loaded, giving you a chance to call analytics services or execute any background task.

```optional func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult)```

* Called when user taps a result in the table view. The view controller will not dismiss automatically. It’s entirely up to you whether you’d like to push another controller to the stack or dismiss the existing one and do something with the result.

```optional func autocompleteController(controller: CIOAutocompleteViewController, didPerformSearch searchTerm: String)```

* This method is called when the search query is sent to the server, again giving you a chance to do any necessary background work.

## Search in group
Any data value can belong to multiple groups. We will show the search-in-group options right below the item itself.

Let's remember the selection delegate method.

```optional func autocompleteController(controller: CIOAutocompleteViewController, didSelectResult result: CIOResult)```

The result is of type ```CIOResult``` which looks like this:
```
@objc
public class CIOResult: NSObject{
    public let autocompleteResult: CIOAutocompleteResult
    public let group: CIOGroup?
    
    init(autocompleteResult: CIOAutocompleteResult, group: CIOGroup? = nil){
        self.autocompleteResult = autocompleteResult
        self.group = group
    }
}
```
It represents an autocomplete item in a group. Let's say you search for 'apple' and the results coming back from server are:
```
"suggestions": [
      {
        "data": {
          "groups": [
            {
              "display_name": "food", 
              "group_id": "12", 
              "path": "/0/222/344"
            }, 
            {
              "display_name": "gadgets", 
              "group_id": "34", 
              "path": "/0/252/346/350"
            }
          ]
        }, 
        "value": "apple"
      }
]
```
We received two groups: food and gadgets. This means we'll have three items in total:
1. apple on it's own
2. Search for 'apple' in group 'food'
3. Search for 'apple' in group 'gadgets'

When the user taps on (1), you'll receive a CIOResult with a group property of nil.

When the user taps on (2), you'll receive a CIOResult with the food group property.

When the user taps on (3), you'll receive a CIOResult with the gadgets group property.

In other words, you can simply check whether the group property is nil to find out if the user tapped on a search-in-group result.

```
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

## Filtering results
If you want certain results or groups to be filtered out, you can do so by implementing ```shouldParseResult``` delegate method.

```
func autocompleteController(controller: CIOAutocompleteViewController, shouldParseResult result: CIOAutocompleteResult, inGroup group: CIOGroup?) -> Bool {
   // lets ignore all results that contain the word "guitar"
   if result.value.contains("guitar") {
      return false
   }

   // also, lets disallow all searches in group "food"
   if let group = group, group.displayName.lowercased() == "food" {
      return false
   }
   
   return true
}
```
## Customizing the UI
```CIOAutocompleteDataSource``` protocol contains various methods allowing you to customize the look and feel of the autocomplete view.

## Customize Search behaviour
You can customize how UISearchController behaves in the autocomplete controller by implementing the following method.
```
func customizeSearchController(searchController: UISearchController, in autocompleteController: CIOAutocompleteViewController) {
    // customize search bar
    searchController.searchBar.autocapitalizationType = UITextAutocapitalizationType.none
    searchController.searchBar.returnKeyType = .search
        
    // customize search controller behaviour
    searchController.dimsBackgroundDuringPresentation = false
    searchController.hidesNavigationBarDuringPresentation = true
}
```

## Using the default UI
We provide the default UITableViewCells in which the results will be shown. You can customize these cells by implementing the following methods:
```
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

## Using the custom UI
If you decide to use a fully custom cell, you can either pass the UINib using
```
func customCellNib(in autocompleteController: CIOAutocompleteViewController) -> UINib{
    return UINib(nibName: "CustomTableViewCell", bundle: nil)
}
```

or the custom cell class, if your cell is instantiated in code
```
func customCellClass(in autocompleteController: CIOAutocompleteViewController) -> AnyClass{
    return MyCustomCell.self
}
```

Your custom cells must conform to the ```CIOAutocompleteCell``` protocol and implement the ```setup``` method.
```
class CustomTableViewCell: UITableViewCell, CIOAutocompleteCell {

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
Our framework will call this method on your cell and pass all the necessary data.

<img src="https://constructor.io/images/ios_screenshots/ss_custom_cell.png" width="60%">

There are a couple of more views that you can fully replace with a custom UIView of your choice.
## Background View
The background view appears behind your search results. You can replace the default framework view by implementing the backgroundView method.
```
func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView?{
    return MyCustomBackgroundView()
}
```

<img src="https://constructor.io/images/ios_screenshots/ss_custom_background_view.png" width="60%" />

## Error View
The error view appears if an error occurs.  No default error view exists but you can add one by implementing the errorView method.
```
func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
    return UINib(nibName: "CustomErrorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
}
```

<img src="https://constructor.io/images/ios_screenshots/ss_custom_error_view.png" width="60%" />
Your custom error view must conform to the CIOErrorView protocol and implement the necessary methods
```
class CustomErrorView: UIView, CIOErrorView {

    @IBOutlet weak var labelError: UILabel!

    func asView() -> UIView {
        return self
    }

    func setErrorString(errorString: String) {
        self.labelError.text = errorString
    }
}
```

## Bug reporting

Found a bug or having problems implementing any of the features? Feel free to [submit a new issue](https://github.com/Constructor-io/constructorio-client-swift/issues/new).
