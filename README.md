## Prerequisites

* An Xcode project targeting iOS 8.0 or above
* Objective-C or
* Swift project using swift 3.0 or later
* CocoaPods 1.0.0 or later
* A constructor.io account

## 1a. Import using CocoaPods
First make sure you have CocoaPods installed. If not, you can follow the installation guide from https://guides.cocoapods.org/using/getting-started.html.
Next step is to create an empty text file in your project’s root directory called ‘Podfile’. Add the following lines to the file:

```use_frameworks!
target ‘YOUR_TARGET_NAME’ do
pod ‘constructor.io'
end
```
Open the terminal and make sure you’re located in the project root(where your Podfile is located) and type
```pod install```

That’s it! Make sure to open the ```.xcworkspace``` file instead of the ```.xcodeproj``` you may have been using so far.

## 1b. Import using Carthage
Framework can be also installed via Carthage. First, make sure you have [Carthage installed](https://github.com/Carthage/Carthage#installing-carthage). Then, create an empty text file called ‘Cartfile’ in your project root directory. Now, add the following lines:

```github “constructor.io/releases”```

Run ```carthage update```

Drag the ConstructorIO.framework from Carthage/Checkouts/releases-ios into your project and link it with your application target.

TODO finish

## 1c. Manual import
* Go to our releases repository and get the latest distribution of ConstructorIO.framework. 
* Drag the framework into the project and link it with your application target.
That’s it! You are now ready to use constructor.io autocomplete framework.

## 2. Get the autocomplete key from constructor.io dashboard
TODO

## 3. Implement the autocomplete features in your app
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

## Customizing the UI
```CIOAutocompleteDataSource``` protocol contains various methods allowing you to customize the look and feel of the autocomplete view.

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

    func setup(title: String, searchTerm: String, highlighter: CIOHighlighter) {
        self.labelText.attributedText = highlighter.highlight(searchTerm: searchTerm, itemTitle: title)
        self.imageViewIcon.image = UIImage(named: "icon-autocomplete")
    }

}
```
Our framework will call this method on your cell and pass all the necessary data.

There are a couple of more views that you can fully replace with a custom UIView of your choice.
## Background View
Background view appears behind your search results. You can replace the default framework view by implementing the backgroundView method.
```
func backgroundView(in autocompleteController: CIOAutocompleteViewController) -> UIView?{
	return MyCustomBackgroundView()
}
```
## Error View
If an error occurs, error view will be shown displaying the error message. If you decide to use a custom error view, you should implement
```
func errorView(in autocompleteController: CIOAutocompleteViewController) -> UIView? {
        return UINib(nibName: "CustomErrorView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? UIView
    }
```    
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
