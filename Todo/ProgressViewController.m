//
//  ProgressViewController.m
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import "ProgressViewController.h"
#import "EditDetailsViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface ProgressViewController ()
{
    BOOL *isSorted;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property NSMutableArray *tasks;
@property NSMutableArray *inProgressTasks;
@property NSMutableArray *highTasks;
@property NSMutableArray *medTasks;
@property NSMutableArray *lowTasks;
@property NSUserDefaults *userDefaults;

@end

@implementation ProgressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isSorted=NO;
}
- (IBAction)sortBtn:(id)sender {
    isSorted=YES;
    [_tableView reloadData];
    
}


- (void)viewWillAppear:(BOOL)animated{
    _tasks=[NSMutableArray new];
    _inProgressTasks=[NSMutableArray new];
    _highTasks=[NSMutableArray new];
    _medTasks=[NSMutableArray new];
    _lowTasks=[NSMutableArray new];
    [self getFromUserDefaults];
    for(int i=0;i<[_tasks count];i++){
        if([[_tasks objectAtIndex:i] status]==0){
            [_inProgressTasks addObject:[_tasks objectAtIndex:i]];
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
-(void)getFromUserDefaults{
        _userDefaults = [NSUserDefaults standardUserDefaults];
        if([_userDefaults objectForKey:@"data"]!=nil){
                NSData *encodedObject = [_userDefaults objectForKey:@"data"];
                NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
                _tasks=object;

            }
    }


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if(isSorted==YES){
        
        return 3;
        
    }else{
         return 1;
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
         return [_inProgressTasks count];
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
  cell.textLabel.text=[[_inProgressTasks objectAtIndex:indexPath.row] name];
        if ([[_inProgressTasks objectAtIndex:indexPath.row] pri]==0) {
            cell.imageView.image=[UIImage imageNamed:@"g"];
        }else if ([[_inProgressTasks objectAtIndex:indexPath.row] pri]==1){
            cell.imageView.image=[UIImage imageNamed:@"y"];
        }else{
            cell.imageView.image=[UIImage imageNamed:@"r"];
        }
          }
            
    return cell;
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *num=@"progress:";
    
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
    {   [_tasks removeObject:[_inProgressTasks objectAtIndex:(int)indexPath.row]];
        [_inProgressTasks removeObjectAtIndex:(int)indexPath.row];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_tasks objectAtIndex:(int)indexPath.row]];
    }
        
    }
}

-(void) deleteCertainNotification: (Tasks*) task
{
    NSArray *arr = [NSArray arrayWithObject:task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}


-(NSIndexPath*) tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EditDetailsViewController *vi=[self.storyboard instantiateViewControllerWithIdentifier:
                               @"editvc" ];
    
    if (isSorted==YES) {
        switch (indexPath.section ) {
            case 0:
                vi.task=[_highTasks objectAtIndex:indexPath.row];
                                  [vi setPro:self];
                                
                              [self.navigationController pushViewController:vi animated:YES];
               
                break;
                
            case 1:
                vi.task=[_medTasks objectAtIndex:indexPath.row];
                                  [vi setPro:self];
                                
                              [self.navigationController pushViewController:vi animated:YES];
                          
                break;
            case 2:
                 
                
                   vi.task=[_lowTasks objectAtIndex:indexPath.row];
                   [vi setPro:self];
                 
               [self.navigationController pushViewController:vi animated:YES];
                break;
                           
            default:
                break;
        }
    }else{
       
            vi.task=[_inProgressTasks objectAtIndex:indexPath.row];
            [vi setPro:self];
          
        [self.navigationController pushViewController:vi animated:YES];
    }


return indexPath;
}
- (void)updateTask:(Tasks *)oldTask : (Tasks *)newTask {
    [_tasks removeObject:oldTask];
    [_tasks addObject:newTask];
    [_inProgressTasks removeObject:oldTask];
    [_inProgressTasks addObject:newTask];
    [self addToUserDefault];
    
    [self.tableView reloadData];
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


@end
