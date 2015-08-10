# ABFRealmTableViewController
The `ABFRealmTableViewController` class is a subclass of `UITableViewController` but adds data-binding to an `RLMObject` subclass. The underlying `UITableView` will animate changes via use of [`RBQFetchedResultsController`](https://github.com/Roobiq/RBQFetchedResultsController).

To use, simply subclass `ABFRealmTableViewController` in the same way as `UITableViewController` and set the `entityName` property to the `RLMObject` class name. Similar to an `UITableView` implementation, you will need to implement the necessary `UITableViewControllerDelegate` and `UITableViewControllerDataSource` protocols.

####Screenshot
The example application is a basic todo list with an object model: `TaskObject` that the `UITableView` is bound to. When a new `TaskObject` is created, the row animates in, and likewise when the `TaskObject` is deleted the row animates out.

![Todo List Backed By ABFRealmTableViewController](/images/ABFRealmTableViewController.gif?raw=true "Todo List Backed By ABFRealmTableViewController")

####Installation
`ABFRealmTableViewController` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:
```
pod 'ABFRealmTableViewController'
```

####Demo

Build and run/test the Example project in Xcode to see `ABFRealmTableViewController` in action. This project uses CocoaPods. If you don't have [CocoaPods](http://cocoapods.org/) installed, grab it with [sudo] gem install cocoapods.

```
git clone https://github.com/bigfish24/ABFRealmTableViewController.git
cd ABFRealmTableViewController/ABFRealmTableViewControllerExample
pod install
open ABFRealmTableViewController.xcworkspace
```
#####Requirements

* iOS 8+
* Xcode 6+
