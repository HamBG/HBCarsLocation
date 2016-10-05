//
//  MKButton.h
//
//  Created by moumouK on 16/8/10.
//  Copyright © 2016年 My. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void(^finishBlock)();

@interface MKButton : UIView

@property (nonatomic,copy) finishBlock translateBlock;

- (void)clickBtn;

@end
