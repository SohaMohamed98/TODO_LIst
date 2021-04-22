//
//  ViewController.m
//  Todo
//
//  Created by SOHA on 4/5/21.
//  Copyright © 2021 SOHA. All rights reserved.
//

#import "ViewController.h"
#import "AddViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "EditDetailsViewController.h"


@interface ViewController ()
{
     BOOL isFiltered;
     NSMutableArray* filteredArr;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *arr;
@property NSMutableArray *defarr;
@property NSUserDefaults *userDefaults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
BOOL isGrantedNotificationAccess;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _arr = [NSMutableArray new];
    _defarr = [NSMutableArray new];
    filteredArr=[NSMutableArray new];
    isFiltered=NO;
     [self notificationAuth];
   [self getFromUserDefaults];

}

- (void)viewWillAppear:(BOOL)animated{
    [self getFromUserDefaults];
    _arr = [NSMutableArray new];
    for(int i=0;i<[_defarr count];i++){
    if([[_defarr objectAtIndex:i] status]==2){
        [_arr addObject:[_defarr objectAtIndex:i]];}

    }
    
    [_tableView reloadData];
}

-(void)getFromUserDefaults{
    _userDefaults = [NSUserDefaults standardUserDefaults];
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            NSMutableArray *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
        _defarr=object;
        
}
}

- (IBAction)addBtn:(id)sender {
    AddViewController *vi2 = [self.storyboard instantiateViewControllerWithIdentifier:@"addvc"];
    vi2.isGranted=isGrantedNotificationAccess;
    [self.navigationController pushViewController:vi2 animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numRows = 0 ;
    if(isFiltered)
       {
           numRows =  [filteredArr count];
       }
       else
       {
           numRows = [_arr count];
       }
    return  numRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    // Configure the cell...
    
    NSMutableArray* arr = [NSMutableArray new];
        if(isFiltered)
        {
            arr = filteredArr;
            cell.textLabel.text=[[filteredArr objectAtIndex:indexPath.row] name];
               if ([[filteredArr objectAtIndex:indexPath.row] pri]==0) {
                   cell.imageView.image=[UIImage imageNamed:@"g"];
               }else if ([[filteredArr objectAtIndex:indexPath.row] pri]==1){
                   cell.imageView.image=[UIImage imageNamed:@"y"];
               }else{
                   cell.imageView.image=[UIImage imageNamed:@"r"];
               }
            
        }
        else
        {
            arr =_arr;
            cell.textLabel.text=[[arr objectAtIndex:indexPath.row] name];
               if ([[arr objectAtIndex:indexPath.row] pri]==0) {
                   cell.imageView.image=[UIImage imageNamed:@"g"];
               }else if ([[arr objectAtIndex:indexPath.row] pri]==1){
                   cell.imageView.image=[UIImage imageNamed:@"y"];
               }else{
                   cell.imageView.image=[UIImage imageNamed:@"r"];
               }
        }
       
   
    
    
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *num=@"TODO:";
    
    return num;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if(isFiltered){
        EditDetailsViewController *vi = [self.storyboard instantiateViewControllerWithIdentifier:@"editvc"];
        vi.task=[filteredArr objectAtIndex:indexPath.row];
        [vi setPro:self];
        
        [self.navigationController pushViewController:vi animated:YES];
    }else{
        EditDetailsViewController *vi = [self.storyboard instantiateViewControllerWithIdentifier:@"editvc"];
        vi.task=[_arr objectAtIndex:indexPath.row];
        [vi setPro:self];
        
        [self.navigationController pushViewController:vi animated:YES];
    }
    
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {   [_defarr removeObject:[_arr objectAtIndex:(int)indexPath.row]];
        [_arr removeObjectAtIndex:(int)indexPath.row];
        [self addToUserDefault];
        
        [self.tableView reloadData];
        [self deleteCertainNotification:[_defarr objectAtIndex:(int)indexPath.row]];
    }
}

-(void) deleteCertainNotification: (Tasks*) task
{
    NSArray *arr = [NSArray arrayWithObject:task.name];
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center removePendingNotificationRequestsWithIdentifiers:arr];
}


-(void) notificationAuth
{
    isGrantedNotificationAccess = NO;
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    UNAuthorizationOptions options = UNAuthorizationOptionSound+UNAuthorizationOptionAlert;
    [center requestAuthorizationWithOptions:options completionHandler:^(BOOL granted, NSError * _Nullable error) {
        isGrantedNotificationAccess = granted;
    }];
}

- (void)updateTask:(Tasks *)oldTask : (Tasks *)newTask {
    [_defarr removeObject:oldTask];
    [_defarr addObject:newTask];
    [self addToUserDefault];
    
    [self.tableView reloadData];
}

-(void)addToUserDefault{
    if([_userDefaults objectForKey:@"data"]!=nil){
            NSData *encodedObject = [_userDefaults objectForKey:@"data"];
            encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_defarr];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }else{
            NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:_arr];
            [_userDefaults setObject:encodedObject forKey:@"data"];
            [_userDefaults synchronize];
        }
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isFiltered = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    filteredArr = [NSMutableArray new];
    if(searchText.length == 0)
    {
        isFiltered=NO;
    }
    
    else
    {
        isFiltered=YES;
        for (int i =0 ; i<[_arr count]; i++) {
            NSRange stringRange = [[[_arr objectAtIndex:i]name] rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(stringRange.location != NSNotFound)
            {
                [filteredArr addObject:[_arr objectAtIndex:i]];
            }
        }
        
        
    }
    [_tableView reloadData];
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_tableView resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isFiltered=NO;
    [_tableView reloadData];
    
}



@end
