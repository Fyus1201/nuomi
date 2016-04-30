//
//  AppDelegate.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/4.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "AppDelegate.h"

#import "FYHomeViewController.h"
#import "FYXuanViewController.h"
#import "FYJingViewController.h"
#import "FYMeViewController.h"

#import "FYWebViewController.h"

#import "FYDataModel.h"
#import "FYData.h"
#import "iflyMSC/iflyMSC.h"
#import "MobClick.h"

#import "FYSaoViewController.h"
#import "FYSearchViewController.h"
#import "FYDengluViewController.h"

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (nonatomic) NSURLSession *session;

@end

@implementation AppDelegate


- (void)applicationDidFinishLaunching:(UIApplication *)app
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"启动时间 是 %f sec", CFAbsoluteTimeGetCurrent());//启动时间
    });
    // ...
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    [self initTabbarItem];
    
    //ViewController *one = [[ViewController alloc] init];
    //UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:one];//创建只包含itemsViewController的UINavigationController对象
    //navController.navigationBar.barTintColor = [UIColor colorWithRed:0.52 green:0.8 blue:0.93 alpha:0.9];
    
    [self initifly];
    [self init3DTouchActionShow:YES];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    [self initAdvView];
    [[UIApplication sharedApplication].delegate applicationDidFinishLaunching:application] ;
    return YES;
}


- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //NSLog(@"%@", [url absoluteString]);
    
    // 在 host 等于 tuan 时，说明一个宝贝详情的 url，
    // 那么就使用本地的 ViewController 来显示
    if ([[url host] isEqualToString:@"tuan"])
    {
        NSString *urlStr = @"http://t10.nuomi.com/webapp/na/topten?from=fr_na_t10tab&sizeLimit=8&version=2&needstorecard=1&areaId=100010000&location=39.989430,116.324470&bn_aid=ios&bn_v=5.13.0&bn_chn=com_dot_apple";
        NSURL *url = [NSURL URLWithString: urlStr];
        FYWebViewController *web0 = [[FYWebViewController alloc]init];
        [web0 setURL:url];
        web0.name = @"精选抢购";
        web0.LED = YES;
        web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
        [self.window.rootViewController.childViewControllers[0] pushViewController:web0 animated:YES];//1.点击，相应跳转
    }
    return YES;
}

 - (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void(^)(BOOL succeeded))completionHandler
{
    //NSLog(@"选择了3Dtouch功能--%@-%@",shortcutItem.type,self.window.rootViewController.childViewControllers[0]);

    if ([shortcutItem.type isEqualToString:@"zero"])
     {
         [self.rootTabbarCtr setSelectedIndex:1];
         
     }else if ([shortcutItem.type isEqualToString:@"one"])
     {
         
         FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
         
         denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
         [self.window.rootViewController.childViewControllers[0] pushViewController:denglu animated:YES];//1.点击，相应跳转
         
     }else if ([shortcutItem.type isEqualToString:@"two"])
     {

         FYSaoViewController *sao = [[FYSaoViewController alloc]init];
         
         sao.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
         [self.window.rootViewController.childViewControllers[0] pushViewController:sao animated:YES];//1.点击，相应跳转
     }else if ([shortcutItem.type isEqualToString:@"three"])
     {
         FYSearchViewController *search = [[FYSearchViewController alloc]init];
         search.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
         [self.window.rootViewController.childViewControllers[0] pushViewController:search animated:YES];//1.点击，相应跳转
     }
    

}
-(void)init3DTouchActionShow:(BOOL)isShow
{
    
    /** type 该item 唯一标识符
     localizedTitle ：标题
     localizedSubtitle：副标题
     icon：icon图标 可以使用系统类型 也可以使用自定义的图片
     userInfo：用户信息字典 自定义参数，完成具体功能需求
     */
    UIApplication *application = [UIApplication sharedApplication];
    
    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mine_shoucang@3x"];
    //icon1.accessibilityFrame = CGRectMake(0, 0, 40, 40);
    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"zero" localizedTitle:@"章鱼丸" localizedSubtitle:nil icon:icon1 userInfo:nil];
    
    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mine_nuomiquan@3x"];
    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"one" localizedTitle:@"糯米券" localizedSubtitle:nil icon:icon2 userInfo:nil];
    
    UIApplicationShortcutIcon *icon3 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mine_card@3x"];
    UIApplicationShortcutItem *item3 = [[UIApplicationShortcutItem alloc]initWithType:@"two" localizedTitle:@"扫一扫" localizedSubtitle:nil icon:icon3 userInfo:nil];
    
    UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithTemplateImageName:@"mine_setting@3x"];
    //UIApplicationShortcutIcon *icon4 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *item4 = [[UIApplicationShortcutItem alloc]initWithType:@"three" localizedTitle:@"搜索" localizedSubtitle:nil icon:icon4 userInfo:nil];
    if (isShow)
    {
        application.shortcutItems = @[item4,item3,item2,item1];
    }else
    {
        application.shortcutItems = @[];
    }
}

- (void) initifly
{
    dispatch_async(dispatch_get_global_queue(0, 0)/*全局0,0*/, ^{
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"56ed4d02"];
    [MobClick startWithAppkey:@"571a0a8de0f55a471a001314" reportPolicy:BATCH   channelId:@"GitHub"];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];
    });
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self.rootTabbarCtr setSelectedIndex:0];
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

#pragma mark - 加载图片广告
-(void)initAdvView
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];
    //NSLog(@"filePath:  %@",filePath);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isExit = [fileManager fileExistsAtPath:filePath isDirectory:&isDir];
    
    if (isExit)
    {
        NSLog(@"存在");
        _advImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        [_advImage setImage:[UIImage imageWithContentsOfFile:filePath]];
        [self.window addSubview:_advImage];
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //加载启动广告并保存到本地沙盒，因为保存的图片较大，每次运行都要保存，所以注掉了
            [self getLoadingImage];
        });
    }else
    {
        NSLog(@"不存在");
        /*
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=9; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
            [refreshingImages addObject:image];
        }
        _advImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-70, 200, 120)];
        _advImage.animationImages = refreshingImages;
        [self.window addSubview:_advImage];
        
        //设置执行一次完整动画的时长
        _advImage.animationDuration = 9*0.15;
        //动画重复次数 （0为重复播放）
        _advImage.animationRepeatCount = 1.5;
        [_advImage startAnimating];
        
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:2];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getLoadingImage];
         });*/
    }
}

-(void)getLoadingImage
{
    
    NSString *urlStr = @"http://app.nuomi.com/naserver/item/splashpage?appid=ios&bduss=&channel=com_dot_apple&cityid=100010000&cuid=11a2e62839f7bed05437dcb826be61a0c47a515c&device=iPhone&ha=5&lbsidfa=ACAF9226-F987-417B-A708-C95D482A732D&location=39.989360%2C116.324490&logpage=Home&net=unknown&os=8.2&sheight=1334&sign=40c974d176568886ad0e72516645e23f&swidth=750&terminal_type=ios&timestamp=1442906717563&tn=ios&uuid=11a2e62839f7bed05437dcb826be61a0c47a515c&v=5.13.0";
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    //[request addValue: @"2a3e3ab9a95e410b8981b180f54605af" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@"加载 启动页广告 失败");
                                                  
                                              });
                                          } else {
                                              
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              NSDictionary *dic = [jsonObject objectForKey:@"data"];
                                              
                                              //NSLog(@"图片   %@",dic);
                                              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                                  if (dic) {
                                                      NSString *picUrl = [dic objectForKey:@"pic_url"];
                                                      if ([picUrl isEqualToString:@""]) {
                                                          NSLog(@"pic_url:%@",picUrl);
                                                      }else{
                                                          NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:picUrl]];
                                                          UIImage *image = [UIImage imageWithData:data];
                                                          
                                                          NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
                                                          
                                                          NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"loading.png"]];   // 保存文件的名称
                                                          //    BOOL result = [UIImagePNGRepresentation() writeToFile: filePath    atomically:YES]; // 保存成功会返回YES
                                                          [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                                      }
                                                  }
                                              });
                                              
                                              
                                          }
                                      }];
    [dataTask resume];
}


-(void)removeAdvImage
{
    NSLog(@"removeAdvImage");
    [UIView animateWithDuration:0.3f animations:^{
        _advImage.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _advImage.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_advImage removeFromSuperview];
    }];
}

-(void)initTabbarItem
{
    self.rootTabbarCtr  = [[UITabBarController alloc] init];
    self.rootTabbarCtr.delegate = self;
    
    FYHomeViewController *home0 = [[FYHomeViewController alloc]init];
    [self controller:home0 title:@"首页" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    FYJingViewController *jing = [[FYJingViewController alloc]init];
    [self controller:jing title:@"附近" image:@"icon_tab_fujin_normal" selectedimage:@"icon_tab_fujin_highlight"];
    
    FYXuanViewController *yuan = [[FYXuanViewController alloc]init];
    [self controller:yuan title:@"精选" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    FYMeViewController *my = [[FYMeViewController alloc]init];
    [self controller:my title:@"我的" image:@"icon_tab_wode_normal" selectedimage:@"icon_tab_wode_highlight"];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9],UITextAttributeTextColor, nil] forState:UIControlStateSelected];//颜色
    
    [self.rootTabbarCtr setSelectedIndex:0];
    self.window.rootViewController = self.rootTabbarCtr;
    
}


//初始化一个zi控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage
{
    TS.tabBarItem.title = title;
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    [self.rootTabbarCtr addChildViewController:nav];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    //long index = tabBarController.selectedIndex;
    /*
    switch (index)
    {
        case 0:
            NSLog(@"af");
            break;
        case 1:
            NSLog(@"af");
            break;
        case 2:
            NSLog(@"af");
            break;
        default:
            break;
    }*/
    AudioServicesPlaySystemSound(1306);//系统声音 1000~2000
    
}

@end
