//
//  TrackController.m
//  MYF1
//
//  Created by wisdom on 14-9-24.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "TrackController.h"
#import "MKAppDelegate.h"
#import "CustomIOS7AlertView.h"
//#import "AlertDatePikerController.h"
#import "Constants.h"

#define ScreenW self.view.bounds.size.width
#define ScreenH self.view.bounds.size.height
#define METHOD (@"ShowTrackServlet")

@interface TrackController(){
    BMKMapView *mapView;
    UILabel *startTime;
    UILabel *endTime;
    UIView *uiview;
    NSArray *resultJSON;
    BMKPointAnnotation *annotations;
    NSTimer *timer;
    BMKPolyline* polyline;
    UIButton *playBut;
    UIImage *baseRed;

}
@property (nonatomic,retain) UIDatePicker *datePicker;
@property(nonatomic,retain) BMKMapView  *mapView;
@property(nonatomic,retain) UILabel *starTime;
@property(nonatomic,retain) UILabel *endTime;
@property(nonatomic,retain) UIView *uiview;
@property(nonatomic,retain) NSArray *resultJSON;
@property(nonatomic,retain) BMKPointAnnotation *annotations;
@property(nonatomic,retain) NSTimer *timer;
@property(nonatomic,retain) BMKPolyline* polyline;
@property(nonatomic,retain)UIButton *playBut;
@property(nonatomic,retain) UIImage *baseRed;

@end
@implementation TrackController
@synthesize playBut;
@synthesize baseRed;
int tag = 0;
int aindex = 0;
@synthesize  polyline;
@synthesize resultJSON;
@synthesize mapView;
@synthesize starTime;
@synthesize endTime;
@synthesize datePicker;
@synthesize uiview;
@synthesize  annotations;
@synthesize timer;

- (IBAction)doback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    CGRect rect = CGRectMake(0, 0, ScreenW, ScreenH);
    
    uiview = [[UIView alloc]initWithFrame:rect];
    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    self.navigationItem.title = myDelegate.userid;
    
    starTime = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenW*0.3, 20)];;
    starTime.textAlignment = NSTextAlignmentCenter;
    starTime.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(timeselect:)];
    tapGr.cancelsTouchesInView = NO;
    [starTime addGestureRecognizer:tapGr];
   
    endTime = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW*0.35, 10, ScreenW*0.3, 20)];
    endTime.textAlignment = NSTextAlignmentCenter;
    endTime.textColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGr1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endtimeselect:)];
    tapGr1.cancelsTouchesInView = NO;
    [endTime addGestureRecognizer:tapGr1];
    
    UIButton *searchBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    searchBut.frame = CGRectMake(ScreenW*0.7, 0, 40, 40);
    [searchBut setTitle:@"查询" forState:UIControlStateNormal];
    [searchBut setTitleColor:[UIColor colorWithRed:17/255.0 green:94/255.0 blue:180/255.0 alpha:1.0f] forState:UIControlStateNormal];
    starTime.userInteractionEnabled = YES;//一定要设 否则点击无反应
    endTime.userInteractionEnabled = YES;
    searchBut.showsTouchWhenHighlighted = YES;
    [searchBut addTarget:self action:@selector(getTrackData:) forControlEvents:UIControlEventTouchUpInside];
    
    playBut = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    playBut.frame = CGRectMake(ScreenW*0.85, 5, 30, 30);
    baseRed = [UIImage imageNamed:@"16.png"];
    [playBut setBackgroundImage:baseRed forState:UIControlStateNormal];
    [playBut addTarget:self action:@selector(playTrack) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    topInfoView.backgroundColor = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:0.55f];
    [uiview addSubview:mapView];
    [topInfoView addSubview:starTime];
    [topInfoView addSubview:playBut];
    [topInfoView addSubview:endTime];
    [topInfoView addSubview:searchBut];
    [uiview addSubview:topInfoView];
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
}
//时间选择器赋值给开始时间
-(void) dateChanged:(id)sender{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    starTime.text = [dateFormatter stringFromDate:datePicker.date];
    //text失去焦点
//    [starTime resignFirstResponder];
    
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

-(void) enddateChanged:(id)sender{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    endTime.text = [dateFormatter stringFromDate:datePicker.date];
//    [endTime resignFirstResponder];
    
}
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
-(void)showTrack{



}

-(IBAction)getTrackData:(id)sender{
 
    
    NSLog(@"the count of track data:%lu",(unsigned long)[resultJSON count]);
    //第一步，创建URL
//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.92:8080/vehicletracking/ShowTrackServlet"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];

    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    //第二步，创建post请求
    NSString *message =myDelegate.userid;
    NSLog(@"carno is %@",message);
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *type = [ud objectForKey:@"role"];
    NSString *usertype =   [NSString stringWithString:message];;
//    if ([type isEqualToString:@"ROLE_USER"]) {
//        usertype = [NSString stringWithString:message];
//    }else usertype = @"C";

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"usertype=%@&beginTime=%@&endTime=%@&username=%@&password=%@",usertype,starTime.text,endTime.text,username,pswd]; //设置参数
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received==nil) {
        return;
    }
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSError *error;

    NSArray *returnData = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    resultJSON = [[returnData objectAtIndex:0]objectForKey:@"trackdata"];
    NSLog(@"str1:%@",str1);
    str1 = [[returnData objectAtIndex:0]objectForKey:@"status"];
    if ([str1 isEqualToString:@"该时间段内无轨迹记录"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该时间段内无轨迹记录！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }
    else if ([str1 isEqualToString:@"该时间段内轨迹记录过多"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"历史记录过多，请减少查询时间间隔！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        // optional - add more buttons:
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }else{
#pragma 初始化参数
        if (annotations!=nil) {
            [mapView removeAnnotation:annotations];
        }
        aindex = 0;
        if (timer!=nil) {
            [timer setFireDate:[NSDate distantFuture]];
        }
        baseRed = [UIImage imageNamed:@"16.png"];
        [playBut setBackgroundImage:baseRed forState:UIControlStateNormal];
        if (polyline!=nil) {
            [mapView removeOverlay:polyline];
        }
        NSLog(@"the count of track data:%lu",(unsigned long)[resultJSON count]);

        int trackSize = [resultJSON count];
        
        CLLocationCoordinate2D coors[700] = {0};
        CLLocationCoordinate2D coor;
        //解码并放入数组
        for (int i = 0;i<trackSize; i++) {
            coor.latitude = [[[resultJSON objectAtIndex:i]objectForKey:@"gpslatitude"]doubleValue];
            coor.longitude = [[[resultJSON objectAtIndex:i]objectForKey:@"gpslongitude"]doubleValue];
            coors[i]=BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS));
        }
        BMKPointAnnotation *startAnnotation = [[BMKPointAnnotation alloc]init];
        BMKPointAnnotation *endAnnotation = [[BMKPointAnnotation alloc]init];
        startAnnotation.coordinate = coors[0];
        endAnnotation.coordinate = coors[trackSize-1];
        [startAnnotation setTitle:@"startLocation"];
        [endAnnotation setTitle:@"endLocation"];
//        startAnnotation.
        polyline = [BMKPolyline polylineWithCoordinates:coors count:trackSize];
        [mapView addAnnotation:startAnnotation];
        [mapView addAnnotation:endAnnotation];
        [mapView addOverlay:polyline];
//        //将百度地图视角切换到某一点，即以 coor 为中心的span范围内，暂不考虑经纬度转码问题
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coors[0], BMKCoordinateSpanMake(0.05,0.05));
        
        BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
        [mapView setRegion:adjustedRegion animated:YES];
    }
    NSLog(@"searching");
    
}

#pragma the button click to play the track
-(void)playTrack{
    if (aindex<[resultJSON count]) {
    if (tag == 0) {
        //定时器，定时刷新车辆位置信息
        timer =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showAnimate) userInfo:nil repeats:YES];
        //开启定时器
        [timer setFireDate:[NSDate distantPast]];
        baseRed = [UIImage imageNamed:@"19.png"];
        [playBut setBackgroundImage:baseRed forState:UIControlStateNormal];

        tag = 1;
    }else if (tag == 1) {
        baseRed = [UIImage imageNamed:@"16.png"];
        [timer setFireDate:[NSDate distantFuture]];
        tag = 0;
        [playBut setBackgroundImage:baseRed forState:UIControlStateNormal];
    }
    }
}


#pragma update annotation
-(void)showAnimate{
    if (aindex <[resultJSON count]) {
            // 初始化标注 添加一个PointAnnotation 清空标注
    if (annotations==nil) {
        annotations = [[BMKPointAnnotation alloc]init];
        [annotations setTitle:@"当前位置"];
    }else [mapView removeAnnotation:annotations];
    NSString *lat = [[resultJSON objectAtIndex:aindex]objectForKey:@"gpslatitude"];
    NSString *lng = [[resultJSON objectAtIndex:aindex]objectForKey:@"gpslongitude"];
    CLLocationCoordinate2D coor;
    coor.latitude = [lat doubleValue];
    coor.longitude = [lng doubleValue];
//        NSLog(@"lat:%flng:%f",coor.latitude,coor.longitude);
        //gps－》bd
    CLLocationCoordinate2D coord = BMKCoorDictionaryDecode(BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_GPS));

    annotations.coordinate = coord;
    //    mapView.center = CGPointMake(38.915,116.404);
    annotations.title = @"车辆在这里";
    //跳往下一个点
    aindex++;
    [mapView addAnnotation:annotations];
    //将百度地图视角切换到某一点，即以 coor 为中心的span范围内，暂不考虑经纬度转码问题
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coord, BMKCoordinateSpanMake(0.05,0.05));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
        }else {
        NSLog(@"ending of tracking");
        [timer setFireDate:[NSDate distantFuture]];
        tag = 0;
        aindex = 0;
        baseRed = [UIImage imageNamed:@"car.png"];
        [playBut setBackgroundImage:baseRed forState:UIControlStateNormal];
    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}
-(void)viewWillDisappear:(BOOL)animated
{
    [timer setFireDate:[NSDate distantFuture]];

    [mapView viewWillDisappear];
    if (timer != nil) {
        [timer invalidate];
        timer = nil;
    }
    mapView.delegate = nil; // 不用时，置nil
}
//Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    NSLog(@"overview");
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 2.0;
        
        return polylineView;
    }
    return nil;
}
// Override 对标注一些外观等属性的设置
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"startAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
//        newAnnotationView.image = [UIImage imageNamed:@"icon_nav_start.png"];   //把大头针换成别的图片
        if ([[annotation title] isEqualToString:@"startLocation"]) {
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_start.png"];
        }
        else if([[annotation title]isEqualToString:@"endLocation"]){
            newAnnotationView.image = [UIImage imageNamed:@"icon_nav_end.png"];
            
        }else{
            newAnnotationView.image = [UIImage imageNamed:@"car"];

        }
        newAnnotationView.centerOffset = CGPointMake(0, -(newAnnotationView.frame.size.height * 0.5));
        return newAnnotationView;
    }
    return nil;
}
@end
