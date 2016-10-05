//
//  MeilReportController.h
//  MYF1
//
//  Created by wisdom on 14-9-17.
//  Copyright (c) 2014年 MY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeilReportController : UIViewController<UIAlertViewDelegate,UIActionSheetDelegate>
{
    
    __weak IBOutlet UILabel *mile;
    __weak IBOutlet UILabel *chepai;
    __weak IBOutlet UILabel *starttime;
    __weak IBOutlet UILabel *endtime;
}
@property (weak, nonatomic) IBOutlet UILabel *chepai;
@property (weak, nonatomic) IBOutlet UILabel *starttime;
@property (weak, nonatomic) IBOutlet UILabel *endtime;
@property (weak, nonatomic) IBOutlet UILabel *mile;

@end

//    NSURL *url = [NSURL URLWithString:@"http://192.168.1.92:8080/vehicletracking/MileReportServlet"];