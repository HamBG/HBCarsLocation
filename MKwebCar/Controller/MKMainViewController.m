//
//  MKMainViewController.m
//  MKwebCar
//
//  Created by moumouK on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKMainViewController.h"
#import "MKAppDelegate.h"

@implementation MKMainViewController
- (void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"groupname"];
    self.navigationItem.title = [str isEqualToString:@""]?[defaults objectForKey:@"account"]:[defaults objectForKey:@"groupname"];

}

#pragma mark - Actions
- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

@end
