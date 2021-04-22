//
//  EditDetailsViewController.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tasks.h"
#import "myProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditDetailsViewController : UIViewController
@property Tasks *task;
@property id <myProtocol> pro;
@end

NS_ASSUME_NONNULL_END
