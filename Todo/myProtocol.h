//
//  myProtocol.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Tasks.h"

NS_ASSUME_NONNULL_BEGIN

@protocol myProtocol <NSObject>
-(void)addTasks: (Tasks*) task;
-(void)updateTask: (Tasks*) oldTask : (Tasks*) newTask;

@end

NS_ASSUME_NONNULL_END
