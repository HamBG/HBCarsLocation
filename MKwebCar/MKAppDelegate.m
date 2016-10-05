//
//  AppDelegate.m
//  MKwebCar
//
//  Created by moumouK on 16/8/22.
//  Copyright © 2016年 moyan. All rights reserved.
//

#import "MKAppDelegate.h"
#import "JVFloatingDrawerViewController.h"
#import "JVFloatingDrawerSpringAnimator.h"
#import "MKLoginViewController.h"

static NSString * const MKDrawersStoryboardName = @"MKwebCar";

static NSString * const MKLeftDrawerStoryboardID = @"MKLeftTableViewController";

static NSString * const MKGitHubProjectPageViewControllerStoryboardID = @"JVGitHubProjectPageViewControllerStoryboardID";
static NSString * const MKMainViewControllerStoryboardID = @"MKMainViewControllerStoryboardID";
static NSString * const MKCarListControllerStoryboardID = @"MKCarListControllerStoryboardID";
static NSString * const MKChangePwdControllerStoryboardID = @"MKChangePwdControllerStoryboardID";
static NSString * const MKAboutControllerStoryboardID = @"MKAboutControllerStoryboardID";

static NSString * const MKtabBarControllerStoryboardID = @"MKtabBarControllerStoryboardID";

@interface MKAppDelegate ()
@property (nonatomic, strong, readonly) UIStoryboard *MKwebCarStoryboard;
@end

@implementation MKAppDelegate
@synthesize MKwebCarStoryboard = _MKwebCarStoryboard;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    MKLoginViewController *login = [[MKLoginViewController alloc]init];
    self.window.rootViewController = login;
    [self configureDrawerViewController];
    
    _mapManager = [[BMKMapManager alloc]init];
    //     [_mapManager start:@"C45642BBD6852AEF5D3240C59F6C8CFE207AF843" generalDelegate:self];
    
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数 ZpYstiEsUalvUSInKPPQbOO4vw3q3Pf1
    BOOL ret = [_mapManager start:@"ZpYstiEsUalvUSInKPPQbOO4vw3q3Pf1"  generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

#pragma mark - Drawer View Controllers

- (JVFloatingDrawerViewController *)drawerViewController {
    if (!_drawerViewController) {
        _drawerViewController = [[JVFloatingDrawerViewController alloc] init];
    }
    
    return _drawerViewController;
}

#pragma mark Sides
- (UITableViewController *)leftDrawerViewController {
    if (!_leftDrawerViewController) {
        _leftDrawerViewController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKLeftDrawerStoryboardID];
    }
    
    return _leftDrawerViewController;
}

#pragma mark Center

- (UIViewController *)MKmainViewController {
    if (!_MKmainViewController) {
        _MKmainViewController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKMainViewControllerStoryboardID];
    }    
    return _MKmainViewController;
}

- (UIViewController *)MKCarListController{
    if (!_MKCarListController) {
        _MKCarListController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKCarListControllerStoryboardID];
    }
    return _MKCarListController;
}

- (UIViewController *)MKChangePwdController{
    if (!_MKChangePwdController) {
        _MKChangePwdController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKChangePwdControllerStoryboardID];
    }
    return  _MKChangePwdController;
}

- (UIViewController *)MKAboutViewController{
    if (!_MKAboutViewController) {
        _MKAboutViewController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKAboutControllerStoryboardID];
    }
    return _MKAboutViewController;
}

- (UITabBarController *)MKTabBarController{
    if (!_MKTabBarController) {
        _MKTabBarController = [self.MKwebCarStoryboard instantiateViewControllerWithIdentifier:MKtabBarControllerStoryboardID];
    }
    return _MKTabBarController;
}

#pragma mark drawerAnimator
- (JVFloatingDrawerSpringAnimator *)drawerAnimator {
    if (!_drawerAnimator) {
        _drawerAnimator = [[JVFloatingDrawerSpringAnimator alloc] init];
    }
    //动画设置
    _drawerAnimator.animationDelay = 0;
    _drawerAnimator.animationDuration = 0.3;
    _drawerAnimator.initialSpringVelocity = 9.0;
    _drawerAnimator.springDamping = 2.5;
    
    return _drawerAnimator;
}

- (UIStoryboard *)MKwebCarStoryboard {
    if(!_MKwebCarStoryboard) {
        _MKwebCarStoryboard = [UIStoryboard storyboardWithName:MKDrawersStoryboardName bundle:nil];
    }
    
    return _MKwebCarStoryboard;
}

- (void)configureDrawerViewController {
    self.drawerViewController.leftViewController = self.leftDrawerViewController;
    self.drawerViewController.centerViewController = self.MKmainViewController;
    
    self.drawerViewController.animator = self.drawerAnimator;
    self.drawerViewController.backgroundImage = [UIImage imageNamed:@"tabBar_bg"];
}

#pragma mark - Global Access Helper
+ (MKAppDelegate *)globalDelegate {
    return (MKAppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)toggleLeftDrawer:(id)sender animated:(BOOL)animated {
    [self.drawerViewController toggleDrawerWithSide:JVFloatingDrawerSideLeft animated:animated completion:nil];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "io.moyan.MKwebCar" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MKwebCar" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MKwebCar.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - BMK delegate
- (void)onGetNetworkState:(int)iError
{
    NSLog(@"地图联网失败代号：%d",iError);
}
- (void)onGetPermissionState:(int)iError
{
    if (iError==0) {
        NSLog(@"授权成功！");
    }else
        NSLog(@"授权失败！");
}

@end
