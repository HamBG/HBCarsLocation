//
//  TimeLocationViewController.m
//  MYF1
//
//  Created by wisdom on 14-9-11.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import "TimeLocationViewController.h"
#import "Constants.h"
#define METHOD (@"LocationServlet")
#define ScreenW self.view.bounds.size.width
#define ScreenH self.view.bounds.size.height


int showTag = 1;
@interface TimeLocationViewController ()
{
    BMKMapView* mapView;
    NSTimer *timer;
    BMKPointAnnotation* annotations;
    UILabel *locationInfo;
    BMKGeoCodeSearch *_searcher;
    UILabel *statusLabel;
    
}
- (NSArray *) getLnglat;
- (void) viewUpdate;
@property (nonatomic,retain)BMKMapView* mapView;
@property (nonatomic,retain)BMKPointAnnotation *annotations;
@property (nonatomic,retain)NSTimer *timer;
@property (nonatomic,retain)UIView *uiview;
@property (nonatomic,retain)UILabel *locationInfo;
@property (nonatomic,retain)BMKGeoCodeSearch *searcher;
@property (nonatomic,retain)UILabel *statusLabel;
@property (nonatomic,retain) UIButton *showInfo;
@property (nonatomic,retain)UIView *topInfoView;

@end

@implementation TimeLocationViewController
@synthesize mapView;
@synthesize annotations;
@synthesize timer;
@synthesize uiview;
@synthesize locationInfo;
@synthesize searcher;
@synthesize statusLabel;
@synthesize showInfo;
@synthesize topInfoView;

- (IBAction)doback:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)refreshBtnDidClick:(id)sender {
    [self viewUpdate];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
 {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    //反geo检索，根据坐标转换成地址
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH)];
    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    self.navigationItem.title = myDelegate.userid;

    locationInfo = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, ScreenW*0.8, 20)];
    locationInfo.textColor =  [UIColor whiteColor];
    locationInfo.textAlignment = NSTextAlignmentLeft;
    locationInfo.font = [UIFont boldSystemFontOfSize:14.0f];
    locationInfo.text = @"地址：正在获取...";
    
    statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenW*0.8, 10, ScreenW*0.2, 20)];
    statusLabel.textColor = [UIColor whiteColor];
    statusLabel.textAlignment = NSTextAlignmentLeft;
    statusLabel.font = [UIFont boldSystemFontOfSize:14.0f];
    
    topInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
    topInfoView.backgroundColor = [UIColor colorWithRed:172.0/255.0 green:172.0/255.0 blue:172.0/255.0 alpha:0.55f];
    
    [topInfoView addSubview:statusLabel];
    [topInfoView addSubview:locationInfo];
    [self.view addSubview:mapView];
    [self.view addSubview:topInfoView];
    
    [self viewUpdate];

}

-(NSArray *) getLnglat{
    MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
    //第二步，创建请求
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

    NSString *str = [NSString stringWithFormat:@"usertype=%@&&username=%@&&password=%@",usertype,username,pswd]; //设置参数
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    NSLog(@"%@",message);
    
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (received==nil) {
        return nil;
    }
    
    NSString *str1 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSLog(@"str is %@",str1);
    NSError *error;
    NSArray *resultJSON = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:&error];
    
    return resultJSON;
}

#pragma -实时更新车辆位置信息
-(void) viewUpdate{
    NSArray *lnglat = [[[self getLnglat]objectAtIndex:0] objectForKey:@"locationdata"];
    // 初始化标注 添加一个PointAnnotation 清空标注
    if (annotations==nil) {
        annotations = [[BMKPointAnnotation alloc]init];
    }else [mapView removeAnnotation:annotations];
    NSString *lat = [[lnglat objectAtIndex:0] objectForKey:@"gpslatitude"];
    NSString *lng = [[lnglat objectAtIndex:0] objectForKey:@"gpslongitude"];
    if ([lat isEqualToString:@""]||[lng isEqualToString:@""]) {
        statusLabel.text = @"状态：暂无数据";
        locationInfo.text = @"地址：暂无数据";
        return;
    }
    int sNo = [[[lnglat objectAtIndex:0] objectForKey:@"gpsstatus"]intValue];
    
    if (sNo==0) {
        statusLabel.text = @"状态:运行";
    }else if(sNo == 1){
        statusLabel.text = @"状态:静止";
    }else if(sNo == 2){
        statusLabel.text = @"状态:离线";
    }else{
        statusLabel.text = @"状态:失联";

    }

    CLLocationCoordinate2D coor;
    coor.latitude = [lat floatValue];
    coor.longitude = [lng floatValue];
    
    //gps->bd
    NSDictionary *testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
    CLLocationCoordinate2D coord = BMKCoorDictionaryDecode(testdic);
    
    //反geo检索，根据坐标转换成地址
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = coord;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }

    annotations.coordinate = coord;
    annotations.title = statusLabel.text;
    annotations.subtitle = locationInfo.text;

    [mapView addAnnotation:annotations];
    //将百度地图视角切换到某一点，即以 coor 为中心的span范围内
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coord, BMKCoordinateSpanMake(0.005,0.005));
    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
}
- (void) viewDidAppear:(BOOL)animated {
    //定时器，定时刷新车辆位置信息
    timer =  [NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(viewUpdate) userInfo:nil repeats:YES];
    //开启定时器
    [timer setFireDate:[NSDate distantPast]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    NSLog(@"map will disappear");
    //退出时关闭定时器

    [mapView viewWillDisappear];
    if (timer!=nil) {
        [timer invalidate];
        timer = nil;
    }
    mapView.delegate = nil; // 不用时，置nil
    _searcher.delegate = nil;//不用时，置nil

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Override 对标注一些外观等属性的设置
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.image = [UIImage imageNamed:@"car"];
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:
(BMKReverseGeoCodeResult *)result
errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      locationInfo.text = [NSString stringWithFormat:@"地址：%@",[result address]];
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}


@end
