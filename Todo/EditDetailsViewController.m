//
//  EditDetailsViewController.m
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import "EditDetailsViewController.h"
#import <UserNotifications/UserNotifications.h>


@interface EditDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameFT;
@property (weak, nonatomic) IBOutlet UITextField *describtionTF;
@property (strong, nonatomic) IBOutlet UIView *prioritySe;
@property (weak, nonatomic) IBOutlet UISegmentedControl *progressSe;
@property (weak, nonatomic) IBOutlet UITextField *dateOfCreationTf;
@property (weak, nonatomic) IBOutlet UIButton *doneBtn;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySE;
@property (weak, nonatomic) IBOutlet UIDatePicker *reminderDatePi;
@property (weak, nonatomic) IBOutlet UILabel *reminderLable;
@end

@implementation EditDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
}
- (IBAction)editBtn:(id)sender {
    
    [self setEnable];
    
}
- (IBAction)doneBtn:(id)sender {
    
    NSDateFormatter* dateFormatter = [NSDateFormatter new];
        [dateFormatter setDateFormat:@"dd-MM-yyyy HH:mm:ss"];
      NSString *dateString = [dateFormatter stringFromDate:_reminderDatePi.date];
      
      Tasks *temp = [[Tasks alloc] initWithValues:_nameFT.text :_describtionTF.text :(int)_prioritySE.selectedSegmentIndex :(int)_progressSe.selectedSegmentIndex:dateString];
      [_pro updateTask:[self task]:temp];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


-(void)setEnable{
      _nameFT.enabled=YES;
      _describtionTF.enabled=YES;
      _prioritySE.enabled=YES;
      _progressSe.enabled=YES;
      _reminderDatePi.enabled=YES;
     _doneBtn.enabled=YES;
}
-(void) updateUI
{
    _nameFT.text = _task.name;
    _describtionTF.text = _task.desc;
    _dateOfCreationTf.text = _task.dateOfCreation;
    _reminderLable.text = _task.reminderDate;
    switch (_task.pri)
    {
        case 0:
            _prioritySE.selectedSegmentIndex = 0;
            break;
        case 1:
          _prioritySE.selectedSegmentIndex = 1;
            break;
        case 2:
        _prioritySE.selectedSegmentIndex = 2;
            break;
        default:
            break;
    }
    switch (_task.status) {
        case 0:
           _progressSe.selectedSegmentIndex = 0;
            break;
        case 1:
            _progressSe.selectedSegmentIndex = 1;
            
            break;
        case 2:
            _progressSe.selectedSegmentIndex = 1;
            
            break;
        default:
            break;
    }
}
-(void) showNotification
{
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc]init];
        NSDateComponents *triggerDate = [[NSCalendar currentCalendar]
                                         components:NSCalendarUnitYear +
                                         NSCalendarUnitMonth + NSCalendarUnitDay +
                                         NSCalendarUnitHour + NSCalendarUnitMinute +
                                         NSCalendarUnitSecond fromDate:[_reminderDatePi date]];
        content.title = @"Reminder for task";
        content.subtitle = _nameFT.text;
        content.body = _describtionTF.text;
        content.badge = [NSNumber numberWithInteger:([UIApplication sharedApplication].applicationIconBadgeNumber + 1)];
        
        content.sound = [UNNotificationSound defaultSound];
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:triggerDate repeats:NO];
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:_nameFT.text content:content trigger:trigger];
        [center addNotificationRequest:request withCompletionHandler:nil];
        
}
-(void) deleteCertainNotification
{
    NSArray *arr = [NSArray arrayWithObject:_task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}


@end
