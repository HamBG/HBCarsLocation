//
//  MKChangePwdController.m
//  MKwebCar
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKChangePwdController.h"
#import "MKAppDelegate.h"

@implementation MKChangePwdController
- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

@end
