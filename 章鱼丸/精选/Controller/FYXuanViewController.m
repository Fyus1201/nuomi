//
//  FYYuanViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYXuanViewController.h"
#import "FYItemController.h"
#import "FYWebViewController.h"
#import "FYTopView.h"

#import "FYShuaxingHeader.h"
#import "FYSearchViewController.h"
#import "FYDengluViewController.h"

#import "FYHomeTwoCell.h"
#import "FYTuijianTableViewCell.h"
#import "FYBiaotiTableViewCell.h"
#import "FYTuanTableViewCell.h"

#import <SVProgressHUD.h>

@interface FYXuanViewController ()<UITableViewDataSource,UITableViewDelegate,FYBiaotiTableViewCellDelegate,FYTopViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *_maskView;
    FYTopView *_topView;
    
    NSInteger _bigSelectedIndex;
    NSInteger _smallSelectedIndex;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) FYHomeTwoCell *cell2;
@property (nonatomic, strong) NSMutableArray *twoArray;

@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataShoplist;
@property (nonatomic, strong) NSMutableArray *dataTuanlist;
@property (nonatomic, strong) NSMutableArray *ledTuanlist;

@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;

@property (nonatomic, strong) NSMutableArray *topArray;

@end

@implementation FYXuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    _dataTuanlist = [[NSMutableArray alloc]init];
    //_dataShoplist = [[NSMutableArray alloc]init];
    _ledTuanlist = [[NSMutableArray alloc]init];
    NSString *plistPath1 = [[NSBundle mainBundle]pathForResource:@"twoData" ofType:@"plist"];
    self.twoArray = [[NSMutableArray alloc]initWithContentsOfFile:plistPath1];
    
    [self setupnav];
    [self initTableview];
    
    [self initScrollView];
    [self initAdvView];
    [self initMaskView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 启动动画

-(void)initAdvView
{
    _yourSuperView = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
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


#pragma mark - 初始化表格
-(void)initTableview
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    /*
    self.tableView.layer.borderWidth = 1;
    self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];//设置列表边框
    self.tableView.separatorColor = [UIColor redColor];//设置行间隔边框
    */
    //self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"#6a2d00"] CGColor];
    //不显示分割线
    //self.tableView.separatorStyle = UITableViewCellEditingStyleNone;

    self.tableView.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9] CGColor];
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib1 = [UINib nibWithNibName:@"FYTuanTableViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"xtuanCell"];
    
    [self.tableView registerClass:[FYBiaotiTableViewCell class] forCellReuseIdentifier:@"xbiaotiCell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"xcell"];
    
    [self setCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    [self setupTableView];//初始化下拉刷新(基于tableview需要先初始化tableview)
    
}

- (void)setCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    //[self setupnav];//初始化头部
    [self.cell2 addTimer];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.cell2 closeTimer];
    
}

#pragma mark - 初始化刷新

-(void)setupTableView
{
    self.tableView.mj_header = [FYShuaxingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];

}

-(void)loadNewData
{
    [self getShangChangData];
    [self getTuanData];
}

#pragma mark - 悬浮窗

-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(-0.5, 0, [UIScreen mainScreen].bounds.size.width+1, 35)];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.layer.borderWidth = 0.5;//边框线
    self.scrollView.layer.borderColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.9].CGColor;
    
    [self.view addSubview:self.scrollView];
    
    NSArray *filterName = @[@"全部",@"全城热门",@"默认排序",@"筛选"];
    //筛选
    for (int i = 0; i < filterName.count; i++)
    {
        //文字
        UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        filterBtn.frame = CGRectMake(i*[UIScreen mainScreen].bounds.size.width/filterName.count, 0, [UIScreen mainScreen].bounds.size.width/filterName.count-15, 40);
        filterBtn.tag = 200+i;
        filterBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [filterBtn setTitle:filterName[i] forState:UIControlStateNormal];
        //[filterBtn setTitle:filterName[i] forState:UIControlStateSelected];
        
        [filterBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [filterBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9] forState:UIControlStateSelected];

        [filterBtn addTarget:self action:@selector(OnFilterBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:filterBtn];
        
        //三角
        UIButton *sanjiaoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sanjiaoBtn.frame = CGRectMake((i+1)*[UIScreen mainScreen].bounds.size.width/filterName.count-15, 16, 8, 7);
        sanjiaoBtn.tag = 220+i;
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_sms_open"] forState:UIControlStateNormal];
        [sanjiaoBtn setImage:[UIImage imageNamed:@"icon_sms_close"] forState:UIControlStateSelected];
        [self.scrollView addSubview:sanjiaoBtn];
    }

    
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY > 0)
    {
        self.scrollView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 35);
        
    }else if (offsetY <= 0)
    {
        float y = offsetY ;
        self.scrollView.frame = CGRectMake(0, 0-y, [UIScreen mainScreen].bounds.size.width, 35);
    }
    
    // NSLog(@"%f   与    %f",offsetY,self.tableView.bounds.size.height);
    
}

#pragma mark - 初始化头部
-(void)setupnav
{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];//背景颜色
    //右边按钮
    UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-02"] forState:UIControlStateNormal];
    EBtn.frame = CGRectMake(0, 0 ,20, 20);
    [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:EBtn];
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"home-10-04"] forState:UIControlStateNormal];
    XBtn.frame = CGRectMake(0, 0, 24, 24);
    [XBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:XBtn];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    self.navigationItem.title = @"精选品牌";

    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

#pragma mark - 右边的按钮
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
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (_dataTuanlist)
    {
        return 1+_dataTuanlist.count;
    }else
    {
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (_dataShoplist)
        {
            return 2;
        }else
        {
            return 1;
        }
    }else
    {
        BOOL led = [_ledTuanlist[section-1] boolValue];
        if (led == YES)
        {
            return 4;
        }else
        {
           return 1+[_dataTuanlist[section-1][@"tuan_list"] count];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 30;
        }else
        {
            return 200;
        }
        
    }else
    {
        if (indexPath.row == 0)
        {
            if ([_dataTuanlist[indexPath.section-1][@"payAtshop"] count] > 1)
            {
                return 100;
            }else
            {
                return 60;
            }
        }else if (indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section-1] boolValue];
            if (led == NO)
            {
                return 80;
            }else
            {
                return 40;
            }
        }else
        {
            return 80;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (section == 0)
    {
        return 35;
    }else
    {
        return 10;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            
            static NSString *cellIndentifier = @"xcell00";
            self.cell2 = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if(self.cell2 == nil)
            {
                self.cell2 = [[FYHomeTwoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier twoArray:self.twoArray];
            }
            
            self.cell2.selectionStyle = UITableViewCellSelectionStyleNone;
            return self.cell2;
        }else
        {
            static NSString *cellIndentifier = @"xcell01";
            FYTuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];

            if (cell == nil)
            {
                cell = [[FYTuijianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_dataShoplist];

            }
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
            //cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else
    {
        if (indexPath.row == 0)
        {
            FYBiaotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xbiaotiCell"];
            [cell setAct:_dataTuanlist[indexPath.section-1]];
            cell.nsn = indexPath.section-1;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        
        }else if(indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section-1] boolValue];
            if (led == YES)
            {
                long tuan = [_dataTuanlist[indexPath.section-1][@"tuan_list"] count]-2;
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xcell" forIndexPath:indexPath];
                cell.textLabel.text = [NSString stringWithFormat:@"其他%ld个团购",tuan];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
                return cell;
            }else
            {
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"tuan_list"];
                NSArray * keys =[tuanlist allKeys];//转化成数组
                NSDictionary *currentTuan = [tuanlist objectForKey:keys[indexPath.row-1]];
                
                FYTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xtuanCell"];
                
                [cell setAct:currentTuan];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;

            }
        }else
        {
            NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"tuan_list"];
            NSArray * keys =[tuanlist allKeys];//转化成数组
            NSDictionary *currentTuan = [tuanlist objectForKey:keys[indexPath.row-1]];
            
            FYTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"xtuanCell" ];
            
            [cell setAct:currentTuan];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;

        }
    }
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld", (long)indexPath.section,(long)indexPath.row);//row 行 section 段
    if (indexPath.section == 0)
    {
        
    }else
    {
        if(indexPath.row == 0)
        {
            
        }else if(indexPath.row == 3)
            {
                BOOL led = [_ledTuanlist[indexPath.section-1] boolValue];
                if (led == YES)
                {
                    NSNumber *led = [NSNumber numberWithBool:NO];
                    [_ledTuanlist removeObjectAtIndex:indexPath.section-1];
                    [_ledTuanlist insertObject:led atIndex:indexPath.section-1];
                    
                    [self.tableView reloadData];
                }else
                {
                    NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"tuan_list"];
                    NSArray * keys =[tuanlist allKeys];//转化成数组
                    
                    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
                    NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",keys[indexPath.row-1]];
                    FYItemController *item = [[FYItemController alloc] init];
                    
                    item.HttpArg = httpArg;
                    item.httpUrl = httpUrl;
                    item.session = self.session;
                    
                    item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
                    [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
                }
            }else
            {
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"tuan_list"];
                NSArray * keys =[tuanlist allKeys];//转化成数组
                
                NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
                NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",keys[indexPath.row-1]];
                FYItemController *item = [[FYItemController alloc] init];
                
                item.HttpArg = httpArg;
                item.httpUrl = httpUrl;
                item.session = self.session;
                
                item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
                [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
            }
    }

    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    
}

//自定义的section的头部 或者 底部

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
    
    headerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    return headerView;
}

#pragma mark = 手势
- (void)didSelectedBiaotiAtIndex:(NSInteger)index
{
    if (index >=200)
    {
        FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
        
        //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
        [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
    }else
    {
        int tag = (int)index - 100;
        
        NSString *strUrl = _dataTuanlist[tag][@"poi_id"];
        NSString *urlStr = [NSString stringWithFormat:@"http://www.nuomi.com/cps/redirect?cid=openapi&app_id=f3ccb59dd6acd514fed83d286ef9dbc6&url=http%%3A%%2F%%2Fm.nuomi.com%%2Fmerchant%%2F%@",strUrl];
        NSURL *url = [NSURL URLWithString: urlStr];
        FYWebViewController *web0 = [[FYWebViewController alloc]init];
        [web0 setURL:url];
        web0.name = _dataTuanlist[tag][@"poi_name"];
        web0.LED = NO;
        web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
        [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
    }
}

#pragma mark - 上栏
-(void)OnFilterBtn:(UIButton *)sender
{
    if (sender.selected == YES)
    {
        sender.selected = NO;
        UIButton *sjBtn = (UIButton *)[self.scrollView viewWithTag:sender.tag+20];
        sjBtn.selected = NO;
        _maskView.hidden = YES;
    }else
    {
        for (int i = 0; i < 4; i++)//通过tag修改状态  self.scrollView表示其所在位置
        {
            UIButton *btn = (UIButton *)[self.scrollView viewWithTag:200+i];
            UIButton *sanjiaoBtn = (UIButton *)[self.scrollView viewWithTag:220+i];
            btn.selected = NO;
            sanjiaoBtn.selected = NO;
        }
        
        if (sender.tag-200 == 0)
        {
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"topData0" ofType:@"plist"];
            NSMutableArray *big = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            
            [_topView setTopArray:_topArray];
            [_topView setBigGroupArray:big];
        }else if (sender.tag-200 == 1)
        {
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"topData1" ofType:@"plist"];
            NSMutableArray *big = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            
            [_topView setTopArray:_topArray];
            [_topView setBigGroupArray:big];
        }else if (sender.tag-200 == 2)
        {
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"topData2" ofType:@"plist"];
            NSMutableArray *big = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            
            [_topView setTopArray:_topArray];
            [_topView setBigGroupArray:big];
        }else
        {
            NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"topData3" ofType:@"plist"];
            NSMutableArray *big = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
            
            [_topView setTopArray:_topArray];
            [_topView setBigGroupArray:big];
        }
        
        sender.selected = YES;
        UIButton *sjBtn = (UIButton *)[self.scrollView viewWithTag:sender.tag+20];
        sjBtn.selected = YES;
        _maskView.hidden = NO;
    }

}

//遮罩页
-(void)initMaskView
{
    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 35, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-35-49)];
    //    _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+40, screen_width, 0)];
    _maskView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.view addSubview:_maskView];
    _maskView.hidden = YES;
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapMaskView:)];
    tap.delegate = self;
    [_maskView addGestureRecognizer:tap];
    
    _topView = [[FYTopView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, _maskView.frame.size.height-350)];
    _topView.delegate = self;
    [_maskView addSubview:_topView];
    
    _topArray = [[NSMutableArray alloc] init];//纪录
    for (int i = 0; i < 4; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [_topArray addObject:indexPath];
    }
}

-(void)OnTapMaskView:(UITapGestureRecognizer *)sender
{
    _maskView.hidden = YES;
    for (int i = 0; i < 4; i++)//通过tag修改状态  self.scrollView表示其所在位置
    {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:200+i];
        UIButton *sanjiaoBtn = (UIButton *)[self.scrollView viewWithTag:220+i];
        btn.selected = NO;
        sanjiaoBtn.selected = NO;
    }
}


#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //吃掉tableview的点击事件(会吃掉interactivePopGestureRecognizer手势，包括父视图)
    if (gestureRecognizer != self.navigationController.interactivePopGestureRecognizer)
    {
        if ([touch.view isKindOfClass:[UITableView class]])
        {
            //NSLog(@"111111");
            return NO;
        }
        if ([touch.view.superview isKindOfClass:[UITableView class]])
        {
            //NSLog(@"22222");
            return NO;
        }
        if ([touch.view.superview.superview isKindOfClass:[UITableView class]])
        {
            //NSLog(@"33333");
            return NO;
        }
        if ([touch.view.superview.superview.superview isKindOfClass:[UITableView class]])
        {
            //NSLog(@"44444");
            return NO;
        }
    }

    return YES;
}

#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.navigationController.interactivePopGestureRecognizer)
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
    return YES;
}

#pragma mark - Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name
{
    //NSLog(@"ID:%@  name:%@",ID,name);
    
    _maskView.hidden = YES;
    [_topArray removeObjectAtIndex:[ID integerValue]];
    [_topArray insertObject:indexPath atIndex:[ID integerValue]];

    for (int i = 0; i < 4; i++)//通过tag修改状态  self.scrollView表示其所在位置
    {
        UIButton *btn = (UIButton *)[self.scrollView viewWithTag:200+i];
        UIButton *sanjiaoBtn = (UIButton *)[self.scrollView viewWithTag:220+i];
        btn.selected = NO;
        sanjiaoBtn.selected = NO;
        if ([ID intValue] == 1)
        {
            if (i == [ID intValue])
            {
                if (indexPath.row == 0)
                {
                    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"topData1" ofType:@"plist"];
                    NSArray *big = [[NSMutableArray alloc]initWithContentsOfFile:plistPath];
                    
                    [btn setTitle:big[indexPath.section+1][@"name"] forState:UIControlStateNormal];
                }else
                {
                    [btn setTitle:name forState:UIControlStateNormal];
                }
            }
        }else
        {
            if (i == [ID intValue])
            {
                [btn setTitle:name forState:UIControlStateNormal];
            }
        }
        
    }

}


#pragma mark - 获取数据

//获取top数据
-(void)getShangChangData
{
    
    NSString *urlStr = @"http://180.97.93.28/naserver/search/shopmall?appid=ios&bduss=&channel=com_dot_apple&cityid=600060000&cuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&device=iPhone&ha=5&lbsidfa=DBBA76B9-1612-410D-B250-E76FD82CAA28&locate_city_id=600060000&location=29.988440%2C120.532090&magicNum=908&need_poi_num=1&net=wifi&os=9.3&power=0.71&sheight=1334&sign=d9a049063de037770c351b66917b5bc8&swidth=750&terminal_type=ios&timestamp=1459000431962&tn=ios&uuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&v=6.4.0&wifi=%5B%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D%5D&wifi_conn=%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D";
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    //[request addValue: @"2a3e3ab9a95e410b8981b180f54605af" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败1 ");
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                          } else {

                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                              
                                              _dataShoplist = [[NSMutableArray alloc] initWithArray:jsonObject[@"data"][@"shoplist"]];
                                              
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新成功1 ");
                                                  
                                                  NSIndexSet * nd=[[NSIndexSet alloc]initWithIndex:0];//刷新第1个section
                                                  [self.tableView reloadSections:nd withRowAnimation:UITableViewRowAnimationAutomatic];//局部刷新
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                              
                                              
                                          }
                                      }];
    [dataTask resume];
}

//获tuan数据
-(void)getTuanData
{
    
    NSString *urlStr = @"http://t10.nuomi.com/webapp/na/poisearch?pn=0&pageSize=8&areaId=600060000&bn_v=6.4.0&cuid=11b8d7a591b545b1fdfeadfc0f8d5a277e6ada47&location=29.98842%2C120.53209&sid=&bduss=&baiduid=&compid=&comppage=&tid=&from=&deviceType=ios&ctag=&wifi=%5B%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D%5D&wifi_conn=%7B%22mac%22%3A%2208%3A10%3A79%3Abe%3Ae8%3A00%22%2C%22sig%22%3A99%2C%22ssid%22%3A%22Fyus1201%22%7D&snd_cattag_id=0&district_id=-1&bizarea_id=0&sort_type=0&labelid=0&priceRange=0";
    
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    //[request addValue: @"2a3e3ab9a95e410b8981b180f54605af" forHTTPHeaderField: @"apikey"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request
                                                     completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error) {
                                              NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败2 ");
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [self.tableView.mj_header endRefreshing];
                                              });
                                          } else {
      
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                
                                              if (_dataTuanlist.count >0)
                                              {
                                                  [_dataTuanlist removeAllObjects];
                                              }
                                              _dataTuanlist = [[NSMutableArray alloc] initWithArray:jsonObject[@"data"][@"poilist"]];
   
                                              [_ledTuanlist removeAllObjects];
                                              for (int i = 0;i < [_dataTuanlist count]; i++)
                                              {
                                                  if ([_dataTuanlist[i][@"tuan_list"] count]>=3)
                                                  {
                                                      NSNumber *led = [NSNumber numberWithBool:YES];
                                                      [_ledTuanlist addObject:led];
                                                  }else
                                                  {
                                                      NSNumber *led = [NSNumber numberWithBool:NO];
                                                      [_ledTuanlist addObject:led];
                                                  }
                                              }
                                              
                                              if (_ledTuanlist.count == _dataTuanlist.count)//防止数组错位,快速刷新存在bug
                                              {
                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 刷新成功2 ");
                                                      [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                      [self.tableView reloadData];
                                                      [self.tableView.mj_header endRefreshing];
                                                  });
                                              }else
                                              {
                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 刷新失败2 ");
                                                      [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                      [SVProgressHUD showErrorWithStatus:@"刷新失败"];
                                                      [self.tableView.mj_header endRefreshing];
                                                  });
                                              }

                                              
                                              
                                          }
                                      }];
    [dataTask resume];
}


#pragma mark - 其他

#pragma  mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}

@end