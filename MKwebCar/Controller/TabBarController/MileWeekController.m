//
//  MileWeekController.m
//  MYF1
//
//  Created by wisdom on 14-9-17.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "MileWeekController.h"
#import "MKAppDelegate.h"
#import "Constants.h"
#define METHOD (@"MileReportServlet")

@interface MileWeekController(){
    NSArray *_weekResults;//从服务器获取的周报数据

    __weak IBOutlet UILabel *day1;
    __weak IBOutlet UILabel *day2;
    __weak IBOutlet UILabel *day3;
    __weak IBOutlet UILabel *day4;
    __weak IBOutlet UILabel *day5;
    __weak IBOutlet UILabel *day6;
    __weak IBOutlet UILabel *day7;
    
    __weak IBOutlet UILabel *mile1;
    __weak IBOutlet UILabel *mile2;
    __weak IBOutlet UILabel *mile3;
    __weak IBOutlet UILabel *mile4;
    __weak IBOutlet UILabel *mile5;
    __weak IBOutlet UILabel *mile6;
    __weak IBOutlet UILabel *mile7;
}

@property (nonatomic,retain)NSArray *weekResults;
@end

@implementation MileWeekController
@synthesize weekResults = _weekResults;
-(void)viewDidLoad{
    [super viewDidLoad];
    
    _weekResults = [[[self getWeekResults]objectAtIndex:0]objectForKey:@"weekdata"];
    day1.text = [[_weekResults objectAtIndex:0]objectForKey:@"weekdate"];
    day2.text = [[_weekResults objectAtIndex:1]objectForKey:@"weekdate"];
    day3.text = [[_weekResults objectAtIndex:2]objectForKey:@"weekdate"];
    day4.text = [[_weekResults objectAtIndex:3]objectForKey:@"weekdate"];
    day5.text = [[_weekResults objectAtIndex:4]objectForKey:@"weekdate"];
    day6.text = [[_weekResults objectAtIndex:5]objectForKey:@"weekdate"];
    day7.text = [[_weekResults objectAtIndex:6]objectForKey:@"weekdate"];
    
    mile1.text = [[_weekResults objectAtIndex:0]objectForKey:@"weekmile"];
    mile2.text = [[_weekResults objectAtIndex:1]objectForKey:@"weekmile"];
    mile3.text = [[_weekResults objectAtIndex:2]objectForKey:@"weekmile"];
    mile4.text = [[_weekResults objectAtIndex:3]objectForKey:@"weekmile"];
    mile5.text = [[_weekResults objectAtIndex:4]objectForKey:@"weekmile"];
    mile6.text = [[_weekResults objectAtIndex:5]objectForKey:@"weekmile"];
    mile7.text = [[_weekResults objectAtIndex:6]objectForKey:@"weekmile"];
}

-(NSArray *)getWeekResults{
    NSDate *  senddate=[NSDate date];
    //获取（24*60*60）即24小时之前的时间
    NSDate *  startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  endt=[dateformatter stringFromDate:senddate];
    NSString * startt = [dateformatter stringFromDate:startdate];
    
    
    
    NSLog(@"the data now is :%@",endt);
    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.92:8080/vehicletracking/MileReportServlet"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];

    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    //第二步，创建post请求
    NSString *message =myDelegate.userid;
    
    NSLog(@"carno is %@",message);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *type = [ud objectForKey:@"role"];
    NSString *usertype = nil;
    if ([type isEqualToString:@"person"]) {
        usertype = @"C";

    }else     usertype = [NSString stringWithString:message];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSString *msgs = @"weekResults";
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"usertype=%@&msgs=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,msgs,startt,endt,username,pswd]; //设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    if (received==nil) {
        return nil;
    }
    
    NSLog(@"%@",str1);
    NSError *error;
    
    NSArray *resultJSON = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    return resultJSON;

}

@end
