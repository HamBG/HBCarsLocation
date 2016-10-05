//
//  NTHBaseTabBarButton.m
//  NewlyTech
//
//  Created by KJdiaoge on 16/3/30.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKBaseTabBarButton.h"
#import "UIView+Frame.h"

@implementation MKBaseTabBarButton

/**
 *  重写该方法取消系统按钮的高亮状态
 */
- (void)setHighlighted:(BOOL)highlighted
{
    
}

/**
 *  重写 layoutSubviews ，自定义button中显示内容的属性(如果图片包含文字，且大小合适，则注释此处)
 */
- (void)layoutSubviews
{
    [super layoutSubviews];

    //1.0 设置button上加载图片的位置和大小
    self.imageView.y = 5;
    self.imageView.width = 25;
    self.imageView.height = 25;
    self.imageView.x = (self.width - self.imageView.width)/2.0;

    //1.1 设置图片的显示模式
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //1.2 设置文本显示的位置
    self.titleLabel.x = self.imageView.x - (self.titleLabel.width - self.imageView.width)/2.0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 2;

    //1.3 设置文本字体
     self.titleLabel.font = [UIFont systemFontOfSize:10];
    
    //1.4设置文本阴影和位置
    self.titleLabel.shadowColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end
