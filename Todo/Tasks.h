//
//  Tasks.h
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tasks : NSObject
@property NSString *name;
@property NSString *desc;
@property NSInteger pri;
@property NSInteger status;
@property NSString *dateOfCreation;
@property NSString *reminderDate;
@property NSString *file;


-(id)initWithValues:(NSString*)name : (NSString*)description : (NSInteger) pri : (NSInteger) stat: (NSString*) reminderDate ;

@end

NS_ASSUME_NONNULL_END
