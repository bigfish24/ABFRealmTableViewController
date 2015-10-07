//
//  TaskObject.swift
//  RealmTableViewControllerExample
//
//  Created by Adam Fish on 10/7/15.
//  Copyright © 2015 Adam Fish. All rights reserved.
//

import RealmSwift

class TaskObject: Object {
    // MARK: Model
    dynamic var taskId = 0
    dynamic var taskDescription = ""
    
    // MARK: Realm Swift
    override static func primaryKey() -> String? {
        return "taskId"
    }
    
    class func task(description: String) -> TaskObject {
        let task = TaskObject()
        
        task.taskId = try! Realm().objects(TaskObject).count
        task.taskDescription = description
        
        return task
    }
}
