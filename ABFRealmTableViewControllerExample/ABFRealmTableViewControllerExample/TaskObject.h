//
//  TaskObject.h
//  ABFRealmTableViewControllerExample
//
//  Created by Adam Fish on 8/5/15.
//  Copyright (c) 2015 Adam Fish. All rights reserved.
//

#import <Realm/Realm.h>

@interface TaskObject : RLMObject

@property NSInteger taskId;

@property NSString *taskDescription;

+ (instancetype)taskWithDescription:(NSString *)description;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<TaskObject>
RLM_ARRAY_TYPE(TaskObject)
