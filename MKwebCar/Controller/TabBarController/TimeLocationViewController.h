//  TimeLocationViewController.h
//  MYF1
//
//  Created by wisdom on 14-9-11.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKAppDelegate.h"
#import "DataFormServer.h"
@interface TimeLocationViewController : UIViewController<BMKMapViewDelegate,BMKGeoCodeSearchDelegate,DataFormServerDelegate>
@end
