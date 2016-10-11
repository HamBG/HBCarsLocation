//
//  MKChangePwdController.m
//  MKwebCar
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKChangePwdController.h"
#import "MKAppDelegate.h"
#import "Constants.h"
#define METHOD (@"ModifyPasswordServlet")

@interface MKChangePwdController()
@property (weak, nonatomic) IBOutlet UITextField *initialPwd;
@property (weak, nonatomic) IBOutlet UITextField *firstPwd;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwd;


@end

@implementation MKChangePwdController
- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

//修改密码按钮动作
- (IBAction)confirm:(id)sender {
    if (![_firstPwd.text isEqual:_confirmPwd.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"两次输入的密码不一致!" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        //        // optional - add more buttons:
        [alert addButtonWithTitle:@"Yes"];
        [alert show];
    }else{
        //第一步，创建URL
        //    NSURL *url = [NSURL URLWithString:@"http://192.168.1.92:8080/vehicletracking/ModifyPasswordServlet"];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KEY_SERVER_URL,METHOD]];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *username = [ud objectForKey:@"account"];
        NSString *pswd = [ud objectForKey:@"pwd"];
        NSString *type = [ud objectForKey:@"role"];
        NSString *usertype = nil;
        if ([type isEqualToString:@"person"]) {
            usertype = @"C";
        }else
            usertype = @"M";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        
        [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
        
        NSString *str = [NSString stringWithFormat:@"usertype=%@&prePassword=%@&newPassword=%@&username=%@&password=%@",usertype,_initialPwd.text,_firstPwd.text,username,pswd]; //设置参数
        
        NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPBody:data];
        
        //第三步，连接服务器
        
        
        
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        
        NSArray *returnData = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
        NSString *str1 = [[returnData objectAtIndex:0]objectForKey:@"status"];
        
        if ([str1 isEqual:@"修改密码成功"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"修改密码成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            //        // optional - add more buttons:
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:_firstPwd.text forKey:@"pswd"];
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
            
        }else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的密码！" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
            //        // optional - add more buttons:
            [alert addButtonWithTitle:@"Yes"];
            [alert show];
            
        }
        NSLog(@"%@",str1);
    }
}
- (void)viewDidLoad{
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg.png"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
}

- (IBAction)uidDidEndOnExit:(UITextField *)sender {
    [_firstPwd becomeFirstResponder];
}
- (IBAction)confirmPwdFirst:(UITextField *)sender {
    [_confirmPwd becomeFirstResponder];
}
-(IBAction)backgroundTap:(id)sender{
    [_firstPwd resignFirstResponder];
    [_confirmPwd resignFirstResponder];
    [_initialPwd resignFirstResponder];
    
}


@end
