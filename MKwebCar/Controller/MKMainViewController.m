//
//  MKMainViewController.m
//  MKwebCar
//
//  Created by moumouK on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKMainViewController.h"
#import "MKAppDelegate.h"
#import "Company.h"
#import "Department.h"
#import "CarInfo.h"
#define METHOD (@"LocationServlet")


#define ScreenW self.view.bounds.size.width
#define ScreenH self.view.bounds.size.height

@interface MKMainViewController()

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray *carsData;
@property (nonatomic, strong) NSMutableArray *Annotations;
@end

@implementation MKMainViewController
- (IBAction)doRefresh:(id)sender {
    [self viewUpdate];
}

- (NSMutableArray *)carsData{
    if (!_carsData) {
        _carsData = [NSMutableArray array];
    }
    return _carsData;
}
- (NSMutableArray *)Annotations{
    if (!_Annotations) {
        _Annotations = [NSMutableArray array];
    }
    return _Annotations;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *str = [defaults objectForKey:@"groupname"];
    self.navigationItem.title = [str isEqualToString:@""]?[defaults objectForKey:@"account"]:[defaults objectForKey:@"groupname"];

    //反geo检索，根据坐标转换成地址
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, ScreenW,ScreenH)];
    [self.view addSubview:_mapView];
    //获取车辆数据
    [self getcars];
    [self viewUpdate];
}

-(NSArray *) getLnglatWithMessage:(NSString *)message{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *username = [ud objectForKey:@"account"];
    NSString *pswd = [ud objectForKey:@"pwd"];
    NSString *str = [NSString stringWithFormat:@"usertype=%@&&username=%@&&password=%@",message,username,pswd]; //设置参数
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
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

#pragma -实时更新车辆位置信息
-(void) viewUpdate{
//    if (_Annotations !=nil) {
        [_mapView removeAnnotations:self.Annotations];
        [self.Annotations removeAllObjects];
//    }    
    for (int i=0; i<[_carsData count]; i++) {
        CarInfo *car = [[CarInfo alloc]init];
        car = [_carsData objectAtIndex:i];
        
        NSArray *lnglat = [[[self getLnglatWithMessage:car.carno]objectAtIndex:0] objectForKey:@"locationdata"];
        NSString *lat = [[lnglat objectAtIndex:0] objectForKey:@"gpslatitude"];
        NSString *lng = [[lnglat objectAtIndex:0] objectForKey:@"gpslongitude"];

        CLLocationCoordinate2D coor;
        coor.latitude = [lat floatValue];
        coor.longitude = [lng floatValue];
        
        NSDictionary *testdic = BMKConvertBaiduCoorFrom(coor,BMK_COORDTYPE_COMMON);
        CLLocationCoordinate2D coord = BMKCoorDictionaryDecode(testdic);
        
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        
        annotation.coordinate = coord;
        annotation.title = car.carno;
//        [_mapView addAnnotation:annotation];
        [self.Annotations addObject:annotation];
        
        //将百度地图视角切换到某一点，即以 coor 为中心的span范围内
        BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coord, BMKCoordinateSpanMake(0.025,0.025));
        BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
        [_mapView setRegion:adjustedRegion animated:YES];
    }
    [_mapView addAnnotations:self.Annotations];
}


- (void) viewDidAppear:(BOOL)animated {
    //定时器，定时刷新车辆位置信息
    _timer =  [NSTimer scheduledTimerWithTimeInterval:300.0 target:self selector:@selector(viewUpdate) userInfo:nil repeats:YES];
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    if (_timer!=nil) {
        [_timer invalidate];
        _timer = nil;
    }
    _mapView.delegate = nil; // 不用时，置nil
    
}

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

#pragma mark - Actions
- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}


#pragma mark- DataFormServerDelegate
-(void)getcars{
    DataFormServer *df = [[DataFormServer alloc]init];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *account = [ud objectForKey:@"account"];
    NSString *pwd = [ud objectForKey:@"pwd"];
    NSString *type = [ud objectForKey:@"role"];
    NSDictionary *p = @{@"usertype":@"M",@"username":account,@"password":pwd};
    NSString *method = @"CarListServlet";
    if ([type isEqualToString:@"ROLE_ADMIN"]) {
        method = @"BCarListServlet";
    }else if ([type isEqualToString:@"ROLE_SUPERADMIN"]){
        method = @"SCarListServlet";
    }
    [df getsDataFromServer:p methodName:method isReturnArry:YES];
    df.delegate = self;
}

-(void)getResultJson:(NSArray *)resultJson{
    [self.carsData removeAllObjects];
    
    _resultJSON = [[NSArray alloc]initWithArray:resultJson];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *type = [ud objectForKey:@"role"];
    
    NSArray *trackArry = [[_resultJSON objectAtIndex:0]objectForKey:@"carlist"];
    //解码并放入数组
    for (int i = 0;i<[trackArry count]; i++) {
        if([type isEqualToString:@"ROLE_ADMIN"]){
        }else{
            NSArray *departArry = [[trackArry objectAtIndex:i]objectForKey:@"deptlist"];
            for (int j = 0; j < departArry.count; j++) {
                NSArray *carsArray = [[departArry objectAtIndex:j]objectForKey:@"carlist"];
                for (int k=0; k<carsArray.count; k++) {
                    CarInfo *car = [[CarInfo alloc]init];
                    car.carno = [[carsArray objectAtIndex:k]objectForKey:@"carno"];
                    car.gpsstatus = [[carsArray objectAtIndex:k]objectForKey:@"gpsstatus"];
                    [self.carsData addObject:car];
                }
            }
        }
    }
}


@end
