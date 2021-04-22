//
//  DoneViewController.m
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import "DoneViewController.h"
#import "EditDetailsViewController.h"
#import <UserNotifications/UserNotifications.h>
@interface DoneViewController ()
{
    BOOL *isSorted;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSUserDefaults *userDefaults;
@property NSMutableArray *tasks;
@property NSMutableArray *doneTasks;
@property NSMutableArray *highTasks;
@property NSMutableArray *medTasks;
@property NSMutableArray *lowTasks;

@end

@implementation DoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSorted=NO;
}

- (void)viewWillAppear:(BOOL)animated{
    _tasks=[NSMutableArray new];
    _doneTasks=[NSMutableArray new];
    _highTasks=[NSMutableArray new];
    _medTasks=[NSMutableArray new];
    _lowTasks=[NSMutableArray new];
    [self getFromUserDefaults];
    for(int i=0;i<[_tasks count];i++){
        if([[_tasks objectAtIndex:i] status]==1){
            [_doneTasks addObject:[_tasks objectAtIndex:i]];
            if ([[_tasks objectAtIndex:i] pri]==0) {
               [_highTasks addObject:[_tasks objectAtIndex:i]];
            }else if ([[_tasks objectAtIndex:i] pri]==1){
                [_medTasks addObject:[_tasks objectAtIndex:i]];
            }else{
                [_lowTasks addObject:[_tasks objectAtIndex:i]];
            }
        }
     }
    [self.tableView reloadData];
}

- (IBAction)sortBtn:(id)sender {
    isSorted=YES;
    [_tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isSorted==YES){
        
        return 3;
        
    }else{
         return 1;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *num=@"Done:";
    
    if(isSorted==YES){
    
    
    switch (section) {
        case 0:
            num=@"High";
            break;
        case 1:
        num=@"Med";
        break;
            
        case 2:
        num= @"Low";
        break;
            
        default:
            break;
    }
        
    }
    return num;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (isSorted) {
        
    }else{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   [_tasks removeObject:[_doneTasks objectAtIndex:(int)indexPath.row]];
        [_doneTasks removeObjectAtIndex:(int)indexPath.row];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_tasks objectAtIndex:(int)indexPath.row]];
    }
        
    }
    [tableView reloadData];
}

-(void) deleteCertainNotification: (Tasks*) task
{
    NSArray *arr = [NSArray arrayWithObject:task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}

-(void)addToUserDefault{
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }else{
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_tasks];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(isSorted==YES){
        int num;
        
        switch (section) {
            case 0:
                num=_highTasks.count;
                break;
            case 1:
            num=_medTasks.count;
            break;
                
            case 2:
            num= _lowTasks.count;
            break;
                
            default:
                break;
        }
        return num;
        
    }else{
         return [_doneTasks count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"forIndexPath:indexPath];
   if (isSorted==YES) {
         switch (indexPath.section ) {
             case 0:
                 cell.textLabel.text=[[_highTasks objectAtIndex:indexPath.row] name];
                 cell.imageView.image=[UIImage imageNamed:@"g"];
                 break;
                 
                 case 1:
                            cell.textLabel.text=[[_medTasks objectAtIndex:indexPath.row] name];
                 cell.imageView.image=[UIImage imageNamed:@"y"];
                            break;
                 case 2:
                 cell.textLabel.text=[[_lowTasks objectAtIndex:indexPath.row] name];
                 cell.imageView.image=[UIImage imageNamed:@"r"];
                 break;
                            
             default:
                 break;
         }
     }else{
   cell.textLabel.text=[[_doneTasks objectAtIndex:indexPath.row] name];
         if ([[_doneTasks objectAtIndex:indexPath.row] pri]==0) {
                    cell.imageView.image=[UIImage imageNamed:@"g"];
                }else if ([[_doneTasks objectAtIndex:indexPath.row] pri]==1){
                    cell.imageView.image=[UIImage imageNamed:@"y"];
                }else{
                    cell.imageView.image=[UIImage imageNamed:@"r"];
                }
           }
            
    return cell;
}

-(void)getFromUserDefaults{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
            _tasks=object;

        }
}


@end
