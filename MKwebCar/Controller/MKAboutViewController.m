//
//  MKAboutViewController.m
//  MKwebCar
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKAboutViewController.h"
#import "MKAppDelegate.h"

@implementation MKAboutViewController
- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

@end
