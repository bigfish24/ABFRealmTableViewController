//
//  TaskObject.m
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import "TaskObject.h"

@implementation TaskObject

// Specify default values for properties

+ (NSDictionary *)defaultPropertyValues
{
    return @{@"taskDescription": @""};
}

+ (NSString *)primaryKey
{
    return @"taskId";
}

+ (instancetype)taskWithDescription:(NSString *)description
{
    NSUInteger taskCount = [TaskObject allObjects].count;
    
    TaskObject *task = [[TaskObject alloc] init];
    task.taskId = taskCount;
    task.taskDescription = description;
    
    return task;
}

@end
