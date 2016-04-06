//
//  FYTabBarController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTabBarController.h"
#import "FYHomeViewController.h"
#import "FYXuanViewController.h"
#import "FYJingViewController.h"
#import "FYMeViewController.h"

#import "FYWebViewController.h"


@interface FYTabBarController()

@property (nonatomic) NSURLSession *session;

@end

@implementation FYTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    [self initAdvView];
    [self initTabbarItem];
    
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
        [self.view addSubview:_advImage];
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:3];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //加载启动广告并保存到本地沙盒，因为保存的图片较大，每次运行都要保存，所以注掉了
            [self getLoadingImage];
        });
    }else
    {
        NSLog(@"不存在");
        
        NSMutableArray *refreshingImages = [NSMutableArray array];
        for (NSUInteger i = 1; i<=9; i++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
            [refreshingImages addObject:image];
        }
         _advImage = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-70, 200, 120)];
        _advImage.animationImages = refreshingImages;
        [self.view addSubview:_advImage];
        
        //设置执行一次完整动画的时长
        _advImage.animationDuration = 9*0.15;
        //动画重复次数 （0为重复播放）
        _advImage.animationRepeatCount = 1.5;
        [_advImage startAnimating];
        
        [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:2];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getLoadingImage];
        });
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

-(void)initTabbarItem{
    
    
    FYHomeViewController *home0 = [[FYHomeViewController alloc]init];
    [self controller:home0 title:@"首页" image:@"icon_tab_shouye_normal" selectedimage:@"icon_tab_shouye_highlight"];
    
    FYJingViewController *jing = [[FYJingViewController alloc]init]; 
    [self controller:jing title:@"附近" image:@"icon_tab_fujin_normal" selectedimage:@"icon_tab_fujin_highlight"];

    FYXuanViewController *yuan = [[FYXuanViewController alloc]init];
    [self controller:yuan title:@"精选" image:@"tab_icon_selection_normal" selectedimage:@"tab_icon_selection_highlight"];
    
    FYMeViewController *my = [[FYMeViewController alloc]init];
    [self controller:my title:@"我的" image:@"icon_tab_wode_normal" selectedimage:@"icon_tab_wode_highlight"];

    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9],UITextAttributeTextColor, nil] forState:UIControlStateSelected];//颜色
    
}


//初始化一个zi控制器
-(void)controller:(UIViewController *)TS title:(NSString *)title image:(NSString *)image selectedimage:(NSString *)selectedimage
{
    TS.tabBarItem.title = title;
    TS.tabBarItem.image = [UIImage imageNamed:image];
    TS.tabBarItem.selectedImage = [[UIImage imageNamed:selectedimage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:TS];
    [self addChildViewController:nav];
}

@end
