//
//  CarInfo.h
//  MYF1
//
//  Created by wisdom on 14-10-21.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarInfo : NSObject
@property (nonatomic,readwrite)  NSString *carno;
@property (nonatomic,readwrite)  NSString *gpslatutude;
@property (nonatomic,readwrite)  NSString *gpslongitude;
@property (nonatomic,readwrite)  NSString *gpsstatus;
@property (nonatomic,readwrite)  NSString *carinfo;

@end
