//
//  ABFRealmTableViewController.h
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABFRealmTableViewController, RLMRealm, RBQFetchedResultsController;

@interface ABFRealmTableViewController : UITableViewController

/**
 *  The entity (Realm object) name
 */
@property (nonatomic, strong) IBInspectable NSString *entityName;

/**
 *  Predicate supported by Realm
 *
 *  http://realm.io/docs/cocoa/0.89.2/#querying-with-predicates
 */
@property (nonatomic, strong) NSPredicate *basePredicate;

/**
 *  Array of RLMSortDescriptors
 *
 *  http://realm.io/docs/cocoa/0.89.2/#ordering-results
 */
@property (nonatomic, strong) NSArray *sortDescriptors;

/**
 *  The section name key path used to create the sections. Can be nil if no sections.
 */
@property (nonatomic, strong) IBInspectable NSString *sectionNameKeyPath;

/**
 *  The Realm in which the given entity resides in
 *
 *  Default is [RLMRealm defaultRealm]
 */
@property (nonatomic, strong) RLMRealm *realm;

/**
 *  The underlying RBQFetchedResultsController
 */
@property (readonly, nonatomic) RBQFetchedResultsController *fetchedResultsController;

@end
