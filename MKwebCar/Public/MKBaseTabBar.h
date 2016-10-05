//
//  NTHBaseTabBar.h
//  NewlyTech
//
//  Created by KJdiaoge on 16/3/30.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  在需要的地方实现协议，NTHTabBar和NTHTabBarController通过代理通知事件
 */
@protocol MKTabBarDelegate <NSObject>

@optional
/**
 *  @param from 从哪个视图(视图索引)
 *  @param to   到哪个视图(视图索引)
 */
- (void)tabBarDidSelectBtnFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface MKBaseTabBar : UIView

@property (nonatomic,weak) id<MKTabBarDelegate> delegate;
/**
 *  提供给外界创建按钮
 *
 *  @param norName 默认状态的图片
 *  @param disName 高亮状态的图片
 */
- (void)addTabBarButtonWithNormalImageName:(NSString *)norName andDisableImageName:(NSString *)disName andTitle:(NSString *)title;

@end
