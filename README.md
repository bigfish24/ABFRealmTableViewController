# ABFRealmTableViewController
The `ABFRealmTableViewController` class is a subclass of `UITableViewController` but adds data binding to a Realm object class. The underlying `UITableView` will animate changes via use of [`RBQFetchedResultsController`](https://github.com/Roobiq/RBQFetchedResultsController).

_**A Swift version was added with an identical API in v1.1.**_

To use, simply subclass `ABFRealmTableViewController` in the same way as `UITableViewController` and set the `entityName` property to the Realm object class name. Similar to an `UITableView` implementation, you will need to implement the necessary `UITableViewControllerDelegate` and `UITableViewControllerDataSource` protocols.

The data binding occurs through the use of [RBQFetchedResultsController](https://github.com/Roobiq/RBQFetchedResultsController), which requires that you log the changes you perform since Realm doesn't yet support fine-grained notifications. Luckily this is quite easy, through the provided helper methods with [RBQFetchedResultsController](https://github.com/Roobiq/RBQFetchedResultsController):

```objc
// Provided for RLMRealm/Realm for Objc/Swift versions
addObjectWithNotification:
addObjectsWithNotification:
addOrUpdateObjectWithNotification:
addOrUpdateObjectsFromArrayWithNotification:
deleteObjectWithNotification:
deleteObjectsWithNotification:

// Provided for RLMObject/Object for Objc/Swift versions
changeWithNotification:
changeWithNotificationInTransaction:
```

####Screenshot
The example application is a basic todo list with an object model: `TaskObject` that the `UITableView` is bound to. When a new `TaskObject` is created, the row animates in, and likewise when the `TaskObject` is deleted the row animates out.

![Todo List Backed By ABFRealmTableViewController](/images/ABFRealmTableViewController.gif?raw=true "Todo List Backed By ABFRealmTableViewController")

####Installation
`ABFRealmTableViewController` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

**Objective-C**
```
pod 'ABFRealmTableViewController'
```
**Swift**
```
pod 'RealmTableViewController'
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

**Swift**
```
git clone https://github.com/bigfish24/ABFRealmMapView.git
cd ABFRealmTableViewController/SwiftExample
pod install
open RealmTableViewController.xcworkspace
```
#####Requirements
* iOS 8+
* Xcode 7
