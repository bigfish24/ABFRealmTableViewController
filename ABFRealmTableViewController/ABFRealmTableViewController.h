//
//  ABFRealmTableViewController.h
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ABFRealmTableViewController, RLMRealm, RLMRealmConfiguration, RBQFetchedResultsController;

@interface ABFRealmTableViewController : UITableViewController

/**
 *  The entity (Realm object) name
 */
@property (nonatomic, strong, nonnull) IBInspectable NSString *entityName;

/**
 *  Predicate supported by Realm
 *
 *  http://realm.io/docs/cocoa/0.89.2/#querying-with-predicates
 */
@property (nonatomic, strong, nullable) NSPredicate *basePredicate;

/**
 *  Array of RLMSortDescriptors
 *
 *  http://realm.io/docs/cocoa/0.89.2/#ordering-results
 */
@property (nonatomic, strong, nullable) NSArray *sortDescriptors;

/**
 *  The section name key path used to create the sections. Can be nil if no sections.
 */
@property (nonatomic, strong, nullable) IBInspectable NSString *sectionNameKeyPath;

/**
 *  The configuration for the Realm in which the entity resides
 *
 *  Default is [RLMRealmConfiguration defaultConfiguration]
 */
@property (nonatomic, strong, nonnull) RLMRealmConfiguration *realmConfiguration;

/**
 *  The Realm in which the given entity resides in
 */
@property (nonatomic, readonly, nonnull) RLMRealm *realm;

/**
 *  The underlying RBQFetchedResultsController
 */
@property (nonatomic, readonly, nonnull) RBQFetchedResultsController *fetchedResultsController;

/**
 *  Retrieve the RLMObject for a given index path
 *
 *  @warning Returned object is not thread-safe.
 *
 *  @param indexPath the index path of the object
 *
 *  @return RLMObject
 */
- (nullable id)objectAtIndexPath:(nonnull NSIndexPath *)indexPath;

@end
