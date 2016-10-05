//
//  JVLeftDrawerTableViewController.m
//  MKwebCar
//
//  Created by moumouK on  2015-01-15.
//  Copyright © 2015年 moyan. All rights reserved.
//

#import "MKLeftTableViewController.h"
#import "MKLeftTableViewCell.h"
#import "MKAppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "MKLoginViewController.h"

static const CGFloat kJVTableViewTopInset = 80.0;
static NSString * const kJVDrawerCellReuseIdentifier = @"JVDrawerCellReuseIdentifier";


@interface MKLeftTableViewController ()<UIAlertViewDelegate>
@property (nonatomic, strong) UIViewController *destinationViewController;
@end

@implementation MKLeftTableViewController

- (UIViewController *)destinationViewController{
    if (_destinationViewController == nil) {
        _destinationViewController = [[MKAppDelegate globalDelegate] MKmainViewController];
    }
    return _destinationViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.contentInset = UIEdgeInsetsMake(kJVTableViewTopInset, 0.0, 0.0, 0.0);
    self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKLeftTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJVDrawerCellReuseIdentifier forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleText = @"首页";
        cell.iconImage = [UIImage imageNamed:@"main_icon"];
    }else if (indexPath.row == 1) {
        cell.titleText = @"车辆信息";
        cell.iconImage = [UIImage imageNamed:@"car_icon"];
    }else if (indexPath.row == 2){
        cell.titleText = @"密码设置";
        cell.iconImage = [UIImage imageNamed:@"password_icon"];
    }else if (indexPath.row == 3){
        cell.titleText = @"关于应用";
        cell.iconImage = [UIImage imageNamed:@"relogin_icon"];
    }else{
        cell.titleText = @"退出登录";
        cell.iconImage = [UIImage imageNamed:@"logout_icon"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    self.destinationViewController = nil;
  
    if (indexPath.row == 0) {
        _destinationViewController = [[MKAppDelegate globalDelegate] MKmainViewController];
    }else if (indexPath.row == 1){
        _destinationViewController = [[MKAppDelegate globalDelegate] MKCarListController];
    }else if (indexPath.row == 2){
        _destinationViewController = [[MKAppDelegate globalDelegate] MKChangePwdController];
    }else if (indexPath.row == 3){
        _destinationViewController = [[MKAppDelegate globalDelegate] MKAboutViewController];
    }else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定退出登录吗" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
    if (indexPath.row != 4) {
        [[[MKAppDelegate globalDelegate] drawerViewController] setCenterViewController:self.destinationViewController];
        [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (!buttonIndex) {
        [[[MKAppDelegate globalDelegate] drawerViewController] setCenterViewController:self.destinationViewController];
        [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
    }else{
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setBool:NO forKey:@"autoLogin"];
        
        [[[MKAppDelegate globalDelegate] drawerViewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
