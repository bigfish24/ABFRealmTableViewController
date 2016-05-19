//
//  RealmTableViewController.swift
//  RealmTableViewControllerExample
//
//  Created by Adam Fish on 10/5/15.
//  Copyright © 2015 Adam Fish. All rights reserved.
//

import UIKit
import RealmSwift
import RBQFetchedResultsController

public class RealmTableViewController: UITableViewController {
    
    // MARK: Properties
    
    /// The name of the Realm Object managed by the grid controller
    @IBInspectable public var entityName: String? {
        didSet {
            self.updateFetchedResultsController()
        }
    }
    
    /// The section name key path used to create the sections. Can be nil if no sections.
    @IBInspectable public var sectionNameKeyPath: String? {
        didSet {
            self.updateFetchedResultsController()
        }
    }
    
    /// The base predicet to to filter the Realm Objects on
    public var basePredicate: NSPredicate? {
        didSet {
            self.updateFetchedResultsController()
        }
    }
    
    /// Array of SortDescriptors
    ///
    /// http://realm.io/docs/cocoa/0.89.2/#ordering-results
    public var sortDescriptors: [SortDescriptor]? {
        didSet {
            
            if let descriptors = self.sortDescriptors {
                
                var rlmSortDescriptors = [RLMSortDescriptor]()
                
                for sortDesc in descriptors {
                    
                    let rlmSortDesc = RLMSortDescriptor(property: sortDesc.property, ascending: sortDesc.ascending)
                    
                    rlmSortDescriptors.append(rlmSortDesc)
                }
                
                self.rlmSortDescriptors = rlmSortDescriptors
            }
            
            self.updateFetchedResultsController()
        }
    }
    
    /// The configuration for the Realm in which the entity resides
    ///
    /// Default is [RLMRealmConfiguration defaultConfiguration]
    public var realmConfiguration: Realm.Configuration? {
        set {
            self.internalConfiguration = newValue
            
            self.updateFetchedResultsController()
        }
        get {
            if let configuration = self.internalConfiguration {
                return configuration
            }
            
            return Realm.Configuration.defaultConfiguration
        }
    }
    
    /// The Realm in which the given entity resides in
    public var realm: Realm? {
        if let configuration = self.realmConfiguration {
            return try! Realm(configuration: configuration)
        }
        
        return nil
    }
    
    
    // MARK: Object Retrieval
    
    /**
    Retrieve the RLMObject for a given index path
    
    :warning: Returned object is not thread-safe.
    
    :param: indexPath the index path of the object
    
    :returns: RLMObject
    */
    public func objectAtIndexPath<T: Object>(type: T.Type, indexPath: NSIndexPath) -> T? {
        if let anObject: AnyObject = self.fetchedResultsController.objectAtIndexPath(indexPath) {
            return unsafeBitCast(anObject, T.self)
        }
        
        return nil
    }
    
    // MARK: Initializers
    // MARK: Initialization
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.baseInit()
    }
    
    override public init(style: UITableViewStyle) {
        super.init(style: style)
        
        self.baseInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.baseInit()
    }
    
    private func baseInit() {
        self.fetchedResultsController = RBQFetchedResultsController()
        self.fetchedResultsController.delegate = self
    }
    
    // MARK: Private Functions
    private var viewLoaded: Bool = false
    
    private var internalConfiguration: Realm.Configuration?
    
    private var fetchedResultsController: RBQFetchedResultsController!
    
    private var rlmSortDescriptors: [RLMSortDescriptor]?
    
    private var rlmRealm: RLMRealm? {
        if let realmConfiguration = self.realmConfiguration {
            let configuration = self.toRLMConfiguration(realmConfiguration)
            
            return try! RLMRealm(configuration: configuration)
        }
        
        return nil
    }
    
    private func updateFetchedResultsController() {
        objc_sync_enter(self)
        if let fetchRequest = self.tableFetchRequest(self.entityName, inRealm: self.rlmRealm, predicate:self.basePredicate) {
            
            self.fetchedResultsController.updateFetchRequest(fetchRequest, sectionNameKeyPath: self.sectionNameKeyPath, andPerformFetch: true)
            
            if self.viewLoaded {
                self.runOnMainThread({ [weak self] () -> Void in
                    self?.tableView.reloadData()
                })
            }
        }
        objc_sync_exit(self)
    }
    
    private func tableFetchRequest(entityName: String?, inRealm realm: RLMRealm?, predicate: NSPredicate?) -> RBQFetchRequest? {
        
        if entityName != nil && realm != nil {
            
            let fetchRequest = RBQFetchRequest(entityName: entityName!, inRealm: realm!, predicate: predicate)
            
            fetchRequest.sortDescriptors = self.rlmSortDescriptors
            
            return fetchRequest
        }
        
        return nil
    }
    
    private func toRLMConfiguration(configuration: Realm.Configuration) -> RLMRealmConfiguration {
        let rlmConfiguration = RLMRealmConfiguration()
        
        if (configuration.fileURL != nil) {
            rlmConfiguration.fileURL = configuration.fileURL
        }
        
        if (configuration.inMemoryIdentifier != nil) {
            rlmConfiguration.inMemoryIdentifier = configuration.inMemoryIdentifier
        }
        
        rlmConfiguration.encryptionKey = configuration.encryptionKey
        rlmConfiguration.readOnly = configuration.readOnly
        rlmConfiguration.schemaVersion = configuration.schemaVersion
        return rlmConfiguration
    }

    private func runOnMainThread(block: () -> Void) {
        if NSThread.isMainThread() {
            block()
        }
        else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                block()
            })
        }
    }
}


// MARK: - UIViewController
extension RealmTableViewController {
    public override func viewDidLoad() {
        
        self.viewLoaded = true
        
        self.updateFetchedResultsController()
    }
}

// MARK: - UIViewControllerDataSource
extension RealmTableViewController {
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.numberOfSections()
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fetchedResultsController.numberOfRowsForSectionIndex(section)
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.fetchedResultsController.titleForHeaderInSection(section)
    }
}


// MARK: - RBQFetchedResultsControllerDelegate
extension RealmTableViewController: RBQFetchedResultsControllerDelegate {
    public func controllerWillChangeContent(controller: RBQFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    public func controller(controller: RBQFetchedResultsController, didChangeSection section: RBQFetchedResultsSectionInfo, atIndex sectionIndex: UInt, forChangeType type: NSFetchedResultsChangeType) {
        
        let tableView = self.tableView
        
        switch(type) {
        
        case .Insert:
            let insertedSection = NSIndexSet(index: Int(sectionIndex))
            tableView.insertSections(insertedSection, withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            let deletedSection = NSIndexSet(index: Int(sectionIndex))
            tableView.deleteSections(deletedSection, withRowAnimation: UITableViewRowAnimation.Fade)
        default:
             break
        }
    }
    
    public func controller(controller: RBQFetchedResultsController, didChangeObject anObject: RBQSafeRealmObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        
        let tableView = self.tableView
        
        switch(type) {
        
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        case .Update:
            if tableView.indexPathsForVisibleRows?.contains(indexPath!) == true {
                tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            }
        case .Move:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    public func controllerDidChangeContent(controller: RBQFetchedResultsController) {
        self.tableView.endUpdates()
    }
}
