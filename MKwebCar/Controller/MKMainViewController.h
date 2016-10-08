//
//  MKMainViewController.h
//  MKwebCar
//
//  Created by moumouK on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataFormServer.h"
#import "MKAppDelegate.h"

@interface MKMainViewController : UIViewController<BMKMapViewDelegate,DataFormServerDelegate>
@property(nonatomic,retain) NSArray *resultJSON;

@end
