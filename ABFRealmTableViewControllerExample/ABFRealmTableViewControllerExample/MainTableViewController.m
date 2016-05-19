//
//  MainTableViewController.m
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import "MainTableViewController.h"
#import "TaskObject.h"

#import <Realm/Realm.h>
#import <RBQFetchedResultsController/RBQFetchedResultsController.h>
#import <Colours/Colours.h>

@interface MainTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *addButton;

@property (strong, nonatomic) NSArray *colors;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.colors = @[
                    [UIColor seafoamColor],
                    [UIColor robinEggColor],
                    [UIColor cornflowerColor],
                    [UIColor salmonColor],
                    [UIColor violetColor],
                    [UIColor periwinkleColor],
                    [UIColor pastelGreenColor],
                    [UIColor bananaColor],
                    [UIColor carrotColor],
                    [UIColor chiliPowderColor],
                    [UIColor lavenderColor],
                    [UIColor fuschiaColor],
                    [UIColor icebergColor],
                    ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UITableViewDataSource>

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    // Configure the cell...
    TaskObject *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = task.taskDescription;
    cell.textLabel.textColor = [UIColor whiteColor];
    
    // Assign cell a unique color
    NSUInteger row = indexPath.row;
    
    NSUInteger colorIndex = row % self.colors.count;
    
    cell.backgroundColor = self.colors[colorIndex];
    
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        TaskObject *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        [[RLMRealm defaultRealm] transactionWithBlock:^{
            [[RLMRealm defaultRealm] deleteObject:task];
        }];
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.f;
}

#pragma mark - Private

- (IBAction)didClickAddButton:(UIBarButtonItem *)sender
{
    UIAlertController *textPrompt = [UIAlertController alertControllerWithTitle:@"Create A Task"
                                                                        message:@"Enter your task:"
                                                                 preferredStyle:UIAlertControllerStyleAlert];
    
    [textPrompt addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Task description";
    }];
    
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"Save"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *action) {
                                                     
                                                     UITextField *textField = textPrompt.textFields[0];
                                                     
                                                     NSString *taskString = [textField.text capitalizedString];
                                                     
                                                     TaskObject *task = [TaskObject taskWithDescription:taskString];
                                                     
                                                     [[RLMRealm defaultRealm] beginWriteTransaction];
                                                     [[RLMRealm defaultRealm] addObject:task];
                                                     [[RLMRealm defaultRealm] commitWriteTransaction];
                                                 }];
                           
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [textPrompt addAction:save];
    [textPrompt addAction:cancel];
    
    [self presentViewController:textPrompt animated:YES completion:nil];
}

@end
