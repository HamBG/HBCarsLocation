//
//  MKLoginViewController.m
//  自定义登录界面
//
//  Created by moumouK on 16/8/10.
//  Copyright © 2016年 My. All rights reserved.
//

#import "MKLoginViewController.h"
#import "MKTextField.h"
#import "MKButton.h"
#import "MKAppDelegate.h"

#define MKAccount @"account"
#define MKPwd @"pwd"
#define MKRemPwd @"remPwd"
#define MKAutoLogin @"autoLogin"

#define SCREENHIGHT [UIScreen mainScreen].bounds.size.height
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width

@interface MKLoginViewController ()
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) MKTextField *username;
@property (nonatomic, strong) MKTextField *password;
@property (nonatomic, strong) UISwitch *remPwdSwitch;
@property (nonatomic, strong) UISwitch *autoLoginSwitch;
@end

@implementation MKLoginViewController

-(instancetype)init{
    if(self = [super init]){
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //1.2 键盘处理
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyBoard:)];
    [self.view addGestureRecognizer:tap];
    [self.view.layer addSublayer: [self backgroundLayer]];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self setUp];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [self textFieldChange];
}

-(void)setUp{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 40)];
    imageview.center = CGPointMake(self.view.center.x, SCREENHIGHT*0.22);
    imageview.image = [UIImage imageNamed:@"logo_moyan"];
    [self.view addSubview:imageview];
    
    MKTextField *username = [[MKTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    username.center = CGPointMake(self.view.center.x, SCREENHIGHT*0.45);
    username.placeholderNormalStateColor = [UIColor lightGrayColor];
    username.placeholderSelectStateColor = [UIColor lightGrayColor];
    username.tag = 0;
    // 设置账号
    username.textField.text = [defaults objectForKey:MKAccount];
    if (username.textField.text.length != 0) {
        username.ly_placeholder = @"";
    }else{
        username.ly_placeholder = @"登录名";
    }
    self.username = username;
    [self.view addSubview:self.username];
    
    MKTextField *password = [[MKTextField alloc]initWithFrame:CGRectMake(0, 0, 270, 30)];
    password.center = CGPointMake(self.view.center.x, username.center.y+60);
    password.placeholderNormalStateColor = [UIColor lightGrayColor];
    password.placeholderSelectStateColor = [UIColor lightGrayColor];
    password.tag = 1;
    self.password = password;
    self.password.textField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.password.textField.secureTextEntry = YES;
    [self.view addSubview:self.password];
    
    UISwitch *remPwdSwitch = [[UISwitch alloc]init];
    remPwdSwitch.onTintColor = [UIColor whiteColor];
    remPwdSwitch.center = CGPointMake(password.frame.origin.x+20, password.center.y+60);
    
    self.remPwdSwitch = remPwdSwitch;
    // 判断是否需要记住密码
    [self.remPwdSwitch setOn:[defaults boolForKey:MKRemPwd] animated:YES];
    if (self.remPwdSwitch.isOn) {
        self.password.textField.text = [defaults objectForKey:MKPwd];
        if (self.password.textField.text.length != 0) {
            self.password.ly_placeholder = @"";
        }else{
            self.password.ly_placeholder = @"密码";
        }
    }

    [self.remPwdSwitch addTarget:self action:@selector(remPwdChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.remPwdSwitch];
    
    UILabel *remLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(remPwdSwitch.frame)+5, remPwdSwitch.center.y-10, 60, 20)];
    remLabel.textColor = [UIColor whiteColor];
    remLabel.text = @"记住密码";
    remLabel.font = [UIFont systemFontOfSize:14.f];
    remLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:remLabel];
    
    UISwitch *autoLoginSwitch = [[UISwitch alloc]init];
    autoLoginSwitch.onTintColor = [UIColor whiteColor];
    autoLoginSwitch.center = CGPointMake(password.center.x+20, password.center.y+60);
    self.autoLoginSwitch = autoLoginSwitch;
    
    [self.autoLoginSwitch setOn:[defaults boolForKey:MKAutoLogin] animated:YES];
    if (self.autoLoginSwitch.isOn) {
        // 自动登录相当于调用登录方法
        DataFormServer *df = [[DataFormServer alloc]init];
        NSDictionary *p = @{@"usertype":@"M",@"username":_username.textField.text,@"password":_password.textField.text};
        [df getsDataFromServer:p methodName:@"LoginServlet" isReturnArry:YES];
        df.delegate = self;
    }

    [self.autoLoginSwitch addTarget:self action:@selector(autoLoginChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.autoLoginSwitch];
    
    UILabel *autoLoginLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(autoLoginSwitch.frame)+5, autoLoginSwitch.center.y-10, 60, 20)];
    autoLoginLabel.textColor = [UIColor whiteColor];
    autoLoginLabel.text = @"自动登录";
    autoLoginLabel.font = [UIFont systemFontOfSize:14.f];
    autoLoginLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:autoLoginLabel];
    
    MKButton *login = [[MKButton alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    login.center = CGPointMake(self.view.center.x, SCREENHIGHT*0.85);
    [self.view addSubview:login];
    
    UIButton *detail = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 30)];
    detail.center = CGPointMake(self.view.center.x,login.center.y +50);
    [detail setTitle:@"忘记账号或密码? 请联系我们" forState:UIControlStateNormal];
    detail.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [detail addTarget:self action:@selector(detaiBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:detail];

    __weak typeof(self) weakSelf = self;
    //按钮点击回调方法
    login.translateBlock = ^{
        if (_password.textField.text != nil && _username.textField.text !=nil) {
            DataFormServer *df = [[DataFormServer alloc]init];
            NSDictionary *p = @{@"usertype":@"M",@"username":_username.textField.text,@"password":_password.textField.text};
            [df getsDataFromServer:p methodName:@"LoginServlet" isReturnArry:YES];
            df.delegate = weakSelf;
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码不能为空" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
            [alert show];
        }
    };
}

- (void)autoLoginChange:(id)sender {
    if (self.autoLoginSwitch.isOn) {
        //如果自动登录就记住密码
        [self.remPwdSwitch setOn:YES animated:YES];
    }
}

/**
 *  判断是否记住密码
 */
- (void)remPwdChange:(id)sender {
    if (self.remPwdSwitch.isOn == NO) {
        //不记住密码就取消自动登录
        [self.autoLoginSwitch setOn:NO animated:YES];
    }
}


- (void)detaiBtnDidClick:(id)sender{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel://0571-86901299"]]];
}

- (void)textFieldChange{
    __weak typeof(self) weakSelf = self;
    weakSelf.password.textFieldChangeCallBack = ^(NSString *str){
        _password.textField.text = str;
    };
    
    weakSelf.username.textFieldChangeCallBack = ^(NSString *str){
        _username.textField.text = str;
    };
}

//影藏键盘
-(void)hideKeyBoard:(id)sender{
    [self.username.textField resignFirstResponder];
    [self.password.textField resignFirstResponder];
}


-(CAGradientLayer *)backgroundLayer{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
//    gradientLayer.colors = @[(__bridge id)[UIColor purpleColor].CGColor,(__bridge id)[UIColor redColor].CGColor];
//    gradientLayer.startPoint = CGPointMake(0.5, 0);
//    gradientLayer.endPoint = CGPointMake(0.5, 1);
//    gradientLayer.locations = @[@0.75,@1];
    gradientLayer.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]].CGColor;
    return gradientLayer;
}

- (void)getResultJson:(NSArray *)resultJson{
    NSString *mess = [[resultJson objectAtIndex:0]objectForKey:@"mess"];
    NSString *groupname = [[resultJson objectAtIndex:0]objectForKey:@"groupname"];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:groupname forKey:MKAccount];
    
    if ([mess isEqualToString:@"登录失败"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"用户名或密码错误" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确认", nil];
        [alert show];
    }else
    {
        [userDefaults setObject:_username.textField.text forKey:MKAccount];
        [userDefaults setObject:_password.textField.text forKey:MKPwd];
        [userDefaults setBool:self.remPwdSwitch.isOn forKey:MKRemPwd];
        [userDefaults setBool:self.autoLoginSwitch.isOn forKey:MKAutoLogin];
        
        NSString *status = [[resultJson objectAtIndex:0]objectForKey:@"status"];
        if ([status isEqualToString:@"个人登录"]) {
            [userDefaults setObject:@"person" forKey:@"role"];
        }else
        {
            NSString *role = [[resultJson objectAtIndex:0]objectForKey:@"role"];
            [userDefaults setObject:role forKey:@"role"];
        }
        //跳转到baseBar
//        UIWindow *currentWindow = [[UIApplication sharedApplication].delegate window];
//        currentWindow.rootViewController = (UIViewController *)[[MKAppDelegate globalDelegate] drawerViewController];
        
        [self presentViewController:(UIViewController *)[[MKAppDelegate globalDelegate] drawerViewController] animated:YES completion:nil];
    }
}

@end
