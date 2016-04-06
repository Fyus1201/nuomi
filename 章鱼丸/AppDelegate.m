//
//  AppDelegate.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/4.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "AppDelegate.h"

#import "FYTabBarController.h"
#import "FYDataModel.h"
#import "FYData.h"
#import "iflyMSC/iflyMSC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //ViewController *one = [[ViewController alloc] init];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:one];//创建只包含itemsViewController的UINavigationController对象
    //navController.navigationBar.barTintColor = [UIColor colorWithRed:0.52 green:0.8 blue:0.93 alpha:0.9];

    [self initifly];
    
    self.window.rootViewController = [[FYTabBarController alloc]init];;
    self.window.backgroundColor = [UIColor whiteColor];
    

    [self.window makeKeyAndVisible];

    
    return YES;
}

- (void) initifly
{
    dispatch_async(dispatch_get_global_queue(0, 0)/*全局0,0*/, ^{
        //创建语音配置,appid必须要传入，仅执行一次则可
        NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"56ed4d02"];
        //所有服务启动前，需要确保执行createUtility
        [IFlySpeechUtility createUtility:initString];
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    item.searchTerm = @"";//本来是不应该放在这个单例里面，然而顺手放进去了,再弄个单例麻烦
    
    BOOL success = [[FYDataModel sharedStore] saveChanges];
    if (success)
    {
        NSLog(@"保存成功");
    }else
    {
        NSLog(@"保存失败");
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    
}



@end
