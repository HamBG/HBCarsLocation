//
//  MKTextField.h
//
//  Created by moumouK on 16/8/10.
//  Copyright © 2016年 My. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef void (^TextFieldChangeCallBack)(NSString *);
@interface MKTextField : UIView

//文本框
@property (nonatomic,strong) UITextField *textField;
//注释信息
@property (nonatomic,copy) NSString *ly_placeholder;

//光标颜色
@property (nonatomic,strong) UIColor *cursorColor;

//注释普通状态下颜色
@property (nonatomic,strong) UIColor *placeholderNormalStateColor;

//注释选中状态下颜色
@property (nonatomic,strong) UIColor *placeholderSelectStateColor;

/**
 *  block方法变量
 */
@property (nonatomic, copy) TextFieldChangeCallBack textFieldChangeCallBack;

@end
