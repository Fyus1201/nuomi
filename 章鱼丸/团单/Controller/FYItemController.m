//
//  FYItemController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/23.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYItemController.h"
#import "FYImageWebController.h"

#import "FYJiageViewCell.h"
#import "FYHomeShopModel.h"
#import "FYItemTuanTableViewCell.h"

#import "FYDengluViewController.h"
#import "FYWebViewController.h"
#import "FYMenuBtnView.h"
#import "UIImageView+WebCache.h"
#import "UINavigationBar+Awesome.h"
#import <SVProgressHUD.h>

@interface FYItemController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UIWebViewDelegate,FYItemTuanTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *NavView;  //改用系统默认
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) FYMenuBtnView *titleView;

@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UIButton *fenxiang;
@property (nonatomic, strong) UIButton *mai;

@property (nonatomic) BOOL led;

@property (nonatomic, strong) NSDictionary *itemModel;
@property (nonatomic, strong) NSMutableArray *likeArray;
@property (nonatomic, strong) UILabel *lab;
@property (nonatomic, strong) UIWebView *webView1;

@end

@implementation FYItemController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self getData:self.httpUrl withHttpArg:self.HttpArg];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;//跳出，返回时的描述
    
    _webView1 = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 1)];
    _webView1.delegate = self;
    _webView1.scrollView.scrollEnabled = NO;
    
    [self initTableView];
    [self initScrollView];
    [self setNav];
    [self setFoot];
    
    [self initAdvView];
    
}


#pragma mark - 启动动画

-(void)initAdvView
{
    _yourSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _yourSuperView.backgroundColor = [UIColor whiteColor];
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=9; i++)
    {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"icon_hud_%zd", i]];
        [refreshingImages addObject:image];
    }
    _imaView = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-100, [UIScreen mainScreen].bounds.size.height/2-70, 200, 120)];
    _imaView.animationImages = refreshingImages;
    [_yourSuperView addSubview:_imaView];
    //[self.view addSubview:_yourSuperView];
    [self.view addSubview:_yourSuperView];
    //[self.view bringSubviewToFront:_yourSuperView];
    
    //设置执行一次完整动画的时长
    _imaView.animationDuration = 9*0.15;
    //动画重复次数 （0为重复播放）
    _imaView.animationRepeatCount = 10;
    [_imaView startAnimating];
    
    
}

-(void)removeAdvImage
{
    [UIView animateWithDuration:0.3f animations:^{
        _yourSuperView.transform = CGAffineTransformMakeScale(0.5f, 0.5f);
        _yourSuperView.alpha = 0.f;
    } completion:^(BOOL finished) {
        [_yourSuperView removeFromSuperview];
    }];
}


#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //self.navigationController.navigationBar.alpha = 0.000;

    self.navigationController.navigationBarHidden = YES;
    if (self.led == YES)
    {
        self.lab.text = @"";
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
        
    }else
    {
        self.lab.text = _itemModel[@"title"];
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //self.navigationController.navigationBar.alpha = 0.000;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //self.navigationController.navigationBar.alpha = 1.000;//将其设置为透明，采用自定义（直接将其隐藏，不能使用返回手势）
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//退出当前ViewController后变回黑色
}

- (void)viewDidDisappear:(BOOL)animated//考虑到滑动推出，另外加两个进行过度
{
    [super viewDidDisappear:animated];
    //self.navigationController.navigationBar.alpha = 1.000;
}

-(void)setNav
{
    //[self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];//用BackgroundColor来做背景，需要处理上方的空格
    //[self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0]];
    //self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //self.navigationController.navigationBar. translucent = YES ; //半透明
    /*
    for (UIView *view in self.navigationController.navigationBar.subviews)
    {
        NSLog(@"图层 %@",self.navigationController.navigationBar.subviews);
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")])//这个图层不能透明，需要去掉
        {
            [view removeFromSuperview];
        }
    }*/
    
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
    [self.view addSubview:self.NavView];
    
    
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 40)];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.text = @"";
    self.lab.textColor = [UIColor blackColor];

    //self.navigationItem.titleView = self.lab;
    [self.NavView addSubview:self.lab];

    
    self.fenxiang = [UIButton buttonWithType:UIButtonTypeCustom];
    self.fenxiang.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 28, 25, 25);
    /*设置按钮不是用这些。。。*/
    //zhuceBtn.titleLabel.text = @"注册";
    //zhuceBtn.titleLabel.backgroundColor = [UIColor redColor];
    //zhuceBtn.titleLabel.textColor = [UIColor redColor];
    UIImage *home1008 = [UIImage imageNamed:@"home-10-07"];
    [self.fenxiang setBackgroundImage:home1008 forState:UIControlStateNormal];
    self.fenxiang.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    [self.fenxiang addTarget:self action:@selector(OnZhuceBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.fenxiang];
    [self.NavView addSubview:self.fenxiang];
    
    //退出
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.frame = CGRectMake(20, 30, 20, 20);
    [self.closeBtn setImage:[UIImage imageNamed:@"brower_pre_0"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.closeBtn];
    [self.NavView addSubview:self.closeBtn];
    
}

-(void)OnCloseBtn:(UIButton *)sender//推出设置
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)OnZhuceBtn:(UIButton *)sender
{
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];

    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+40-80) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.tableHeaderView = self.scrollView;
    //[self setupTableView];//冲突bug UI毁灭
    
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib0 = [UINib nibWithNibName:@"FYJiageViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib0 forCellReuseIdentifier:@"cell0"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [self.view addSubview:self.tableView];
}

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.65)];
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;

    //背景图片
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.65-50)];

    _imageView.image = [UIImage imageNamed:@"account_place_holder"];
    
    
    [self.scrollView addSubview:_imageView];

    [self.tableView addSubview:self.scrollView];

}

- (void)initTitle
{
    //标题文字
    _titleView = [[FYMenuBtnView alloc] initWithFrame9:CGRectMake(0,[UIScreen mainScreen].bounds.size.width*0.45-50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.2) subtitle:@"已售1531" title:_itemModel[@"title"] long_title:_itemModel[@"long_title"]];
    _titleView.backgroundColor = [UIColor blackColor];
    _titleView.backgroundColor = [_titleView.backgroundColor colorWithAlphaComponent:0];

    [self.tableView addSubview:_titleView];
}

-(void)setFoot
{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-80, [UIScreen mainScreen].bounds.size.width, 80)];
    self.footView.backgroundColor = [UIColor whiteColor];
    
    self.footView.layer.borderWidth = 0.5;//边框线
    self.footView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
    [self.view addSubview:self.footView];
    
    self.mai = [UIButton buttonWithType:UIButtonTypeCustom];
    self.mai.frame = CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, 60);
    /*设置按钮不是用这些。。。*/
    //self.mai.titleLabel.text = @"购买";
    //self.mai.titleLabel.backgroundColor = [UIColor redColor];
    //self.mai.titleLabel.textColor = [UIColor whiteColor];
    [self.mai setTitle:@"购买" forState:UIControlStateNormal];
    //[self.mai setBackgroundColor:[UIColor redColor]];
    
    //生成纯色图片
    CGSize imageSize =CGSizeMake(50,50);
    UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
    [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9] set];
    UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
    UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.mai setBackgroundImage:pressedColorImg forState:UIControlStateNormal];//这样有点击效果
    
    self.mai.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    [self.mai addTarget:self action:@selector(OnZhuceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:self.mai];
    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat offsetY = self.tableView.contentOffset.y;
        if (offsetY <= 0 && offsetY >= -170)
        {
            self.scrollView.frame = CGRectMake(0, -50 + offsetY , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*0.65 - offsetY);
            
            _imageView.frame = CGRectMake(offsetY*0.75, 50 , [UIScreen mainScreen].bounds.size.width-1.5*offsetY, [UIScreen mainScreen].bounds.size.width*0.65 - offsetY-50);
            
            //[self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor]colorWithAlphaComponent:0]];
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];


        }
        else if (offsetY < -170)
        {
            [self.tableView setContentOffset:CGPointMake(0, -170)];
        }
        else if (offsetY > 0)
        {
            //[self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:offsetY / 120]];
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:offsetY / 120];
            
        }
        
        
        if (offsetY < 60)
        {
            if (self.led == NO)
            {
                self.led = YES;
                self.lab.text = @"";
                UIImage *home1008 = [UIImage imageNamed:@"home-10-07"];
                [self.fenxiang setBackgroundImage:home1008 forState:UIControlStateNormal];
                
                [self.closeBtn setImage:[UIImage imageNamed:@"brower_pre_0"] forState:UIControlStateNormal];
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
            }
        }else
        {
            if (self.led == YES)
            {
                self.led = NO;
                self.lab.text = _itemModel[@"title"];
                UIImage *home1008 = [UIImage imageNamed:@"home-10-04"];
                [self.fenxiang setBackgroundImage:home1008 forState:UIControlStateNormal];
                
                [self.closeBtn setImage:[UIImage imageNamed:@"detailViewBackRed"] forState:UIControlStateNormal];
                self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
        }

    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_likeArray)
    {
        return 4;
    }else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }else if(section == 1)
    {
        return 3;
    }
    else
    {
        return 2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 100;
    }else if(indexPath.section == 1)
    {
        if (indexPath.row == 1)
        {
            //通过字体大小，计算所需高度
            NSString* cellText = _itemModel[@"buy_contents"];
            CGSize constraintSize = CGSizeMake(240.0f, MAXFLOAT);//MAXFLOAT最大数值，代表随内容变化
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            
            CGSize size = [cellText boundingRectWithSize:constraintSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
            
            return size.height+5;
        }
        else
        {
            return 40;
        }
    }else if(indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }else
        {
            return 4*170;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 40;
        }else
        {
            return _webView1.frame.size.height;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return [UIScreen mainScreen].bounds.size.width*0.65-50;
    } else
    {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        FYJiageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell0" forIndexPath:indexPath];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell setAct:_itemModel];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"套餐内容";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if(indexPath.row == 1)
        {
            NSString * htmlString = _itemModel[@"buy_contents"];
            
            NSAttributedString *attributedString = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            
            
            static NSString *cellIndentifier = @"cell11";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            //换行
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.textLabel.attributedText = attributedString;
            return cell;
        }else
        {
            static NSString *cellIndentifier = @"cell12";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
            }
            cell.textLabel.text = @"查看图文详情";
            cell.textLabel.textColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//箭头图标
            return cell;
        }
        
        
    }else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"消费提示";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else
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
        }

    }else
    {
        if (indexPath.row == 0)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
            
            cell.textLabel.text = @"为您推荐";
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            static NSString *cellIndentifier = @"cellend";
            FYItemTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

            if(cell == nil)
            {
                cell = [[FYItemTuanTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_likeArray];
            }
            
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    }

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld", indexPath.section,indexPath.row);//row 行 section 段
    
    if (indexPath.section == 1)
    {

        if (indexPath.row == 2)
        {
            FYImageWebController *item = [[FYImageWebController alloc] init];
            [item setHtmlString:_itemModel[@"buy_details"]];
            [item setHttpString:_itemModel[@"shop_description"]];
            
            item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    
}

#pragma mark - 手势
- (void)didSelectedItemTuanAtIndex:(NSInteger)index
{
    FYShopTuanModel *shopM = _likeArray[index];
    
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
    NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",shopM.deal_id];
    FYItemController *item = [[FYItemController alloc] init];
    
    item.HttpArg = httpArg;
    item.httpUrl = httpUrl;
    item.session = self.session;
    
    item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
}


#pragma mark - 获取数据

//获取数据 1.0
-(void)getData: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
{
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"781b44a29521ebb8fe00418cceebc576" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              //NSLog(@"错误: %@%ld", error.localizedDescription, error.code);
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败4 ");
                                                  //[SVProgressHUD showInfoWithStatus:error.description];
                                                  [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                              });
                                          } else {
                                              
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              _itemModel = jsonObject[@"deal"];
                                              [_webView1 loadHTMLString:_itemModel[@"consumer_tips"] baseURL:nil];
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新成功4 ");
                                                  
                                                  [self getRecommendData];
                                                  [_imageView sd_setImageWithURL:[NSURL URLWithString:_itemModel[@"image"]] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
                                                
                                                  [self initTitle];
                                                  
                                                  [self.tableView reloadData];
                                                  
                                              });
                                              
                                          }
                                      }];
    [dataTask resume];
}

//获取猜你喜欢数据
-(void)getRecommendData
{
    NSString *urlStr = @"http://app.nuomi.com/naserver/search/likeitem?ad_deal_id_list=&appid=ios&backupList=&bduss=&channel=com_dot_apple&cityid=600060000&compId=index&compV=3.1.6&cuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&device=iPhone&frontend=component&frontend_style=singleList&ha=5&last_s=-1&lbsidfa=DBBA76B9-1612-410D-B250-E76FD82CAA28&locate_city_id=600060000&location=29.988420%2C120.532080&logpage=Home&net=wifi&os=9.2&page_type=component&power=0.67&sheight=1334&sign=5a765ebc07b96d94a7b3e60d74e6fc2b&start_idx=0&swidth=750&terminal_type=ios&timestamp=1458388033637&tn=ios&tuan_size=20&uuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&v=6.4.0&wifi=%5B%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D%5D&wifi_conn=%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D";
    
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
                                                  NSLog(@" 刷新失败3 ");
                                                  [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  
                                              });
                                          } else {
 
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              
                                              FYHomeShopModel *homeShopM = [MTLJSONAdapter modelOfClass:[FYHomeShopModel class] fromJSONDictionary:jsonObject[@"data"] error:nil];
                                              _likeArray = [[NSMutableArray alloc] initWithArray:homeShopM.tuan_list];
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新成功3 ");
                                                  [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [self.tableView reloadData];
                                                
                                              });
                                              
                                              
                                          }
                                      }];
    [dataTask resume];
}

#pragma mark - UIWebView Delegate Methods
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGFloat height1 = [[self.webView1 stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.webView1.frame = CGRectMake(self.webView1.frame.origin.x,self.webView1.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height1+25);
    
    //html里的js 导致的内存泄漏
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


#pragma  mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}

@end
