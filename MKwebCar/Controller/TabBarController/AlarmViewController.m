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
//#import "AlertDatePikerController.h"
#import "Constants.h"
#define METHOD (@"AlarmServlet")
@interface AlarmViewController ()
@property(nonatomic,retain) UIView *uiview;
@property(nonatomic,retain) UIView *contentView;
@property(nonatomic,retain) UILabel *starTime;
@property(nonatomic,retain) UILabel *endTime;
@property(nonatomic,retain) UIButton *playBut;
@property (nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain)    UIScrollView *textView;
@property(nonatomic,retain) NSArray *resultJSON;
@property(nonatomic,retain) UIColor *textColor;


@end

@implementation AlarmViewController
@synthesize uiview;
@synthesize starTime;
@synthesize endTime;
@synthesize playBut;
@synthesize datePicker;
@synthesize textView;
@synthesize resultJSON;
@synthesize contentView;
@synthesize textColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"dfdf");
    CGRect rect = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    uiview = [[UIView alloc]initWithFrame:rect];
    //    uiview.backgroundColor = [UIColor grayColor];
    starTime = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 119, 40)];
    //    starTime.text = @"Start Time ";
    starTime.textAlignment = NSTextAlignmentCenter;
    //    starTime.backgroundColor = [UIColor greenColor];
    //    starTime.shadowColor = [UIColor greenColor];
    //给起始时间label添加点击事件
    //    AlertDatePikerController *date1 = [[AlertDatePikerController alloc]init];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeselect:)];
    tapGr.cancelsTouchesInView = NO;
    [starTime addGestureRecognizer:tapGr];
    
    endTime = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 119, 40)];
    //    endTime.text = @"End Time ";
    endTime.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *tapGr1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endtimeselect:)];
    tapGr1.cancelsTouchesInView = NO;
    [endTime addGestureRecognizer:tapGr1];
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBut.frame = CGRectMake(240, 0, 40, 40);
    UIImage *searchImg = [UIImage imageNamed:@"22.png"];
    [searchBut setBackgroundImage:searchImg forState:UIControlStateNormal];
    starTime.userInteractionEnabled = YES;//一定要设 否则点击无反应
    endTime.userInteractionEnabled = YES;
    searchBut.showsTouchWhenHighlighted = YES;
    [searchBut addTarget:self action:@selector(getAlarmDate:) forControlEvents:UIControlEventTouchUpInside];
    //    [playBut setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
     textView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, self.view.bounds.size.height)];

    UILabel *alarmStart = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 120, 30)];
    alarmStart.textAlignment = NSTextAlignmentCenter;
    alarmStart.backgroundColor = [UIColor lightGrayColor];
    UILabel *alarmEnd = [[UILabel alloc]initWithFrame:CGRectMake(161, 0, 120, 30)];
    alarmEnd.textAlignment = NSTextAlignmentCenter;
    alarmEnd.backgroundColor = [UIColor lightGrayColor];
    alarmStart.text = @"告警开始";
    alarmEnd.text = @"告警结束";
    textView.contentSize = contentView.frame.size;
    [contentView addSubview:alarmStart];
    [contentView addSubview:alarmEnd];
    [textView addSubview:contentView];
    [uiview addSubview:textView];
    [uiview addSubview:starTime];
    [uiview addSubview:endTime];
    [uiview addSubview:searchBut];
    [self.view addSubview:uiview];
    
    NSDate *  senddate=[NSDate date];
    //获取（24*60*60）即24小时之前的时间
    NSDate *  startdate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    //指定转换的格式
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *  endt=[dateformatter stringFromDate:senddate];
    NSString * startt = [dateformatter stringFromDate:startdate];
    starTime.text = startt;
    endTime.text = endt;
    NSLog(@"the data now is :%@",endt);
    
    // Do any additional setup after loading the view.
}
#pragma -获取告警记录数据

-(IBAction)getAlarmDate:(id)sender{
    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.92:8080/WebCarApp/AlarmServlet"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];

    //第二步，创建post请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    
    MKAppDelegate *myDelegate = (MKAppDelegate *)[[UIApplication sharedApplication]delegate];
    NSString *message = myDelegate.userid;
    NSLog(@"carno is %@",message);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"userId"];
    NSString *pswd = [ud objectForKey:@"pswd"];
    NSString *type = [ud objectForKey:@"role"];
    NSString *usertype = nil;
    if ([type isEqualToString:@"person"]) {
        usertype = @"C";
    }else
        usertype = [NSString stringWithString:message];

    NSString *str = [NSString stringWithFormat:@"usertype=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,starTime.text,endTime.text,username,pswd]; //设置参数
    NSLog(@"str is %@",str);
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    if (received==nil) {
        return;
    }
    NSLog(@"str1:%@",str1);
    
    NSError *error;
    
    NSArray *returnData = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    resultJSON = [[returnData objectAtIndex:0]objectForKey:@"alarmdata"];
    float x = 40;
    float y = 31;
    [contentView removeFromSuperview];
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,31*([resultJSON count]+7))];
    UILabel *alarmStart = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 120, 30)];
    alarmStart.textAlignment = NSTextAlignmentCenter;
    alarmStart.backgroundColor = [UIColor lightGrayColor];
    UILabel *alarmEnd = [[UILabel alloc]initWithFrame:CGRectMake(161, 0, 120, 30)];
    alarmEnd.textAlignment = NSTextAlignmentCenter;
    alarmEnd.backgroundColor = [UIColor lightGrayColor];
    alarmStart.text = @"告警开始";
    alarmEnd.text = @"告警结束";
    [contentView addSubview:alarmStart];
    [contentView addSubview:alarmEnd];
    for (int i = 0; i<[resultJSON count]; i++) {
        
        UILabel *start = [[UILabel alloc]initWithFrame:CGRectMake(x, y, 120, 30)];
        start.font = [UIFont fontWithName:@"Helvetica" size:12];
        
        start.text = [[resultJSON objectAtIndex:i]objectForKey:@"beginTime"];
        start.textAlignment = NSTextAlignmentCenter;
        start.backgroundColor = [UIColor lightGrayColor];
        UILabel *end = [[UILabel alloc]initWithFrame:CGRectMake(x+121, y, 120, 30)];
        end.text = [[resultJSON objectAtIndex:i]objectForKey:@"endTime"];
        end.textAlignment = NSTextAlignmentCenter;
        end.backgroundColor = [UIColor lightGrayColor];
        end.font = [UIFont fontWithName:@"Helvetica" size:12];

        [contentView addSubview:start];
        [contentView addSubview:end];
        y+=31;
    }
    
    textView.contentSize = contentView.frame.size;
    [textView addSubview:contentView];

    NSLog(@"the count of carList data:%d",[resultJSON count]);
    
}


//点击开始时间文本框弹出时间选择器，选择器时间改变，则文本框内容改变
- (IBAction)timeselect:(UILabel *)sender {
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    NSLog(@"%@",sender.text);
    NSDate *btime = [dateFormatter dateFromString:starTime.text];
    
    datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setMaximumDate:[NSDate date]];
    [datePicker setDate:btime animated:false];
    
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc]init];
    [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:(UIControlEventValueChanged)];
    alertView.tag = 0;
    [alertView setContainerView:datePicker];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",nil]];
    //    [alertView setDelegate:self];
    [alertView show];
}
//点击开始时间文本框弹出时间选择器，选择器时间改变，则文本框内容改变
- (IBAction)endtimeselect:(UITextField *)sender {
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 320, 216)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *stime = [dateFormatter dateFromString:endTime.text];
    
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
//时间选择器赋值给开始时间
-(void) dateChanged:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    starTime.text = [dateFormatter stringFromDate:datePicker.date];
    //text失去焦点
    //    [starTime resignFirstResponder];
    
}

-(void) enddateChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    endTime.text = [dateFormatter stringFromDate:datePicker.date];
    //    [endTime resignFirstResponder];
    
}


@end
