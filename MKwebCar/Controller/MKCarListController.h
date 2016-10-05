//
//  MKCarListController.h
//  MKwebCar
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//
#import "BaseTreeViewController.h"
#import "DataFormServer.h"


@interface MKCarListController : BaseTreeViewController<DataFormServerDelegate>
@property(nonatomic,retain) NSArray *resultJSON;
@end
