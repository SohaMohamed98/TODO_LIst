//
//  ViewController.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myProtocol.h"
@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate,myProtocol>

@end

