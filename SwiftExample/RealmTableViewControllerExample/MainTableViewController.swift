//
//  MainTableViewController.swift
//  RealmTableViewControllerExample
//
//  Created by Adam Fish on 10/7/15.
//  Copyright © 2015 Adam Fish. All rights reserved.
//

import UIKit
import Colours
import RealmSwift
import SwiftFetchedResultsController

class MainTableViewController: RealmTableViewController {

    let colors = [
        UIColor.seafoamColor(),
        UIColor.robinEggColor(),
        UIColor.cornflowerColor(),
        UIColor.salmonColor(),
        UIColor.violetColor(),
        UIColor.periwinkleColor(),
        UIColor.pastelGreenColor(),
        UIColor.bananaColor(),
        UIColor.carrotColor(),
        UIColor.chiliPowderColor(),
        UIColor.lavenderColor(),
        UIColor.fuschiaColor(),
        UIColor.icebergColor(),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.backgroundColor = UIColor.whiteColor()
    }
    
    // MARK: Actions
    
    @IBAction func didClickAddButton(sender: UIBarButtonItem) {
        let textPrompt = UIAlertController(title: "Create A Task", message: "Enter your task:", preferredStyle: UIAlertControllerStyle.Alert)
        
        textPrompt.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Task description"
        }
        
        let save = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
            if let textField = textPrompt.textFields?.first {
                
                if let text = textField.text {
                    
                    let task = TaskObject.task(text.capitalizedString)
                    
                    try! Realm().beginWrite()
                    try! Realm().add(task, update: false)
                    try! Realm().commitWrite()
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        textPrompt.addAction(save)
        textPrompt.addAction(cancel)
        
        self.presentViewController(textPrompt, animated: true, completion: nil)
    }
}

// MARK: UITableViewDataSource
extension MainTableViewController {
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell", forIndexPath: indexPath)
        
        let task = self.objectAtIndexPath(TaskObject.self, indexPath: indexPath)
        
        cell.textLabel?.text = task?.taskDescription
        
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        let row = indexPath.row
        
        let colorIndex = row % self.colors.count
        
        cell.backgroundColor = self.colors[colorIndex]
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if let task = self.objectAtIndexPath(TaskObject.self, indexPath: indexPath) {
                try! Realm().beginWrite()
                try! Realm().delete(task)
                try! Realm().commitWrite()
            }
        }
    }
}

// MARK: UITableViewDelegate
extension MainTableViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44
    }
}
