//
//  NTHBaseTabBar.m
//  NewlyTech
//
//  Created by KJdiaoge on 16/3/30.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKBaseTabBar.h"
#import "MKBaseTabBarButton.h"
#import "UIImage+Extension.h"

@interface MKBaseTabBar()
// 定义变量记录当前选中的按钮
@property (nonatomic, weak) UIButton *selectBtn;

@end

@implementation MKBaseTabBar
/**
 *  提供给外界创建按钮
 *
 *  @param norName 默认状态的图片
 *  @param disName 高亮状态的图片
 */
- (void)addTabBarButtonWithNormalImageName:(NSString *)norName andDisableImageName:(NSString *)disName andTitle:(NSString *)title
{
    //1.1 创建按钮
    //    NTHBaseTabBarButton *btn = [[NTHBaseTabBarButton alloc] init];
    MKBaseTabBarButton *btn = [MKBaseTabBarButton buttonWithType:UIButtonTypeCustom];
    
    //1.2 设置按钮上显示的图片和文字
    //1.2.1 设置默认状态图片（注意：如果需要拉伸image，用 setBackgroundImage，保证原来尺寸用 setImage）
    [btn setImage:[UIImage imageNamed:norName] forState:UIControlStateNormal];
    //1.2.2 设置不可用状态图片
    [btn setImage:[UIImage imageNamed:disName] forState:UIControlStateDisabled];
    //1.2.3 设置标题
    [btn setTitle:title forState:UIControlStateNormal];
    //1.2.4 设置TitleColor
    [btn setTitleColor:RGBCOLOR(255, 255, 255) forState:UIControlStateNormal];
    [btn setTitleColor:RGBCOLOR(25, 166, 217) forState:UIControlStateDisabled];
    //1.2.4 设置button背景颜色
    [btn setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(25, 166, 217)] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateDisabled];
    
    //1.3 添加按钮到自定义TabBar
    [self addSubview:btn];
//    self.backgroundColor = RGBCOLOR(25, 166, 217);
    
    //1.4 监听按钮点击事件
    [btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchDown];
    
    //1.5 设置默认选中按钮
    if (1 == self.subviews.count) {
        [self btnOnClick:btn];
    }
    
    //1.6 设置按钮高亮状态不调整图片
    btn.adjustsImageWhenHighlighted = NO;
}

/**
 *  设置tabBar中按钮的frame
 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (int i = 0; i < self.subviews.count; i ++) {
        UIButton *btn = self.subviews[i];
        
        // 2.1 设置frame
        CGFloat btnY = 0;
        CGFloat btnW = self.frame.size.width / self.subviews.count;
        CGFloat btnH = self.frame.size.height;
        CGFloat btnX = i * btnW;
        btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        // 2.2 设置按钮的Tag作为将来切换子控制器的索引
        btn.tag = i;
    }
}

/**
 *  监听点击事件
 *
 *  @param btn 当前被点击按钮
 */
- (void) btnOnClick:(UIButton *)btn
{
    // 切换子控制器
    // 通知TabBarController切换控制器
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelectBtnFrom:to:)]) {
        [self.delegate tabBarDidSelectBtnFrom:self.selectBtn.tag to:btn.tag];
    }
    
    // 0.取消上一次选中的按钮
    self.selectBtn.enabled = YES;
    // 1.设置当前被点击按钮为选中状态
    btn.enabled = NO;
    // 2.记录当前选中的按钮
    self.selectBtn = btn;
}

@end
