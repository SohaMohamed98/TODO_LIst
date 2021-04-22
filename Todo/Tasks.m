//
//  Tasks.m
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import "Tasks.h"

@implementation Tasks

-(id)initWithValues:(NSString*)name : (NSString*)desc : (NSInteger) pri : (NSInteger) stat: (NSString*) reminderDate {
self = [super init];
_name = name;
_desc = desc;
_pri = pri;
_status = stat;
NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
_dateOfCreation = [dateFormatter stringFromDate:[NSDate date]];

    return self;
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeInt:self.pri forKey:@"pri"];
    [encoder encodeInt:self.status forKey:@"status"];
    [encoder encodeObject:self.dateOfCreation forKey:@"dateOfCreation"];
    [encoder encodeObject:self.file forKey:@"file"];

}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.desc = [decoder decodeObjectForKey:@"desc"];
        self.pri = [decoder decodeIntForKey:@"pri"];
        self.status = [decoder decodeIntForKey:@"status"];
        self.dateOfCreation = [decoder decodeObjectForKey:@"dateOfCreation"];
        self.dateOfCreation = [decoder decodeObjectForKey:@"file"];

    }
     return self;
}

@end
