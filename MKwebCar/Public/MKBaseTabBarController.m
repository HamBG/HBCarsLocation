//
//  NTZTabBarController.m
//  NewlyTech
//
//  Created by KJdiaoge on 16/3/30.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKBaseTabBarController.h"
#import "MKBaseTabBar.h"
#import "UIView+Frame.h"

@interface MKBaseTabBarController ()<MKTabBarDelegate>

@end

@implementation MKBaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 扩展控制器view的上面和下面
    // self.edgesForExtendedLayout = UIRectEdgeTop | UIRectEdgeBottom;
    
    // 1.0创建自定义的TabBar
    MKBaseTabBar *myTabBar = [[MKBaseTabBar alloc] init];
    myTabBar.frame = self.tabBar.bounds;
    myTabBar.backgroundColor = [UIColor clearColor];
    myTabBar.delegate = self;
    
    [self.tabBar addSubview:myTabBar];
    
    // 1.1根据系统子控制器的个数来创建自定义TabBar上按钮的个数
    // 通知自定义TabBar创建按钮，只要调用自定义TabBar的该方法就会创建一个按钮
    [myTabBar addTabBarButtonWithNormalImageName:@"location" andDisableImageName:@"location_h" andTitle:@"位置"];
    [myTabBar addTabBarButtonWithNormalImageName:@"guiji" andDisableImageName:@"guiji_h" andTitle:@"轨迹"];
    [myTabBar addTabBarButtonWithNormalImageName:@"tongji" andDisableImageName:@"tongji_h"  andTitle:@"统计"];
    [myTabBar addTabBarButtonWithNormalImageName:@"alarm" andDisableImageName:@"alarm_h"  andTitle:@"告警"];
    
    // 2.删除系统自带的tabBar
    //        [self.tabBar removeFromSuperview];
    //    [self setValue:myTabBar forKeyPath:@"tabBar"];
    
}


#pragma mark - NTHTabBarDelegate
- (void)tabBarDidSelectBtnFrom:(NSInteger)from to:(NSInteger)to
{
    // 切换子控制器
    self.selectedIndex = to;
}


@end
