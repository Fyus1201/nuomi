//
//  FYImageWebController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/2.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYImageWebController.h"

@interface FYImageWebController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView0;
@property (nonatomic, strong) UIWebView *webView1;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation FYImageWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色

    self.navigationController.navigationBar.topItem.title = @"图文详情";
    //self.navigationController.title = @"图文详情";
    //前面指定过，这边不行了
    
    _webView0 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    _webView0.delegate = self;
    _webView0.scrollView.scrollEnabled = NO;
    _webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    _webView1.delegate = self;
    _webView1.scrollView.scrollEnabled = NO;
    
    [self initTableView];
    [_webView0 loadHTMLString:self.htmlString baseURL:nil];
    [_webView1 loadHTMLString:self.htmlString baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - TableViewDelegate & TableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.htmlString)
    {
        if (self.httpString)
        {
            return 2;
        }else
        {
            return 1;
        }
    }else
    {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return  2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            static NSString *identifier = @"webCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell.contentView addSubview:_webView0];
                /* 忽略点击效果 */
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }else{
            static NSString *identifier = @"wcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"套餐内容";
            return cell;
        }
    }else
    {
        if (indexPath.row == 1)
        {
            static NSString *identifier = @"webCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                [cell.contentView addSubview:_webView1];
                /* 忽略点击效果 */
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            return cell;
        }else{
            static NSString *identifier = @"wcell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.textLabel.text = @"店家详情";
            return cell;
        }
    }

    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.section == 0)
    {
        if(indexPath.row == 1)
        {
            /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
            return _webView0.frame.size.height;
        }else
        {
            return 40;
        }
    }else
    {
        if(indexPath.row == 1)
        {
            /* 通过webview代理获取到内容高度后,将内容高度设置为cell的高 */
            return _webView1.frame.size.height;
        }else
        {
            return 40;
        }
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{    //获取到webview的高度
    CGFloat height0 = [[self.webView0 stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView0.frame = CGRectMake(self.webView0.frame.origin.x,self.webView0.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height0);
    
    CGFloat height1 = [[self.webView1 stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView1.frame = CGRectMake(self.webView1.frame.origin.x,self.webView1.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height1);
    
    //Html里的js 导致的内存泄漏
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    NSLog(@"didFailLoadWithError===%@", error);
}




@end
