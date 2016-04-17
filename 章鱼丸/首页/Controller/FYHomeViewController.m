//
//  FYHomeViewController.m
//  章鱼丸
//  糯米更新之后，很多cell其实是按照数组数量可以复用，因为旧版本问题，当时是直接新建了一个cell
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYHomeViewController.h"
#import "FYCityViewController.h"

#import "FYWebViewController.h"
#import "FYItemController.h"

#import "FYSaoViewController.h"
#import "FYiflyMSCViewController.h"
#import "FYSearchViewController.h"
#import "FYTSearchViewController.h"

#import "FYDengluViewController.h"

#import "FYtopbannerViewCell.h"
#import "FYHomeMenuCell.h"
#import "FYHomeTwoCell.h"
#import "FYJjinxuanViewCell.h"
#import "FYXingViewCell.h"
#import "FY31TableViewCell.h"
#import "FYFiveViewCell.h"
#import "FY33TableViewCell.h"
#import "FYSevenViewCell.h"
#import "FYLikeViewCell.h"
#import "FYEbannerViewCell.h"
#import "FYMeishiTableViewCell.h"
#import "FYMbannerViewCell.h"

#import "FYHomeGroupModel.h"

#import "FYHomeShopModel.h"
#import "FYDataModel.h"
#import "FYData.h"

#import "FYShuaxingHeader.h"

#import <SVProgressHUD.h>


@interface FYHomeViewController()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FYtopbannerViewCellDelegate,FY31Block2Delegate,FYFiveViewCellDelegate,FY33Block3Delegate,FYSevenDelegate,FYEbannerViewCellDelegate,FYMbannerViewCellDelegate,FYMeiDelegate,FYHomeMenuCellDelegate,UISearchBarDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic) BOOL led;
@property (nonatomic, strong) UIView *NavView;

@property (nonatomic, strong) UIButton *leftbtn;//左边城市选择

@property (nonatomic, strong) NSMutableArray *menuArray;
@property (nonatomic, strong) NSMutableArray *twoArray;
@property (nonatomic, strong) NSMutableArray *fiveArray;

@property (nonatomic, strong) FYtopbannerViewCell *topCell;
@property (nonatomic, strong) FYHomeTwoCell *cell2;
@property (nonatomic, strong) FYMbannerViewCell *cell5;
@property (nonatomic, strong) FYEbannerViewCell *cell6;
@property (nonatomic, strong) FYFiveViewCell *cell7;

@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;
@property (nonatomic) NSURLSession *session;

/**
 *  猜你喜欢数据源
 */
@property (nonatomic, strong) NSMutableArray *likeArray;

@property (nonatomic, strong) NSMutableArray *bannersArray;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) NSMutableArray *recommendArray;
@property (nonatomic, strong) FYHometopModel *topenModel;

@property (nonatomic, strong) FYHomeGroupModel *homeGroupM;

@end

@implementation FYHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    [self initData];//初始化数据
    
    [self getHotData2];
    [self getRecommendData];
    
    [self setupnav];//初始化头部
    [self initTableview];//初始化表格
    [self setNav];//真正的头部
    
    [self initAdvView];
    
    self.navigationController.interactivePopGestureRecognizer.delegate =(id)self;
    
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];//隐藏 常态时是否隐藏 动画时是否显示
    //图标颜色转换
    if (self.led == NO)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
    }
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    [_leftbtn setTitle:item.city forState:UIControlStateNormal];
    
    if ([item.searchTerm length] > 0)
    {
        FYTSearchViewController *tuans = [[FYTSearchViewController alloc] init];
        tuans.searchTuan = item.searchTerm;
        [self.navigationController pushViewController:tuans animated:YES];//1.点击，相应跳转
    }
    
    //[self setupnav];//初始化头部
    [self.cell2 addTimer];
    [self.topCell addTimer];
    if (_homeGroupM.meishiGroup.banner.count >1 )
    {
        [self.cell5 addTimer];
    }
    if (_homeGroupM.entertainment.banner.count >1 )
    {
        [self.cell6 addTimer];
    }
    if (_bannersArray.count >1 )
    {
        [self.cell7 addTimer];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;//退出当前ViewController后变回黑色
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    item.searchTerm = @"";
    
    [self.cell2 closeTimer];
    [self.topCell closeTimer];
    if (_homeGroupM.meishiGroup.banner.count >1 )
    {
        [self.cell5 closeTimer];
    }
    if (_homeGroupM.entertainment.banner.count >1 )
    {
        [self.cell6 closeTimer];
    }
    if (_bannersArray.count >1 )
    {
        [self.cell7 closeTimer];
    }

}

#pragma mark - 启动动画

-(void)initAdvView
{
    _yourSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+64)];
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
    [self.view addSubview:_yourSuperView];
    //[self.view bringSubviewToFront:_yourSuperView];
    //[self.view insertSubview:_yourSuperView atIndex:0];
    
    _yourSuperView.hidden = NO;
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
        //[_yourSuperView removeFromSuperview];//会直接移除，不能再次使用，故使用隐藏
        _yourSuperView.hidden = YES;
    }];
}



 #pragma mark - 初始化
-(void)initData
{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    self.likeArray = [[NSMutableArray alloc] init];
    
    self.bannersArray = [[NSMutableArray alloc] init];
    self.categoryArray = [[NSMutableArray alloc] init];
    self.recommendArray = [[NSMutableArray alloc] init];
    
    NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"menuData" ofType:@"plist"];
    self.menuArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
    
    NSString *plistPath1 = [[NSBundle mainBundle]pathForResource:@"twoData" ofType:@"plist"];
    self.twoArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath1];
    
    NSString *plistPath2 = [[NSBundle mainBundle]pathForResource:@"fiveData" ofType:@"plist"];
    self.fiveArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath2];
    
    if ([[FYDataModel sharedStore] allItems].count == 0)
    {
        [[FYDataModel sharedStore] createItem];
    }

}

#pragma mark - 初始化表格
-(void)initTableview
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+20) style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //
    self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib1 = [UINib nibWithNibName:@"FYJjinxuanViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"cell2"];
    
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib2 = [UINib nibWithNibName:@"FYXingViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"cell3"];
    
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib3 = [UINib nibWithNibName:@"FYLikeViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib3 forCellReuseIdentifier:@"cell8"];
    
    [self.view addSubview:self.tableView];
    [self setupTableView];//初始化下拉刷新(基于tableview需要先初始化tableview)
    
}

#pragma mark - 初始化刷新

-(void)setupTableView
{
    self.tableView.mj_header = [FYShuaxingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    //[self.tableView.mj_header beginRefreshing];
}

-(void)loadNewData
{
    
    [self getHotData2];
    [self getRecommendData];
    
}

#pragma mark - 初始化头部
-(void)setupnav
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//默认开启,侧滑返回
    /*
    //左边按钮
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(0, 0, 40, 35);
    [leftbtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
    
    leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    
    leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    [leftbtn setTitle:item.city forState:UIControlStateNormal];
    //leftbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    leftbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftbtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftbtn = leftbtn;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftbtn];
    
    //右边按钮
    UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-08"] forState:UIControlStateNormal];
    EBtn.frame = CGRectMake(0, 0, 20, 20);
    [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:EBtn];
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"home-10-07"] forState:UIControlStateNormal];
    XBtn.frame = CGRectMake(0, 0, 24, 24);
    [XBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:XBtn];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    //中间
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30)];

    view.layer.cornerRadius = 10;//设置那个圆角的有多圆
    view.layer.borderWidth = 0;//设置边框的宽度，当然可以不要
    view.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    view.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30)];
    //searchBar.backgroundImage = [UIImage imageNamed:@"home-10-05"];
    searchBar.placeholder = @"搜索商家或地点";
    searchBar.delegate = self;
    
    UIButton *YBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [YBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    YBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-180, 0, 45, 30);
    [YBtn addTarget:self action:@selector(rightBtnClick3:) forControlEvents:UIControlEventTouchUpInside];

    [view addSubview:searchBar];
    //键盘上放一个按钮
    UIButton *sousuo = [UIButton buttonWithType:UIButtonTypeCustom];

    [sousuo.backgroundColor colorWithAlphaComponent:0];
    sousuo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30);
    [sousuo addTarget:self action:@selector(sousuo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sousuo];
    [view addSubview:YBtn];
    
    self.navigationItem.titleView = view;
     */

}
//重新初始化头部,考虑到navigationController定制度很高
-(void)setNav
{
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(-0.5, -0.5, [UIScreen mainScreen].bounds.size.width+1, 64.5)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
    
    [self.view addSubview:self.NavView];
    
    //左边按钮
    UIButton *leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbtn.frame = CGRectMake(20, 23, 40, 35);
    [leftbtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
    
    leftbtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    [leftbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -35, 0, 0)];
    
    leftbtn.imageEdgeInsets = UIEdgeInsetsMake(0, 28, 0, 0);
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    [leftbtn setTitle:item.city forState:UIControlStateNormal];
    //leftbtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    leftbtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [leftbtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.leftbtn = leftbtn;
    [self.NavView addSubview:leftbtn];
    
    //右边按钮
    UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-08"] forState:UIControlStateNormal];
    EBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-64, 30, 20, 20);
    [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    EBtn.tag = 401;
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"home-10-07"] forState:UIControlStateNormal];
    XBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-34, 28, 24, 24);
    [XBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    XBtn.tag = 402;
    
    [self.NavView addSubview:EBtn];
    [self.NavView addSubview:XBtn];

    //中间
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(70, 25, [UIScreen mainScreen].bounds.size.width-145, 30)];
    view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    view.layer.cornerRadius = 10;//设置那个圆角的有多圆
    view.layer.borderWidth = 0.2;//设置边框的宽度，当然可以不要
    view.layer.borderColor = [[UIColor grayColor] CGColor];//设置边框的颜色
    view.layer.masksToBounds = YES;
    
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30)];
    searchBar.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    searchBar.placeholder = @"搜索商家或地点";
    //searchBar.delegate = self;
    searchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:searchBar.bounds.size];
    UIView *searchTextField = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
        searchBar.barTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
        searchTextField = [[[searchBar.subviews firstObject] subviews] lastObject];
    } else
    { // iOS6以下版本searchBar内部子视图的结构不一样
        for (UIView *subView in searchBar.subviews)
        {
            if ([subView isKindOfClass:NSClassFromString(@"UISearchBarTextField")])
            {
                searchTextField = subView;
            }
        }
    }
    searchTextField.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.0];
    
    UIButton *YBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [YBtn setBackgroundImage:[UIImage imageNamed:@"voice"] forState:UIControlStateNormal];
    YBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-180, 0, 45, 30);
    [YBtn addTarget:self action:@selector(rightBtnClick3:) forControlEvents:UIControlEventTouchUpInside];
     searchBar.showsScopeBar = NO;
    
    [view addSubview:searchBar];
    //键盘上放一个按钮
    UIButton *sousuo = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [sousuo.backgroundColor colorWithAlphaComponent:0];
    sousuo.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-145, 30);
    [sousuo addTarget:self action:@selector(sousuo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:sousuo];
    [view addSubview:YBtn];
    
    [self.NavView addSubview:view];
    

}

//取消searchbar背景色  生成纯色image
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 图片大小处理 PS:会失真
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

#pragma mark - ScrollView 使用头文件刷新 中的距离

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat offsetY = self.tableView.contentOffset.y;
        
        if (offsetY <= 0 && offsetY >= -20)
        {
            [UIView animateWithDuration:0.25
                             animations:^{
                                 self.NavView.alpha = 1.0;
                             } completion:^(BOOL finished) {
                             }];
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
            
        }
        else if (offsetY < -20)
        {
            
            [UIView animateWithDuration:0.25
                             animations:^{
                self.NavView.alpha = 0.0;
            } completion:^(BOOL finished) {
            }];
        }
        else if (offsetY > 0)
        {
            if (self.NavView.alpha == 0.0)
            {
                self.NavView.alpha = 1.0;
            }
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:offsetY / 120];
        }
        
        //图标颜色转换
        if (offsetY < 80 && offsetY > -25)
        {
            if (self.led == NO)
            {
                self.led = YES;
                [self.leftbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [self.leftbtn setImage:[UIImage imageNamed:@"icon_homepage_downArrow"] forState:UIControlStateNormal];
                
                UIButton *EBtn = (UIButton *)[self.NavView viewWithTag:401];
                UIButton *XBtn = (UIButton *)[self.NavView viewWithTag:402];
                [EBtn setImage:[UIImage imageNamed:@"home-10-08"] forState:UIControlStateNormal];
                [XBtn setImage:[UIImage imageNamed:@"home-10-07"] forState:UIControlStateNormal];
                
                self.NavView.layer.borderWidth = 0.0;//边框线
                self.NavView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                
                [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//白色
            }
        }else
        {
            if (self.led == YES)
            {
                self.led = NO;
                [self.leftbtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateNormal];
                [self.leftbtn setImage:[UIImage imageNamed:@"icon_arrows_red_down"] forState:UIControlStateNormal];
                
                UIButton *EBtn = (UIButton *)[self.NavView viewWithTag:401];
                UIButton *XBtn = (UIButton *)[self.NavView viewWithTag:402];
                [EBtn setImage:[UIImage imageNamed:@"home-10-03"] forState:UIControlStateNormal];
                [XBtn setImage:[UIImage imageNamed:@"home-10-04"] forState:UIControlStateNormal];
                
                if (offsetY < -25)
                {
                    self.NavView.layer.borderWidth = 0.0;//边框线
                    self.NavView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                }else
                {
                    self.NavView.layer.borderWidth = 0.5;//边框线
                    self.NavView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
                }
                
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
        }
        
    }
}


#pragma mark - 左边的按钮
-(void)leftBtnClick:(UIButton *)button
{
    //NSLog(@"城市");
    FYCityViewController *cityVC = [[FYCityViewController alloc] init];
    //cityVC.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController: cityVC animated:YES completion:nil];
}

#pragma mark - 右边的按钮
-(void)rightBtnClick1:(UIButton *)button
{
    NSLog(@"扫一扫");
    FYSaoViewController *sao = [[FYSaoViewController alloc]init];
    
    sao.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:sao animated:YES];//1.点击，相应跳转
}
-(void)rightBtnClick2:(UIButton *)button
{
    NSLog(@"购物车");
    
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
    
    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}
-(void)rightBtnClick3:(UIButton *)button
{
    NSLog(@"语音");
    
    FYiflyMSCViewController *iflyMSC = [[FYiflyMSCViewController alloc]init];
    
    [self presentViewController:iflyMSC animated:YES completion:nil];//1.点击，相应跳转
}

#pragma mark - 搜索事件   UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar//不使用
{
    NSLog(@"搜索");
    //[searchBar setShowsCancelButton:NO animated:YES];
    //self.tableView.allowsSelection=NO;
    //self.tableView.scrollEnabled=NO;
    
    FYSearchViewController *search = [[FYSearchViewController alloc]init];
    
    search.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:search animated:YES];//1.点击，相应跳转

}

-(void)sousuo:(UIButton *)button
{
    NSLog(@"搜索");
    //[searchBar setShowsCancelButton:NO animated:YES];
    //self.tableView.allowsSelection=NO;
    //self.tableView.scrollEnabled=NO;
    
    FYSearchViewController *search = [[FYSearchViewController alloc]init];
    
    search.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:search animated:YES];//1.点击，相应跳转
    
}

#pragma mark - UITablviewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_homeGroupM )//没加载到数据就不显示了
    {
        if (_likeArray)
        {
            return 10;
        }else
        {
            return 9;
        }
        
    }else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 6)
    {
        if (_homeGroupM.meishiGroup.banner)
        {
            return 3;
        }else
        {
            return 2;
        }
    }else
    if (section == 7)
    {
        if (_homeGroupM.entertainment.banner)
        {
            return 3;
        }else
        {
            return 2;
        }
    }else
    if (section == 8)
    {
        if (_homeGroupM.hotService.banner)
        {
            return 3;
        }else
        {
            return 2;
        }
    }else
    if (section == 9)
    {
        return _likeArray.count+2;
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 160;
    } else if (indexPath.section == 1)
    {
        return 180;
    } else if (indexPath.section == 2)
    {
        return 30;
    } else if (indexPath.section == 3)
    {
        return 200;
    } else if(indexPath.section == 4)
    {
        return 80;
      
    } else if(indexPath.section == 5)
    {
        if ([_homeGroupM.activityGroup[@"listInfo"] count] == 5)
        {
            return 300;
        }else if ([_homeGroupM.activityGroup[@"listInfo"] count] == 4)
        {
            return 160;
        }
        else if ([_homeGroupM.activityGroup[@"listInfo"] count] == 7||[_homeGroupM.activityGroup[@"listInfo"] count] == 8)
        {
            return 320;
        }
        else
        {
            return 200;
        }
        
    }else if(indexPath.section == 6)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }if (indexPath.row == 2)
        {
            return 60;
        }else
        {
            if ([_homeGroupM.meishiGroup.listInfo count] == 5)
            {
                return 300;
            }else if ([_homeGroupM.meishiGroup.listInfo count] == 4)
            {
                return 160;
            }
            else if ([_homeGroupM.meishiGroup.listInfo count] == 7||[_homeGroupM.meishiGroup.listInfo count] == 8)
            {
                return 320;
            }
            else
            {
                return 200;
            }
        }
    }else if(indexPath.section == 7)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }if (indexPath.row == 2)
        {
            return 60;
        }else
        {
            if ([_homeGroupM.entertainment.listInfo count] == 5)
            {
                return 300;
            }else if ([_homeGroupM.entertainment.listInfo count] == 4)
            {
                return 160;
            }
            else if ([_homeGroupM.entertainment.listInfo count] == 7||[_homeGroupM.entertainment.listInfo count] == 8)
            {
                return 320;
            }
            else
            {
                return 200;
            }
        }


    }else if(indexPath.section == 8)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }if (indexPath.row == 2)
        {
            return 60;
        }else
        {
            if ([_homeGroupM.hotService.listInfo count] == 5)
            {
                return 300;
            }else if ([_homeGroupM.hotService.listInfo count] == 4)
            {
                return 160;
            }
            else if ([_homeGroupM.hotService.listInfo count] == 7||[_homeGroupM.hotService.listInfo count] == 8)
            {
                return 320;
            }
            else
            {
                return 200;
            }
        }
    }else if (indexPath.section == 9)
    {
        if (indexPath.row == 0)
        {
            return 40;
        }if (indexPath.row == _likeArray.count + 1)
        {
            return 30;
        }else
        {
            return 80;
        }
    }
    else {
        return 70;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 1)
    {
        return 0.0001;
    }
    else if(section == 2)
    {
        return 5;
    }else if(section == 3)
    {
        return 10;

    }else if(section == 6)
    {
        return 15;
    }else if(section == 7)
    {
        return 15;
    }else if(section == 8)
    {
        return 15;
    }else if(section == 9)
    {
        return 15;
    }
    else
    {
        return 5;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0001;
}

//自定义的section的头部 或者 底部

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
   
    headerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    return headerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    footerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    return footerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tsID = @"FY404";
    UITableViewCell *cell0 = [tableView dequeueReusableCellWithIdentifier:tsID];
    if(cell0 == nil)
    {
        cell0= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tsID];
    }
    NSString *str = @" ";
    cell0.textLabel.text = str;
    cell0.textLabel.textAlignment = NSTextAlignmentCenter;
    [cell0 setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell0.backgroundColor = [UIColor whiteColor];
    
      if (indexPath.section == 0)
    {

        static NSString *cellIndentifier = @"celltop";
        self.topCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(self.topCell == nil)
        {
            self.topCell = [[FYtopbannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array:_homeGroupM.banners];
        }
        self.topCell.delegate = self;
        return self.topCell;
    }
    else if(indexPath.section == 1)
    {
        //将他的加载写在了cell内部
        
        FYHomeMenuCell *cell = [FYHomeMenuCell cellWithTableView:tableView menuArray:self.menuArray];
        cell.delegate = self;
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *cellIndentifier = @"cell1";
        self.cell2 = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if(self.cell2 == nil)//懒加载
        {
            self.cell2 = [[FYHomeTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier twoArray:self.twoArray];
        }
        
        self.cell2.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.cell2;
    }
    else if (indexPath.section == 3)
    {
        FYJjinxuanViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2" forIndexPath:indexPath];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setListArray:_topenModel.list];
        [cell setActiveTimeArray:_topenModel.activetime];
        return cell;
    }
    else if (indexPath.section == 4)
    {
        FYXingViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3" forIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setHomeNewDataDic:_homeGroupM.daoDianfu[0]];
        return cell;
    }
    else  if (indexPath.section == 5)
    {
        if (_homeGroupM.activityGroup)
        {
            static NSString *cellID = @"cell4";
            
            FY31TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if(cell == nil)
            {
                cell = [[FY31TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID array:_homeGroupM.activityGroup[@"listInfo"]];
            }
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        return cell0;
    }
    else if (indexPath.section == 6)
    {
        if (_homeGroupM.entertainment)
        {
            if (indexPath.row == 0)
            {
                static NSString *cellIndentifier = @"cell5start";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.text = _homeGroupM.meishiGroup.ceilTitle;
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//箭头图标
                /*
                 //生成纯色图片
                 CGSize imageSize =CGSizeMake(20,40);
                 UIGraphicsBeginImageContextWithOptions(imageSize,0, [UIScreen mainScreen].scale);
                 [[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.9] set];
                 UIRectFill(CGRectMake(0,0, imageSize.width, imageSize.height));
                 UIImage *pressedColorImg =UIGraphicsGetImageFromCurrentImageContext();
                 UIGraphicsEndImageContext();
                 
                 cell.imageView.image = pressedColorImg;
                 cell.imageView.frame = CGRectMake(-50, 0, 20, 50);
                 */
                //离最左有一定距离，放弃，可以尝试 添加图片的方式
                cell.detailTextLabel.text = _homeGroupM.meishiGroup.descTitle;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                
                return cell;
            }else if(indexPath.row == 2)
            {
                static NSString *cellIndentifier = @"cell5end";
                self.cell5 = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(self.cell5 == nil)
                {
                    self.cell5 = [[FYMbannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array:_homeGroupM.meishiGroup.banner];
                }
                self.cell5.delegate = self;
                return self.cell5;
                
            }else
            {
                static NSString *cellIndentifier = @"cell5";
                FYMeishiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    if (_homeGroupM.meishiGroup.listInfo)
                    {
                        cell = [[FYMeishiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_homeGroupM.meishiGroup.listInfo ];
                    }else
                    {
                        cell = [[FYMeishiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                    }
                }
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        return cell0;
        
    }
    else  if (indexPath.section == 7)
    {
        if (_homeGroupM.entertainment)
        {
            if (indexPath.row == 0)
            {
                static NSString *cellIndentifier = @"cell6start";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.text = _homeGroupM.entertainment.ceilTitle;
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//箭头图标
                cell.detailTextLabel.text = _homeGroupM.entertainment.descTitle;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                return cell;
            }else if(indexPath.row == 2)
            {
                static NSString *cellIndentifier = @"cell6end";
                self.cell6 = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(self.cell6 == nil)
                {
                    self.cell6 = [[FYEbannerViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array:_homeGroupM.entertainment.banner];
                }
                self.cell6.delegate = self;
                return self.cell6;
                
            }else
            {
                static NSString *cellIndentifier = @"cell6";
                FY33TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    if (_homeGroupM.entertainment.listInfo)
                    {
                        cell = [[FY33TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_homeGroupM.entertainment.listInfo];
                    }else
                    {
                        cell = [[FY33TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                    }
                }
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        return cell0;
    }
    else if (indexPath.section == 8)
    {
        
        if (_homeGroupM.hotService)
        {
            if (indexPath.row == 0)
            {
                static NSString *cellIndentifier = @"cell7start";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.text = _homeGroupM.hotService.ceilTitle;
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;//箭头图标
                cell.detailTextLabel.text = _homeGroupM.hotService.descTitle;
                cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
                return cell;
            }
            else if(indexPath.row == 2)
            {
                static NSString *cellIndentifier = @"cell7end";
                self.cell7 = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if(self.cell7 == nil)
                {
                    self.cell7 = [[FYFiveViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier Array:_homeGroupM.hotService.banner];
                }
                self.cell7.delegate = self;
                return self.cell7;
                
            }
            else
            {
                static NSString *cellIndentifier = @"cell7";
                FYSevenViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    if (_homeGroupM.hotService.listInfo)
                    {
                        cell = [[FYSevenViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_homeGroupM.hotService.listInfo];
                    }else
                    {
                        cell = [[FYSevenViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                    }
                }
                cell.delegate = self;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        return cell0;
        
    }
    else if (indexPath.section == 9)
    {
        if (_likeArray)
        {
            if (indexPath.row == 0)
            {
                static NSString *cellIndentifier = @"cell8start";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"猜你喜欢";
                cell.textLabel.font = [UIFont systemFontOfSize:18];
                return cell;
            }else if(indexPath.row == _likeArray.count + 1)
            {
                static NSString *cellIndentifier = @"cell8end";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
                if (cell == nil)
                {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"   没有更多了";
                cell.textLabel.font = [UIFont systemFontOfSize:13];
                cell.textLabel.textColor = [UIColor grayColor];
                //赋值
                return cell;
            }else
            {
                FYLikeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell8"];
                if (_likeArray.count>0)
                {
                    FYShopTuanModel *shopM = _likeArray[indexPath.row - 1];
                    [cell setShopM:shopM];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
        
        return cell0;
    }
    else
    {
        return cell0;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    NSLog(@"%ld,%ld", indexPath.section,indexPath.row);//row 行 section 段

        if (indexPath.section == 3)
        {
            NSString *urlStr = @"http://t10.nuomi.com/webapp/na/topten?from=fr_na_t10tab&sizeLimit=8&version=2&needstorecard=1&areaId=100010000&location=39.989430,116.324470&bn_aid=ios&bn_v=5.13.0&bn_chn=com_dot_apple";
            NSURL *url = [NSURL URLWithString: urlStr];
            FYWebViewController *web0 = [[FYWebViewController alloc]init];
            [web0 setURL:url];
            web0.name = @"精选抢购";
            web0.LED = YES;
            web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
        }
    
        if (indexPath.section == 4)
        {
            NSDictionary *new = _homeGroupM.daoDianfu[0];

            NSString *cont = [new objectForKey:@"cont"];
            NSURL *url;
            
            NSRange range0 = [cont rangeOfString:@"component?url="];
            NSRange range1 = [cont rangeOfString:@"url="];
            
            if (range0.location != NSNotFound)
            {
                NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
                subStr = [subStr stringByRemovingPercentEncoding];//换格式
                NSString *strUrl = subStr;
                strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
                url = [NSURL URLWithString: strUrl];
                
            }else if (range1.location != NSNotFound) {
                NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
                subStr = [subStr stringByRemovingPercentEncoding];
                NSString *strUrl = subStr;
                strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
                url = [NSURL URLWithString: strUrl];
                
            }else
            {
                url = [NSURL URLWithString: @"http://t10.nuomi.com/webapp/na/topten?from=fr_na_t10tab&sizeLimit=8&version=2&needstorecard=1&areaId=100010000&location=39.989430,116.324470&bn_aid=ios&bn_v=5.13.0&bn_chn=com_dot_apple"];
            }
            FYWebViewController *web0 = [[FYWebViewController alloc]init];
            [web0 setURL:url];
            web0.name = [new objectForKey:@"adv_title"];
            web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
        }
    
    if (indexPath.section == 9)
    {
        if (indexPath.row > 0 && indexPath.row <= _likeArray.count)
        {
            FYShopTuanModel *shopM = _likeArray[indexPath.row - 1];
            
            NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
            NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",shopM.deal_id];
            FYItemController *item = [[FYItemController alloc] init];
            
            item.HttpArg = httpArg;
            item.httpUrl = httpUrl;
            item.session = self.session;
            
            item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
        }

    }

 
   // UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; //这种是没有点击后的阴影效果
    
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    
}

#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

#pragma mark - 手势点击跳转页面

-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.banners[index];
    //NSInteger adv_row = [[dic objectForKey:@"adv_row"] integerValue];
    NSString *cont = dic[@"cont"];
    NSString *name = @"推荐";
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound) {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
        
    }
    [web0 setURL:url];
    web0.name = name;
    
    //NSString *conturl = [NSString getComponentUrl:cont];//不知道为什么找不到..bug？
    //[self gotoViewControllerWithType:goto_type withCont:cont];
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转

}


-(void)didSelectedHomeMenuCellAtIndex:(NSInteger)index
{
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];

    url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
    [web0 setURL:url];
    
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
}

//到店付下面
-(void)didSelectedHomeBlock2AtIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.activityGroup[@"listInfo"][index];
    //NSInteger adv_row = [[dic objectForKey:@"adv_row"] integerValue];
    NSString *cont = dic[@"link"];
    NSString *name = dic[@"title"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];

    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound) {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
            url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
     
    }
    [web0 setURL:url];
    web0.name = name;

    //NSString *conturl = [NSString getComponentUrl:cont];//不知道为什么找不到..bug？
    //[self gotoViewControllerWithType:goto_type withCont:cont];
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转

}

//精选服务
-(void)didSelectedSevenAtIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.hotService.listInfo[index];
    //NSInteger adv_row = [[dic objectForKey:@"adv_row"] integerValue];
    NSString *cont = dic[@"link"];
    NSString *name = dic[@"title"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound) {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
        
    }
    [web0 setURL:url];
    web0.name = name;
    
    //NSString *conturl = [NSString getComponentUrl:cont];//不知道为什么找不到..bug？
    //[self gotoViewControllerWithType:goto_type withCont:cont];
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
    
}

//休闲娱乐
-(void)didSelectedHomeBlock3AtIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.entertainment.listInfo[index];
    NSString *cont = [dic objectForKey:@"link"];
    NSString *name = [dic objectForKey:@"title"];
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
    }
    [web0 setURL:url];
    web0.name = name;

    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
}

//休闲娱乐 划窗
-(void)didSelectedEbannerViewCellIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.entertainment.banner[index];
    NSString *cont = [dic objectForKey:@"link"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
    }
    [web0 setURL:url];
    
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
}

//美食
-(void)didSelectedHomeMeiAtIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.meishiGroup.listInfo[index];
    NSString *cont = [dic objectForKey:@"link"];
    NSString *name = [dic objectForKey:@"title"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
    }
    [web0 setURL:url];
    web0.name = name;
    
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
}

//美食 划窗
-(void)didSelectedMbannerViewCellIndex:(NSInteger)index
{
    NSDictionary *dic = _homeGroupM.meishiGroup.banner[index];
    NSString *cont = [dic objectForKey:@"link"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else
    {
        url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
    }
    [web0 setURL:url];
    
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
}

//最下划窗
-(void)didSelectedFiveViewCellIndex:(NSInteger)index
{
    
    NSDictionary *dic = _homeGroupM.hotService.banner[index];
    NSString *cont = [dic objectForKey:@"link"];
    
    NSURL *url;
    FYWebViewController *web0 = [[FYWebViewController alloc]init];
    
    NSRange range0 = [cont rangeOfString:@"component?url="];
    NSRange range1 = [cont rangeOfString:@"url="];
    //NSRange range2 = [cont rangeOfString:@"&shareurl="];
    
    if (range0.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range0.location+range0.length];
        subStr = [subStr stringByRemovingPercentEncoding];//换格式
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        url = [NSURL URLWithString: strUrl];
        
    }else if (range1.location != NSNotFound) {
        NSString *subStr = [cont substringFromIndex:range1.location+range1.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        
        NSString *strUrl = subStr;
        strUrl = [strUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//因为网址出现中文 故加上这条 将其中中文转码 放到URL中
        
        url = [NSURL URLWithString: strUrl];
        
        NSLog(@"%@",[NSURL URLWithString: strUrl]);
        
    }/* else if (range2.location != NSNotFound) {
      NSString *subStr = [cont substringFromIndex:range2.location+range2.length];
      subStr = [subStr stringByRemovingPercentEncoding];
      url = [NSURL URLWithString: subStr];
      
      }*/else
      {
          url = [NSURL URLWithString: @"http://m.dianying.baidu.com/cms/activity/wap/high_na.html/214168361439?sfrom=newnuomi&from=webapp&kehuduan=1&sub_channel=nuomi_block_wap_ryjp&hasshare=0&shareurl="];
      }
    web0.name = @"活动精选";
    [web0 setURL:url];
    
    
    web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
    
}


#pragma mark - 数据读取

//获取数据2.0
-(void)getHotData2
{
    
    NSString *urlStr = @"http://app.nuomi.com/naserver/home/homepage?appid=ios&bduss=&channel=com_dot_apple&cityid=600060000&compId=index&compV=3.1.6&cuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&device=iPhone&ha=5&lbsidfa=DBBA76B9-1612-410D-B250-E76FD82CAA28&location=29.988420%2C120.532080&logpage=Home&net=wifi&os=9.2&page_type=component&power=0.67&sheight=1334&sign=07fff432095a152eafe04f06e288fe35&swidth=750&terminal_type=ios&timestamp=1458388033566&tn=ios&uuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&v=6.4.0&wifi=%5B%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D%5D&wifi_conn=%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D";
    
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    //[request addValue: @"2a3e3ab9a95e410b8981b180f54605af" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              NSLog(@"错误: %@%ld", error.localizedDescription, error.code);
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败2 ");
                                                  //[SVProgressHUD showInfoWithStatus:error.description];
                                                [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                          } else {
                                              
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                              _homeGroupM = [MTLJSONAdapter modelOfClass:[FYHomeGroupModel class] fromJSONDictionary:jsonObject[@"data"] error:nil];
                                              
                                              _topenModel = _homeGroupM.topten;
                                              
                                              //FYHomeActivityListInfoModel *activity = _homeGroupM.activityGroup[@"listInfo"][1];
                                              //NSArray *adf = _homeGroupM.daoDianfu;
                                              //NSLog(@"%@",_homeGroupM);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新成功2 ");
                                                [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
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
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                          } else {
                                              //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                              //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                  
                                                  FYHomeShopModel *homeShopM = [MTLJSONAdapter modelOfClass:[FYHomeShopModel class] fromJSONDictionary:jsonObject[@"data"] error:nil];
                                                  _likeArray = [[NSMutableArray alloc] initWithArray:homeShopM.tuan_list];

                                                dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新成功3 ");
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                              
                                              
                                          }
                                      }];
    [dataTask resume];
}

#pragma  mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}


@end
