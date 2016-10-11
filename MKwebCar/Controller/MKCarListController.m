//
//  MKCarListController.m
//  MKwebCar
//
//  Created by Apple on 16/8/29.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKCarListController.h"
#import "MKAppDelegate.h"
#import "Company.h"
#import "Department.h"
#import "CarInfo.h"
#import "MKBaseNavigationController.h"
#import "MKBaseTabBarController.h"
#import "SSColorfulRefresh.h"

static NSString *TestViewControllerNode = @"TestViewControllerNode";
#define DegreesToRadians(degrees) (degrees * M_PI / 180)

@interface MKCarListController()
@property (nonatomic, strong) NSMutableArray *subNodes;
@property (nonatomic, strong) SSColorfulRefresh *colorRefresh;
@property (nonatomic, strong) NSMutableArray *companys;
@property (nonatomic, strong) NSMutableArray *departments;
@end

@implementation MKCarListController
- (NSMutableArray *)companys{
    if (!_companys) {
        _companys = [NSMutableArray array];
    }
    return _companys;
}
- (NSMutableArray *)departments{
    if (!_departments) {
        _departments = [NSMutableArray array];
    }
    return _departments;
}
- (void) doConfigTreeView {
    self.treeView.rootNode = [MTreeNode initWithParent:nil expand:NO];
    //设置禁止自动适应尺寸
    self.automaticallyAdjustsScrollViewInsets = NO;
    //添加刷新控件
    self.colorRefresh = [[SSColorfulRefresh alloc]initWithScrollView:self.treeView colors:nil];
    [self.colorRefresh addTarget:self action:@selector(refreshAction:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshAction:self.colorRefresh];
}

- (void)refreshAction:(SSColorfulRefresh *)refresh {
    [self.colorRefresh beginRefreshing];
    //加载数据
    [self getcar];
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    MTreeNode *subNode = [[self.treeView.rootNode subNodes] objectAtIndex:section];
    NSDictionary *nodeData = subNode.content;
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 50)];
    {
        sectionView.tag = 1000 + section;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionTaped:)];
        [sectionView addGestureRecognizer:recognizer];
        sectionView.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:166.0/255.0 blue:217.0/255.0 alpha:0.8];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.5)];
        line.backgroundColor = [UIColor clearColor];
        line.alpha = 0.5f;
        [sectionView addSubview:line];
    }
    {
        UIImageView *tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17, 20, 10, 12)];
        tipImageView.image = [UIImage imageNamed:@"tip"];
        tipImageView.tag = 10;
        [sectionView addSubview:tipImageView];
        [self doTipImageView:tipImageView expand:subNode.expand];
    }
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 10, 200, 30)];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textColor = [UIColor whiteColor];
        label.tag = 20;
        label.text = nodeData[@"name"];
        [sectionView addSubview:label];
    }
    {
        UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.view.bounds) - 100, 10, 90, 30)];
        numberLabel.font = [UIFont systemFontOfSize:15.0f];
        numberLabel.textColor = [UIColor whiteColor];
        numberLabel.textAlignment = NSTextAlignmentRight;
        numberLabel.tag = 30;
        numberLabel.text = [NSString stringWithFormat:@"%@/%@",nodeData[@"onNum"],nodeData[@"status"]];
        [sectionView addSubview:numberLabel];
    }
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.0 ;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.bounds), 0.3f)];
    footerView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:indexPath];
    NSDictionary *nodeData = subNode.content;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TestViewControllerNode];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TestViewControllerNode];
    }
    cell.separatorInset = UIEdgeInsetsMake(0, subNode.depth * 20.0f, 0, 0);
    if ([nodeData[@"status"] integerValue]!= 3){
        
        cell.textLabel.textColor = [UIColor colorWithRed:25.0/255.0 green:166.0/255.0 blue:217.0/255.0 alpha:1];
    }else{
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.text = nodeData[@"name"];
    if ([nodeData[@"status"] integerValue]== 1) {
        cell.detailTextLabel.textColor= [UIColor redColor];
        cell.detailTextLabel.text = @"静止";
    }else if ([nodeData[@"status"] integerValue]== 2){
        cell.detailTextLabel.textColor= [UIColor lightGrayColor];
        cell.detailTextLabel.text = @"离线";
    }else if([nodeData[@"status"] integerValue]== 0){
        cell.detailTextLabel.textColor= [UIColor colorWithRed:35.0/255.0 green:208.0/255.0 blue:165.0/255.0 alpha:1];
        cell.detailTextLabel.text = @"行驶";
    }else{
        cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell.detailTextLabel.text isEqualToString:@""]) {
        //在这里跳转
        MKAppDelegate *myDelegate = (MKAppDelegate*)[[UIApplication sharedApplication ]delegate];
        myDelegate.userid = cell.textLabel.text;
        NSString *userid =myDelegate.userid;
        NSString *message = [[NSString alloc]initWithString:[NSString stringWithFormat:@"确定查看%@吗？",userid]];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
        alert.delegate = self;
        [alert addButtonWithTitle:@"确定"];
        [alert show];
        return;
    }else{
        //点击后插入或移除数据
        [self.treeView expandNodeAtIndexPath:indexPath];
    }
    
}

#pragma mark AlertView delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex!=0) {
        UIStoryboard *MKwebCarStoryboard = [UIStoryboard storyboardWithName:@"MKwebCar" bundle:nil];
        MKBaseTabBarController *MKTabBarController = [MKwebCarStoryboard instantiateViewControllerWithIdentifier:@"MKtabBarControllerStoryboardID"];
        [self presentViewController:MKTabBarController animated:YES completion:nil];
    }
}

#pragma mark MTreeView delegate

- (void) treeView:(MTreeView *)treeView willexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"willexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}

- (void) treeView:(MTreeView *)treeView didexpandNodeAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didexpandNodeAtIndexPath = [%@, %@]", @(indexPath.section), @(indexPath.row));
}


#pragma mark --
#pragma mark Action

- (void) doTipImageView:(UIImageView *)imageView expand:(BOOL) expand {
    [UIView animateWithDuration:0.2f animations:^{
        imageView.transform = (expand) ? CGAffineTransformMakeRotation(DegreesToRadians(90)) : CGAffineTransformIdentity;
    }];
}

- (void)sectionTaped:(UIGestureRecognizer *) recognizer {
    UIView *view = recognizer.view;
    NSUInteger tag = view.tag - 1000;
    UIImageView *tipImageView = [view viewWithTag:10];
    MTreeNode *subNode = [self.treeView nodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    [self.treeView expandNodeAtIndexPath:[NSIndexPath indexPathForRow:-1 inSection:tag]];
    [self doTipImageView:tipImageView expand:subNode.expand];
}


- (IBAction)actionToggleLeftDrawer:(id)sender {
    [[MKAppDelegate globalDelegate] toggleLeftDrawer:self animated:YES];
}

#pragma mark- DataFormServerDelegate
-(void)getcar{
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
      
    _resultJSON = [[NSArray alloc]initWithArray:resultJson];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *type = [ud objectForKey:@"role"];
    
    NSArray *trackArry = [[_resultJSON objectAtIndex:0]objectForKey:@"carlist"];
//    NSMutableArray *companys = [[NSMutableArray alloc]init];
//    NSMutableArray *deaprtments = [[NSMutableArray alloc]init];
    [self.companys removeAllObjects];
    [self.departments removeAllObjects];
    
    //解码并放入数组
    for (int i = 0;i<[trackArry count]; i++) {
        
        if([type isEqualToString:@"ROLE_ADMIN"]){//此时只有部门2层
            Department *depart = [[Department alloc]init];
            depart.name = [[trackArry objectAtIndex:i]objectForKey:@"groupname"];
            NSArray *carsArray = [[trackArry objectAtIndex:i]objectForKey:@"carlist"];
            depart.cars = [[NSMutableArray alloc]init];
            for (int k=0; k<carsArray.count; k++) {
                CarInfo *car = [[CarInfo alloc]init];
                car.carno = [[carsArray objectAtIndex:k]objectForKey:@"carno"];
                car.gpsstatus = [[carsArray objectAtIndex:k]objectForKey:@"gpsstatus"];
                [depart.cars insertObject:car atIndex:k];
            }
            [self.departments insertObject:depart atIndex:i];
            [self loadDepartments];
            
            
        }else{//此时只有公司3层
            Company *company = [[Company alloc]init];
            company.name = [[trackArry objectAtIndex:i]objectForKey:@"branchname"];
            NSArray *departArry = [[trackArry objectAtIndex:i]objectForKey:@"deptlist"];
            company.departments = [[NSMutableArray alloc]init];
            for (int j = 0; j < departArry.count; j++) {
                Department *depart = [[Department alloc]init];
                depart.name = [[departArry objectAtIndex:j]objectForKey:@"deptname"];
                NSArray *carsArray = [[departArry objectAtIndex:j]objectForKey:@"carlist"];
                depart.cars = [[NSMutableArray alloc]init];
                for (int k=0; k<carsArray.count; k++) {
                    CarInfo *car = [[CarInfo alloc]init];
                    car.carno = [[carsArray objectAtIndex:k]objectForKey:@"carno"];
                    car.gpsstatus = [[carsArray objectAtIndex:k]objectForKey:@"gpsstatus"];
                    [depart.cars insertObject:car atIndex:k];
                }
                [company.departments insertObject:depart atIndex:j];
            }
            [self.companys insertObject:company atIndex:i];
            [self lodeCompanys];
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //停止刷新
        [self.colorRefresh endRefreshing];
    });
}

-(void)lodeCompanys{
    [self.treeView.rootNode.subNodes removeAllObjects];
    
    //加载数据
    for (int i = 0; i < [self.companys count]; i++) {
        MTreeNode *company = [MTreeNode initWithParent:self.treeView.rootNode expand:(0 == i)];
        Company *com = self.companys[i];
        int num=0;
        int onnum = 0;
        for (int j = 0; j<[com.departments count];j++) {
            MTreeNode *departNode = [MTreeNode initWithParent:company expand:NO];
            Department *dep = com.departments[j];
            departNode.content = @{@"name":dep.name,@"status":@(3)};
            for (int k=0; k<[dep.cars count]; k++) {
                MTreeNode *carNode = [MTreeNode initWithParent:departNode expand:NO];
                CarInfo *car = dep.cars[k];
                carNode.content = @{@"name":car.carno,@"status":car.gpsstatus};
                [departNode.subNodes addObject:carNode];
                num++;
                if ([car.gpsstatus intValue] != 2) {
                    onnum++;
                }
            }
            [company.subNodes addObject:departNode];
        }
        company.content = @{@"name":com.name,@"status":@(num),@"onNum":@(onnum)};
        
        [self.treeView.rootNode.subNodes addObject:company];
    }
    [self.treeView reloadData];
}

-(void)loadDepartments{
    [self.treeView.rootNode.subNodes removeAllObjects];
    //加载数据
    for (int i = 0; i<[self.departments count]; i++) {
        MTreeNode *depart = [MTreeNode initWithParent:self.treeView.rootNode  expand:(0 == i)];
        Department *dp = self.departments[i];
        int num=0;
        int onnum = 0;

        for (int j=0; j<[dp.cars count]; j++) {
            MTreeNode *carNode = [MTreeNode initWithParent:depart expand:NO];
            CarInfo *car = dp.cars[j];
            carNode.content = @{@"name":car.carno,@"status":car.gpsstatus};
            [depart.subNodes addObject:carNode];
            num++;
            if ([car.gpsstatus intValue] != 2) {
                onnum++;
            }

        }
        depart.content = @{@"name":dp.name,@"status":@(num),@"onNum":@(onnum)};
        [self.treeView.rootNode.subNodes addObject:depart];
    }
    [self.treeView reloadData];
}
@end
