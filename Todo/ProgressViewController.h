//
//  ProgressViewController.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface ProgressViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,myProtocol>

@end

NS_ASSUME_NONNULL_END
