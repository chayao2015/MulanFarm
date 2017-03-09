//
//  AppDelegate.m
//  MulanFarm
//
//  Created by zyl on 17/3/9.
//  Copyright © 2017年 cydf. All rights reserved.
//

#import "AppDelegate.h"
#import "FarmVC.h"
#import "RecordVC.h"
#import "GuideVC.h"
#import "MineVC.h"
#import <IQKeyboardManager.h>
#import "NetworkUtil.h"
#import "AEFilePath.h"
#import "UserInfo.h"
#import "BaseNC.h"

@interface AppDelegate ()
{
    UITabBarController *myTabBarController;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //键盘事件处理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = PageColor;
    
    [[UserInfo share] getUserInfo];
    [AEFilePath createDirPath];
    [[NetworkUtil sharedInstance] listening]; //监测网络
    
    self.window.rootViewController = [self setTabBarController];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - 主页
- (UITabBarController *)setTabBarController {
    
    //步骤1：初始化视图控制器
    FarmVC *farmVC = [[FarmVC alloc] init]; //农场
    RecordVC *recordVC = [[RecordVC alloc] init]; //档案
    GuideVC *guideVC = [[GuideVC alloc] init]; //指南
    MineVC *mineVC = [[MineVC alloc] init]; //我的
    
    //步骤2：将视图控制器绑定到导航控制器上
    BaseNC *nav1C = [[BaseNC alloc] initWithRootViewController:farmVC];
    BaseNC *nav2C = [[BaseNC alloc] initWithRootViewController:recordVC];
    BaseNC *nav3C = [[BaseNC alloc] initWithRootViewController:guideVC];
    BaseNC *nav4C = [[BaseNC alloc] initWithRootViewController:mineVC];
    
    //步骤3：将导航控制器绑定到TabBar控制器上
    myTabBarController = [[UITabBarController alloc] init];
    
    //改变tabBar的背景颜色
    UIView *barBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 49)];
    barBgView.backgroundColor = [UIColor whiteColor];
    [myTabBarController.tabBar insertSubview:barBgView atIndex:0];
    myTabBarController.tabBar.opaque = YES;
    
    myTabBarController.viewControllers = @[nav1C,nav2C,nav3C,nav4C]; //需要先绑定viewControllers数据源
    myTabBarController.selectedIndex = 0; //默认选中第几个图标（此步操作在绑定viewControllers数据源之后）
    
    //初始化TabBar数据源
    NSArray *titles = @[@"农场",@"档案",@"指南",@"我的"];
    NSArray *images = @[@"UnTabbarLoveLife",@"UnTabbarFineGoods",@"UnTabbarFind",@"UnTabbarMine"];
    NSArray *selectedImages = @[@"TabbarLoveLife",@"TabbarFineGoods",@"TabbarFind",@"TabbarMine"];
    
    //绑定TabBar数据源
    for (int i = 0; i<myTabBarController.tabBar.items.count; i++) {
        UITabBarItem *item = (UITabBarItem *)myTabBarController.tabBar.items[i];
        item.title = titles[i];
        item.image = [[UIImage imageNamed:[images objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.selectedImage = [[UIImage imageNamed:[selectedImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item.imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:AppThemeColor,NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:10.5]} forState:UIControlStateNormal];
    
    return myTabBarController;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
