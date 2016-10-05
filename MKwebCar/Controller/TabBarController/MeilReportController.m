//
//  MeilReportController.m
//  MYF1
//
//  Created by wisdom on 14-9-17.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "MeilReportController.h"
#import "MKAppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "Constants.h"
#define METHOD (@"MileReportServlet")
@interface MeilReportController(){
    NSDictionary *dayResults;
    IBOutlet UIDatePicker *datePicker;
    
}
@property (nonatomic,retain) UIDatePicker *datePicker;
- (NSArray *)getDayResults;
@property (weak, nonatomic) IBOutlet UITextField *textstr;
@property (weak, nonatomic) IBOutlet UITextField *textend;
@property (nonatomic,retain)NSDictionary *dayResults;
@end
@implementation MeilReportController
@synthesize datePicker;

@synthesize chepai;
@synthesize mile;
@synthesize dayResults;
@synthesize starttime;
@synthesize endtime;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKAppDelegate *myDelegate = (MKAppDelegate *)[[UIApplication sharedApplication]delegate];
    chepai.text = myDelegate.userid;
    dayResults = [[self getDayResults]objectAtIndex:0];
    if (dayResults!=nil) {
    mile.text = [dayResults objectForKey:@"miles"];
    }
    _textstr.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    _textend.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    NSDate *  senddate=[NSDate date];
//    获取（24*60*60）即24小时之前的时间
    NSDate *  startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];

    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *  endt=[dateformatter stringFromDate:senddate];
    NSString * startt = [dateformatter stringFromDate:startdate];
    _textend.text = endt;
    _textstr.text = startt;


}
//时间选择器赋值给开始时间
-(void) dateChanged:(id)sender{
    NSLog(@"coming");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _textstr.text = [dateFormatter stringFromDate:datePicker.date];
    //text失去焦点
    [_textstr resignFirstResponder];

}
//点击开始时间文本框弹出时间选择器，选择器时间改变，则文本框内容改变
- (IBAction)timeselect:(UITextField *)sender {
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];

    NSDate *btime = [dateFormatter dateFromString:_textstr.text];

    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setDate:btime animated:false];

    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:(UIControlEventValueChanged)];
    alertView.tag = 0;
    [alertView setContainerView:datePicker];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];

    [alertView show];
    }
//Override
- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button Clicked! %d, %d", (int)buttonIndex, (int)[alertView tag]);
    [alertView close];
}

-(void) enddateChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _textend.text = [dateFormatter stringFromDate:datePicker.date];
    [_textend resignFirstResponder];

}
- (IBAction)endtimeselect:(UITextField *)sender {
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *stime = [dateFormatter dateFromString:_textend.text];

    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setDate:stime animated:false];
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
    [datePicker addTarget:self action:@selector(enddateChanged:) forControlEvents:(UIControlEventValueChanged)];
    alertView.tag = 0;
    [alertView setContainerView:datePicker];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];
    

    [alertView show];
    
}

//自定义里程查询post
- (NSArray *)getMiledetail{
    starttime.text = _textstr.text;
    endtime.text = _textend.text;
    NSLog(@"the data now is :%@",_textstr);
    //第一步，创建URL
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
    }else
        usertype = [NSString stringWithString:message];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSString *msgs = @"resultMiles";
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"usertype=%@&msgs=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,msgs,_textstr.text,_textend.text,username,pswd]; //设置参数
    NSLog(@"sends is %@",str);

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


#pragma -获取单日里程数
- (NSArray *)getDayResults{
    //获取当前时间作为里程查询结束时间
    NSDate *  senddate=[NSDate date];
    //获取（24*60*60）即24小时之前的时间
    NSDate *  startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *  endt=[dateformatter stringFromDate:senddate];
    NSString * startt = [dateformatter stringFromDate:startdate];
    starttime.text = startt;
    endtime.text = endt;
    
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];
    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    //第二步，创建post请求
    NSString *message =myDelegate.userid;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *type = [ud objectForKey:@"type"];
    NSString *usertype = nil;
    
    if ([type isEqualToString:@"gly"]) {
        usertype = [NSString stringWithString:message];
    }else usertype = @"C";
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSString *msgs = @"resultMiles";
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"usertype=%@&msgs=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,msgs,startt,endt,username,pswd]; //设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    NSLog(@"send is %@",str);
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (received==nil) {
        return nil;
    }
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",str1);
    NSError *error;
    NSArray *resultJSON = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    return resultJSON;
}
- (IBAction)sercheMIles:(UIButton *)sender {
    NSDictionary *mileDetail = [[self getMiledetail]objectAtIndex:0];
    mile.text = [mileDetail objectForKey:@"miles"];
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"mile will appear");
}
- (IBAction)doBackBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
