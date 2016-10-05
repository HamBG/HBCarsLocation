//
//  DataFormServer.h
//  HZVolunteer
//
//  Created by wisdom on 14-11-20.
//  Copyright (c) 2014年 MY. All rights reserved.
//
/**
 *  从服务器获取数据类，包括数据的请求、接收、解析，用delegate返回解析后的数据
 *
 *  @return ，用delegate返回解析后的数据
 */

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "Constants.h"
@protocol DataFormServerDelegate <NSObject>
@optional
- (void)getResultJson:(NSArray *)resultJson;
- (void)getDictionaryJson:(NSDictionary *)resultJson;

@end
@interface DataFormServer : NSObject{
    id<DataFormServerDelegate> delegate;
}
@property (nonatomic,retain)NSMutableString *element;
//@property (nonatomic,retain)UIImageView *imageView;
@property(nonatomic,retain) NSArray *resultJSON;
@property (retain,nonatomic)id<DataFormServerDelegate>delegate;

-(void) getsDataFromServer:(NSDictionary *)parameters methodName:(NSString *)methodName isReturnArry:(BOOL)isReturnArry;

@end
