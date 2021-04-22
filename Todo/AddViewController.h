//
//  AddViewController.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddViewController : UIViewController
@property BOOL isGranted;

@property Tasks *task;

@end

NS_ASSUME_NONNULL_END
