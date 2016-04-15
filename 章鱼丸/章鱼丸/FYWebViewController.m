//
//  FYWebViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYWebViewController.h"
#import "FYDengluViewController.h"
#import "FYSearchViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>  

@interface FYWebViewController ()<UIWebViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation FYWebViewController

- (void)loadView
{
    self.webView = [[UIWebView alloc] init];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    //self.uiWebView.scrollView.delegate = self;
    
    self.view = self.webView;
    [self initViews];//加载时候的圈圈
}

-(void)initViews
{
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-15, [UIScreen mainScreen].bounds.size.height/2-85, 30, 30)];
    _activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //_activityView.backgroundColor = [UIColor redColor];
    _activityView.hidesWhenStopped = YES;
    [self.view addSubview:_activityView];
    [self.view bringSubviewToFront:_activityView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setURL:(NSURL *)URL
{
    _URL = URL;
    if (_URL)//懒加载
    {
        NSURLRequest *req = [NSURLRequest requestWithURL:_URL];
        [(UIWebView *)self.view loadRequest:req];
        //[self.uiWebView loadRequest:req];
    }
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self setupnav];
    [self.webView reload];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
}

#pragma mark - 初始化头部
-(void)setupnav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    UIBarButtonItem *item1;
    if (self.LED)
    {
        //右边按钮
        UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
        [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-01"] forState:UIControlStateNormal];
        EBtn.frame = CGRectMake(0, 0, 20, 20);
        item1 = [[UIBarButtonItem alloc]initWithCustomView:EBtn];
    }else
    {
        //右边按钮
        UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [EBtn setBackgroundImage:[UIImage imageNamed:@"icon_nav_fenxiang_normal"] forState:UIControlStateNormal];
        [EBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
        EBtn.frame = CGRectMake(0, 0, 20, 20);
        item1 = [[UIBarButtonItem alloc]initWithCustomView:EBtn];
    }
    
    self.navigationItem.rightBarButtonItems = @[item1];
}

-(void)rightBtnClick1:(UIButton *)button
{
    NSLog(@"搜索");
    
    FYSearchViewController *search = [[FYSearchViewController alloc]init];
    search.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:search animated:YES];//1.点击，相应跳转
}

-(void)rightBtnClick2:(UIButton *)button
{
    NSLog(@"购物车");
    
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - webview delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");

}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//JavaScript document title 属性：得到当前文档的标题
    if ([theTitle length] != 0)
    {
        self.navigationItem.title = theTitle;
    }else
    {
        self.navigationItem.title = self.name;
    }
    
    NSLog(@"完成加载");
    
    //Html里的js 导致的内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //首先创建JSContext 对象（此处通过当前webView的键获取到jscontext）
    /*
    JSContext *context=[webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSString *alertJS=@"alert('test js OC')"; //准备执行的js代码
    [context evaluateScript:alertJS];//通过oc方法调用js的alert
    */
    [_activityView stopAnimating];//圈圈  转啊转
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //NSLog(@"错误:%@", [error description]);

}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *cont = [request.URL absoluteString];//url转string
    NSRange range = [cont rangeOfString:@"bainuo://"];
    if (range.location != NSNotFound)
    {
        [webView stringByEvaluatingJavaScriptFromString:@"alert('跳转糯米，失败')"];
        return NO;//你tm别想跳到糯米app上,233333
    }
    NSString *theTitle=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];//JavaScript document title 属性：得到当前文档的标题
    //NSLog(@"你好啊%@",theTitle);
    
    //[webView stringByEvaluatingJavaScriptFromString:@"alert('测试章鱼')"];//js oc交互 可以出弹窗
    //self.title = theTitle;
    //NSLog(@"测试2:   %@",theTitle);
    
   // NSString *shuju=[webView stringByEvaluatingJavaScriptFromString:@"document"];
    //NSLog(@"数据大爷%@",cont);
    
    [_activityView startAnimating];
    return YES;
}

@end
