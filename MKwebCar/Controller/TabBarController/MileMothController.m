//
//  MileMothController.m
//  MYF1
//
//  Created by wisdom on 14-9-17.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "MileMothController.h"
#import "MKAppDelegate.h"
#import "Constants.h"
#define METHOD (@"MileReportServlet")

@interface MileMothController(){
    NSArray *mothResults;
    __weak IBOutlet UILabel *moth1;
    __weak IBOutlet UILabel *moth2;
    __weak IBOutlet UILabel *moth3;
    __weak IBOutlet UILabel *moth4;
    __weak IBOutlet UILabel *moth5;
    __weak IBOutlet UILabel *moth6;
  
    __weak IBOutlet UILabel *mile1;
    __weak IBOutlet UILabel *mile2;
    __weak IBOutlet UILabel *mile3;
    __weak IBOutlet UILabel *mile4;
    __weak IBOutlet UILabel *mile5;
    __weak IBOutlet UILabel *mile6;
}
-(NSArray *)getMothResults;
@end
@implementation MileMothController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    mothResults = [[[self getMothResults]objectAtIndex:0]objectForKey:@"monthdata"];
    moth1.text = [[mothResults objectAtIndex:0] objectForKey:@"monthdate"];
    moth2.text = [[mothResults objectAtIndex:1] objectForKey:@"monthdate"];
    moth3.text = [[mothResults objectAtIndex:2] objectForKey:@"monthdate"];
    moth4.text = [[mothResults objectAtIndex:3] objectForKey:@"monthdate"];
    moth5.text = [[mothResults objectAtIndex:4] objectForKey:@"monthdate"];
    moth6.text = [[mothResults objectAtIndex:5] objectForKey:@"monthdate"];

    mile1.text = [[mothResults objectAtIndex:0] objectForKey:@"monthmile"];
    mile2.text = [[mothResults objectAtIndex:1] objectForKey:@"monthmile"];
    mile3.text = [[mothResults objectAtIndex:2] objectForKey:@"monthmile"];
    mile4.text = [[mothResults objectAtIndex:3] objectForKey:@"monthmile"];
    mile5.text = [[mothResults objectAtIndex:4] objectForKey:@"monthmile"];
    mile6.text = [[mothResults objectAtIndex:5] objectForKey:@"monthmile"];
}
-(NSArray *)getMothResults{
    //获取当前时间作为里程查询结束时间
    NSDate *  senddate=[NSDate date];
    //获取（24*60*60）即24小时之前的时间
    NSDate *  startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  endt=[dateformatter stringFromDate:senddate];
    NSString * startt = [dateformatter stringFromDate:startdate];

    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];

    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    //第二步，创建post请求
    NSString *message =myDelegate.userid;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *type = [ud objectForKey:@"role"];
    NSString *usertype = nil;
    if ([type isEqualToString:@"person"]) {
        usertype = @"C";
    }else
        usertype = [NSString stringWithString:message];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSString *msgs = @"monthResults";
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"usertype=%@&msgs=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,msgs,startt,endt,username,pswd]; //设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
     NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received==nil) {
        return nil;
    }
    NSError *error;
    NSArray *resultJSON = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    return resultJSON;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"moth will apper");
}
@end
