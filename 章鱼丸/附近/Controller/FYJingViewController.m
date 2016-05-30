//
//  FYJingViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYJingViewController.h"
#import "FYItemController.h"
#import "FYWebViewController.h"

#import "FYShuaxingHeader.h"

#import "FYSearchViewController.h"
#import "FYDengluViewController.h"

#import "FYTuijianTableViewCell.h"
#import "FYJBiaotiTableViewCell.h"
#import "FYJTuanTableViewCell.h"

#import "JSDropDownMenu.h"
#import <SVProgressHUD.h>

@interface FYJingViewController ()<UITableViewDataSource,UITableViewDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate>
{
    NSMutableArray *_data1;
    NSMutableArray *_data2;
    NSMutableArray *_data3;
    NSMutableArray *_data4;
    
    NSInteger _currentData1Index;
    NSInteger _currentData2Index;
    NSInteger _currentData3Index;
    NSInteger _currentData4Index;
    
    NSInteger _currentData1SelectedIndex;
    
    JSDropDownMenu *menu;
    
    int _number;
    
}
@property (nonatomic) NSURLSession *session;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataShoplist;

@property (nonatomic, strong) NSMutableArray *dataTuanlist;
@property (nonatomic, strong) NSMutableArray *ledTuanlist;

@property (nonatomic, strong) UIView *yourSuperView;
@property (nonatomic, strong) UIImageView *imaView;

@end

@implementation FYJingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    _dataTuanlist = [[NSMutableArray alloc] init];
    _ledTuanlist = [[NSMutableArray alloc]init];
    
    [self setupnav];
    [self initTableview];
    [self initDropMenu];
    
    [self initAdvView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
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


#pragma mark - 初始化表格
-(void)initTableview
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 28, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-48-40) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    /*
     self.tableView.layer.borderWidth = 1;
     self.tableView.layer.borderColor = [[UIColor blackColor] CGColor];//设置列表边框
     self.tableView.separatorColor = [UIColor redColor];//设置行间隔边框
     */
    //self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"#6a2d00"] CGColor];
    //
    //self.tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    /*cell预创建*/
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib1 = [UINib nibWithNibName:@"FYJTuanTableViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"jtuancell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"jcell"];
    
    [self.tableView registerClass:[FYJBiaotiTableViewCell class] forCellReuseIdentifier:@"jbiaotiCell"];
    
    [self.view addSubview:self.tableView];
    [self setupTableView];//初始化下拉刷新(基于tableview需要先初始化tableview)
    
}

#pragma mark - 初始化刷新

-(void)setupTableView
{
    self.tableView.mj_header = [FYShuaxingHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    
    //self.tableView.mj_footer = [FYShuaxingFoot footerWithRefreshingTarget:self refreshingAction:@selector(addNewData)];

    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadNewData
{
    if (_yourSuperView.hidden == YES)
    {

        [self initAdvView];
    }

    
    _number = 1;
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    NSString *httpArg = [NSString stringWithFormat:@"city_id=600060000&location=120.540456%%2C29.987982&radius=10000&page=%d&page_size=10&deals_per_shop=20",_number];
    
    [self request: httpUrl withHttpArg: httpArg];
    [self getShangChangData];
}

-(void)addNewData
{
    _number++;
    
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    NSString *httpArg = [NSString stringWithFormat:@"city_id=600060000&location=120.540456%%2C29.987982&radius=10000&page=%d&page_size=10&deals_per_shop=20",_number];
    
    [self request2: httpUrl withHttpArg: httpArg];
}



#pragma mark - 初始化头部
-(void)setupnav
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];//里面的item颜色
    self.navigationController.navigationBar.translucent = NO;//是否为半透明
    
    //右边按钮
    UIButton *EBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [EBtn setBackgroundImage:[UIImage imageNamed:@"home-10-02"] forState:UIControlStateNormal];
    EBtn.frame = CGRectMake(0, 0, 20, 20);
    [EBtn addTarget:self action:@selector(rightBtnClick1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:EBtn];
    
    UIButton *XBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [XBtn setBackgroundImage:[UIImage imageNamed:@"home-10-04"] forState:UIControlStateNormal];
    XBtn.frame = CGRectMake(0, 0, 24, 24);
    [XBtn addTarget:self action:@selector(rightBtnClick2:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:XBtn];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
    self.navigationItem.title = @"附近";
    self.navigationController.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
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
            return 1+[_dataTuanlist[section-1][@"deals"] count];
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            return 35;
        }else
        {
            return 200;
        }

    }else
    {
        if (indexPath.row == 0)
        {

                return 60;
            
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            static NSString *cellIndentifier = @"jcell00";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier ];
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier ];
            }

            cell.textLabel.text = @"当前：浙江省绍兴市绍兴县秋瑾路";
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
            cell.textLabel.font = [UIFont systemFontOfSize:12];
            cell.textLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];

            return cell;
        }else
        {
            static NSString *cellIndentifier = @"jcell01";
            FYTuijianTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"jcell01"];
            if (cell == nil)
            {
                cell = [[FYTuijianTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:_dataShoplist];
            }
            cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
            //cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }

    }
    else
    {
        
        if (indexPath.row == 0)
        {
            FYJBiaotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jbiaotiCell" forIndexPath:indexPath];
            
            [cell setAct:_dataTuanlist[indexPath.section-1]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
          
            //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"jcell" forIndexPath:indexPath];
            return cell;
            
        }
        else if(indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section-1] boolValue];
            if (led == YES)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"jcell" forIndexPath:indexPath];

                long tuan = [_dataTuanlist[indexPath.section-1][@"deals"] count]-2;
                cell.textLabel.text = [NSString stringWithFormat:@"其他%ld个团购",tuan];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
                
                return cell;
            }else
            {
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"deals"][indexPath.row-1];
                FYJTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jtuancell"];

                [cell setActM:tuanlist];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
        }else
        {
            NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"deals"][indexPath.row-1];
            FYJTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jtuancell"];
            
            [cell setActM:tuanlist];
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
        
    }
    else
    {
        if(indexPath.row == 0)
        {
            NSString *urlStr = _dataTuanlist[indexPath.section-1][@"shop_murl"];
            NSURL *url = [NSURL URLWithString: urlStr];
            FYWebViewController *web0 = [[FYWebViewController alloc]init];
            [web0 setURL:url];
            web0.name = _dataTuanlist[indexPath.section-1][@"shop_name"];
            web0.LED = NO;
            web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
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
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"deals"][indexPath.row-1];
                
                NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
                NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",tuanlist[@"deal_id"]];
                FYItemController *item = [[FYItemController alloc] init];
                
                item.HttpArg = httpArg;
                item.httpUrl = httpUrl;
                item.session = self.session;
                NSLog(@"%@",tuanlist);
                item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
                [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
                
            }
        }else
        {
            NSDictionary *tuanlist = self.dataTuanlist[indexPath.section-1][@"deals"][indexPath.row-1];
            
            NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/dealdetail";
            NSString *httpArg = [[NSString alloc] initWithFormat:@"deal_id=%@",tuanlist[@"deal_id"]];
            FYItemController *item = [[FYItemController alloc] init];
            
            item.HttpArg = httpArg;
            item.httpUrl = httpUrl;
            item.session = self.session;
            NSLog(@"%@",tuanlist);
            item.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
            [self.navigationController pushViewController:item animated:YES];//1.点击，相应跳转
        }
    }
    
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    
}

//自定义的section的头部 或者 底部
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 5;
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
                                              //NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                              //NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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


-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
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
                                              NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败2 ");
                                                  [self performSelector:@selector(removeAdvImage) withObject:nil afterDelay:0];
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_header endRefreshing];
                                                  [self.tableView.mj_footer endRefreshing];
                                              });
                                          } else {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

                                             [_dataTuanlist removeAllObjects];
                                             [_dataTuanlist addObjectsFromArray: jsonObject[@"data"][@"shops"]];

                                              
                                              [_ledTuanlist removeAllObjects];
                                              for (int i = 0;i < [_dataTuanlist count]; i++)
                                              {
                                                  if ([_dataTuanlist[i][@"deals"] count]>=3)
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
                                                      self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addNewData)];
                                                      
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

-(void)request2: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
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
                                              NSLog(@"Httperror: %@%ld", error.localizedDescription, (long)error.code);
                                              dispatch_async(dispatch_get_main_queue(),^{
                                                  NSLog(@" 刷新失败2 ");
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_footer endRefreshing];
                                              });
                                          } else {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              
                                              [_dataTuanlist addObjectsFromArray: jsonObject[@"data"][@"shops"]];
                                       
                                              [_ledTuanlist removeAllObjects];
                                              for (int i = 0;i < [_dataTuanlist count]; i++)
                                              {
                                                  if ([_dataTuanlist[i][@"deals"] count]>=3)
                                                  {
                                                      NSNumber *led = [NSNumber numberWithBool:YES];
                                                      [_ledTuanlist addObject:led];
                                                  }else
                                                  {
                                                      NSNumber *led = [NSNumber numberWithBool:NO];
                                                      [_ledTuanlist addObject:led];
                                                  }
                                                  
                                              }

                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 刷新成功2 ");
                                                      
                                                      [self.tableView reloadData];
                                                      [self.tableView.mj_footer endRefreshing];
                                                      if (_number == 10)
                                                      {
                                                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                      }
                                                  });
                                              
                                          }
                                      }];
    [dataTask resume];
}

#pragma mark - DropMenu

-(void)initDropMenu
{
    // 指定默认选中
    _currentData1Index = 1;
    _currentData1SelectedIndex = 1;
    
    NSArray *food = @[@"全部美食", @"火锅", @"川菜", @"西餐", @"自助餐"];
    NSArray *travel = @[@"全部旅游", @"周边游", @"景点门票", @"国内游", @"境外游"];
    
    _data1 = [NSMutableArray arrayWithObjects:@{@"title":@"美食", @"data":food}, @{@"title":@"旅游", @"data":travel}, nil];
    _data2 = [NSMutableArray arrayWithObjects:@"全城", @"500m", @"1km", @"3km", @"5km", nil];
    _data3 = [NSMutableArray arrayWithObjects:@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高", nil];
    _data4 = [NSMutableArray arrayWithObjects:@"不限人数", @"单人餐", @"双人餐", @"3~4人餐", nil];
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:40];
    menu.indicatorColor = [UIColor colorWithRed:175.0f/255.0f green:175.0f/255.0f blue:175.0f/255.0f alpha:1.0];
    menu.separatorColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];//中间线
    menu.textColor = [UIColor colorWithRed:83.f/255.0f green:83.f/255.0f blue:83.f/255.0f alpha:1.0f];
    menu.dataSource = self;
    menu.delegate = self;
    
    [self.view addSubview:menu];
}

- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu//数量
{
    return 4;
}

//格式
-(BOOL)displayByCollectionViewInColumn:(NSInteger)column
{
    
    if (column==3)
    {
        
        return YES;
    }
    
    return NO;
}

-(BOOL)haveRightTableViewInColumn:(NSInteger)column
{
    
    if (column==0)
    {
        return YES;
    }
    return NO;
}

-(CGFloat)widthRatioOfLeftColumn:(NSInteger)column
{
    
    if (column==0)
    {
        return 0.3;
    }
    
    return 1;
}

-(NSInteger)currentLeftSelectedRow:(NSInteger)column
{
    
    if (column==0)
    {
        
        return _currentData1Index;
        
    }
    if (column==1)
    {
        
        return _currentData2Index;
    }
    if (column==2)
    {
        
        return _currentData3Index;
    }
    if (column==3)
    {
        
        return _currentData4Index;
    }
    return 0;
}

- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow
{
    if (column==0)
    {
        if (leftOrRight==0)
        {
            return _data1.count;
        } else
        {
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] count];
        }
    } else if (column==1)
    {
        
        return _data2.count;
        
    } else if (column==2)
    {
        
        return _data3.count;
    } else if (column==3)
    {
        
        return _data4.count;
    }
    
    return 0;
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column
{
    
    switch (column)
    {
        case 0: return [[_data1[_currentData1Index] objectForKey:@"data"] objectAtIndex:_currentData1SelectedIndex];
            break;
        case 1: return _data2[_currentData2Index];
            break;
        case 2: return _data3[_currentData3Index];
            break;
        case 3: return _data4[_currentData4Index];
            break;
        default:
            return nil;
            break;
    }
    
}

- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath//产生
{
    if (indexPath.column==0)
    {
        if (indexPath.leftOrRight==0)
        {
            NSDictionary *menuDic = [_data1 objectAtIndex:indexPath.row];
            return [menuDic objectForKey:@"title"];
        } else
        {
            NSInteger leftRow = indexPath.leftRow;
            NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
            return [[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row];
        }
    } else if (indexPath.column==1)
    {
        return _data2[indexPath.row];
        
    } else if (indexPath.column==2)
    {
        
        return _data3[indexPath.row];
        
    }else
    {
        return _data4[indexPath.row];
    }
}

//此出可以和其他一起使用
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath//点击
{
    
    if (indexPath.column == 0)
    {
        if(indexPath.leftOrRight==0)
        {
            _currentData1Index = indexPath.row;
            return;
        }
        NSInteger leftRow = indexPath.leftRow;
        NSDictionary *menuDic = [_data1 objectAtIndex:leftRow];
        NSLog(@"%@",[[menuDic objectForKey:@"data"] objectAtIndex:indexPath.row]);
        
    } else if(indexPath.column == 1)
    {
        _currentData2Index = indexPath.row;
        NSLog(@"%@",_data2[_currentData2Index]);
        
    } else if(indexPath.column == 2)
    {
        _currentData3Index = indexPath.row;
        NSLog(@"%@",_data3[_currentData3Index]);
        
    } else
    {
        _currentData4Index = indexPath.row;
        NSLog(@"%@",_data4[_currentData4Index]);
    }
    
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
