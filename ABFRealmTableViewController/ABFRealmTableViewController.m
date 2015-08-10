//
//  ABFRealmTableViewController.m
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import "ABFRealmTableViewController.h"

#import <Realm/Realm.h>
#import <RBQFetchedResultsController/RBQFetchedResultsController.h>
#import <RBQFetchedResultsController/RBQFetchRequest.h>

@interface ABFRealmTableViewController () <RBQFetchedResultsControllerDelegate>

@property (assign, nonatomic) BOOL viewLoaded;

@end

@implementation ABFRealmTableViewController
@synthesize realm = _realm;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self baseInit];
    }
    
    return self;
}

- (void)baseInit
{
    _fetchedResultsController = [[RBQFetchedResultsController alloc] init];
    _fetchedResultsController.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.fetchedResultsController performFetch];
    
    self.viewLoaded = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Setters

- (void)setEntityName:(NSString *)entityName
{
    _entityName = entityName;
    
    [self updateFetchedResultsController];
}

- (void)setBasePredicate:(NSPredicate *)basePredicate
{
    _basePredicate = basePredicate;
    
    [self updateFetchedResultsController];
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors
{
    _sortDescriptors = sortDescriptors;
    
    [self updateFetchedResultsController];
}

- (void)setSectionNameKeyPath:(NSString *)sectionNameKeyPath
{
    _sectionNameKeyPath = sectionNameKeyPath;
    
    [self updateFetchedResultsController];
}

- (void)setRealm:(RLMRealm *)realm
{
    _realm = realm;
    
    [self updateFetchedResultsController];
}

#pragma mark - Getters

- (RLMRealm *)realm
{
    if (!_realm) {
        return [RLMRealm defaultRealm];
    }
    
    return _realm;
}

#pragma mark - Private

- (void)updateFetchedResultsController
{
    if (self.entityName &&
        !self.viewLoaded) {
        
        RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:self.entityName
                                                                            inRealm:self.realm
                                                                          predicate:self.basePredicate];
        
        [self.fetchedResultsController updateFetchRequest:fetchRequest
                                       sectionNameKeyPath:self.sectionNameKeyPath
                                           andPeformFetch:NO];
    }
    else if (self.entityName) {
    
        typeof(self) __weak weakSelf = self;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            RBQFetchRequest *fetchRequest = [RBQFetchRequest fetchRequestWithEntityName:weakSelf.entityName
                                                                                inRealm:weakSelf.realm
                                                                              predicate:weakSelf.basePredicate];
            
            [weakSelf.fetchedResultsController updateFetchRequest:fetchRequest
                                               sectionNameKeyPath:weakSelf.sectionNameKeyPath
                                                   andPeformFetch:weakSelf.viewLoaded];
            
            if (weakSelf.viewLoaded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            }
        });
    }
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.fetchedResultsController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.fetchedResultsController numberOfRowsForSectionIndex:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.fetchedResultsController titleForHeaderInSection:section];
}

#pragma mark - <RBQFetchedResultsControllerDelegate>

- (void)controllerWillChangeContent:(RBQFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(RBQFetchedResultsController *)controller
   didChangeObject:(RBQSafeRealmObject *)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            if ([[tableView indexPathsForVisibleRows] containsObject:indexPath]) {
                [tableView reloadRowsAtIndexPaths:@[indexPath]
                                 withRowAnimation:UITableViewRowAnimationFade];
            }
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(RBQFetchedResultsController *)controller
  didChangeSection:(RBQFetchedResultsSectionInfo *)section
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
    UITableView *tableView = self.tableView;
    
    if (type == NSFetchedResultsChangeInsert) {
        NSIndexSet *insertedSection = [NSIndexSet indexSetWithIndex:sectionIndex];
        
        [tableView insertSections:insertedSection withRowAnimation:UITableViewRowAnimationFade];
    }
    else if (type == NSFetchedResultsChangeDelete) {
        NSIndexSet *deletedSection = [NSIndexSet indexSetWithIndex:sectionIndex];
        
        [tableView deleteSections:deletedSection withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)controllerDidChangeContent:(RBQFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
