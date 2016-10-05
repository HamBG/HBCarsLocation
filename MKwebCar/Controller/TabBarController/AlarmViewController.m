//
//  AlarmViewController.m
//  MYF1
//
//  Created by wisdom on 14-10-21.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "AlarmViewController.h"
#import "MKAppDelegate.h"
#import "CustomIOS7AlertView.h"
#import "Constants.h"
#define METHOD (@"AlarmServlet")

#define SCREENW self.view.bounds.size.width
#define SCREENH self.view.bounds.size.height

@interface AlarmViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *chepai;
@property (weak, nonatomic) IBOutlet UITextField *startFeild;
@property (weak, nonatomic) IBOutlet UITextField *endFeild;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) NSArray *resultJSON;


@end

@implementation AlarmViewController
@synthesize datePicker;
@synthesize resultJSON;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKAppDelegate *myDelegate = (MKAppDelegate *)[[UIApplication sharedApplication]delegate];
    _chepai.text = myDelegate.userid;
    _startFeild.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    _endFeild.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    NSDate *senddate=[NSDate date];
    
    //获取（24*60*60）即24小时之前的时间
    NSDate *startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endt=[dateformatter stringFromDate:senddate];
    NSString *startt = [dateformatter stringFromDate:startdate];
    _endFeild.text = endt;
    _startFeild.text = startt;
    
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator= YES;
}

#pragma -获取告警记录数据

//时间选择器赋值给开始时间
-(void) dateChanged:(id)sender{
    NSLog(@"coming");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    _startFeild.text = [dateFormatter stringFromDate:datePicker.date];
    //text失去焦点
    [_startFeild resignFirstResponder];
}
//点击开始时间文本框弹出时间选择器，选择器时间改变，则文本框内容改变
- (IBAction)timeselect:(UITextField *)sender {
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *btime = [dateFormatter dateFromString:_startFeild.text];
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
    _endFeild.text = [dateFormatter stringFromDate:datePicker.date];
    [_endFeild resignFirstResponder];
    
}
- (IBAction)endtimeselect:(UITextField *)sender {
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *stime = [dateFormatter dateFromString:_endFeild.text];
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

-(IBAction)getAlarmDate:(id)sender{
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];
    //第二步，创建post请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    MKAppDelegate *myDelegate = (MKAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *message = myDelegate.userid;
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *usertype = [NSString stringWithString:message];

    NSString *str = [NSString stringWithFormat:@"usertype=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,_startFeild.text,_endFeild.text,username,pswd]; //设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSError *error;
    
    NSArray *returnData = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    resultJSON = [[returnData objectAtIndex:0]objectForKey:@"alarmdata"];
    
    float y = 30;
    UILabel *alarmStart = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 30)];
    alarmStart.textAlignment = NSTextAlignmentLeft;
    alarmStart.textColor = [UIColor grayColor];
    alarmStart.font = [UIFont fontWithName:@"Helvetica" size:15];
    alarmStart.text = @"-查询结果-";
    
    for (int i = 0; i<[self.scrollView.subviews count]; i++) {
        [[self.scrollView.subviews objectAtIndex:i] removeFromSuperview];
    }
    
    [self.scrollView addSubview:alarmStart];
    
    for (int i = 0; i<[resultJSON count]; i++) {
        UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(10, y, SCREENW-30, 30)];
        start.font = [UIFont fontWithName:@"Helvetica" size:13];
        NSString *stext = [[resultJSON objectAtIndex:i]objectForKey:@"beginTime"];
        NSString *etext = [[resultJSON objectAtIndex:i]objectForKey:@"endTime"];
        start.textAlignment = NSTextAlignmentLeft;
        start.textColor = [UIColor grayColor];
        start.text = [NSString stringWithFormat:@"-告警记录-beginTime:%@--endTime:%@",stext,etext];
        [self.scrollView addSubview:start];
        y+=31;
    }
    // 设置内容大小
    self.scrollView.contentSize = CGSizeMake(320, [resultJSON count]*31+30);
//    self.scrollView.subviews objectAtIndex:i 
}

- (IBAction)doBackBtnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
