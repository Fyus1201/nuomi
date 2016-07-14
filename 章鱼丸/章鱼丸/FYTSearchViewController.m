//
//  FYJingViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTSearchViewController.h"
#import "FYItemController.h"
#import "FYWebViewController.h"

#import "FYShuaxingHeader.h"
#import "FYDengluViewController.h"

#import "FYJBiaotiTableViewCell.h"
#import "FYJTuanTableViewCell.h"

#import "FYData.h"
#import "FYDataModel.h"

#import "JSDropDownMenu.h"
#import <SVProgressHUD.h>

@interface FYTSearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,JSDropDownMenuDataSource,JSDropDownMenuDelegate,UIGestureRecognizerDelegate>
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

@property (nonatomic, strong) NSMutableArray *dataTuanlist;
@property (nonatomic, strong) NSMutableArray *ledTuanlist;

@property (nonatomic, strong) UIView *NavView;
@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *history;

@end

@implementation FYTSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    _dataTuanlist = [[NSMutableArray alloc] init];
    _ledTuanlist = [[NSMutableArray alloc]init];
    
    self.history = [[NSMutableArray alloc] init];
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    [self.history addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:item.historyData]];
    
    [self setupnav];
    [self initTableview];
    [self initDropMenu];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
    self.navigationController.navigationBarHidden = YES;
    /*另外一种方法
    //可以在需要隐藏navigationBar的viewController里面的viewWillAppear添加
    [self.navigationController.view sendSubviewToBack:self.navigationController.navigationBar];
    
    //然后在viewWillDisappear
    [self.navigationController.view bringSubviewToFront:self.navigationController.navigationBar];
    */
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    self.navigationController.navigationBarHidden = NO;
}



#pragma mark - 初始化头部
-(void)setupnav
{
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.NavView];
    
    //搜索
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width-60, 40)];
    _searchBar.placeholder = _searchTuan;
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    //searchBar.searchBarStyle = UISearchBarStyleDefault;
    //searchBar.barStyle = UIBarStyleDefault;
    
    UIImage *backImage = [self OriginImage:[UIImage imageNamed:@"searchbar_textfield_background_os7"] scaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 40)];
    _searchBar.backgroundImage = backImage;
    _searchBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    _searchBar.delegate = self;
    
    [self.NavView addSubview:_searchBar];
    
    //退出
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 35, 50, 25);
    [closeBtn setTitle: @"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9]forState:UIControlStateNormal];
    
    [closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavView addSubview:closeBtn];
}
#pragma mark - 推出机制
-(void)OnCloseBtn:(UIButton *)sender//推出设置
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(-8, 0, size.width+16, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
#pragma mark - 搜索
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    
    [self.history removeAllObjects];
    [self.history addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:item.historyData]];
    
    NSString *searchTerm = searchBar.text;
    [self.history insertObject:searchTerm atIndex:0];//插入一个对象
    //[self.history addObject:searchTerm];
    
    NSSet *historySet = [NSSet setWithArray:self.history];
    
    if (historySet.count == self.history.count)//判断是否重复，set无序，array有序单可以重复
    {
        
    }else
    {
        [self.history removeObject:searchBar.text];//删除重复对象
        NSString *searchTerm = searchBar.text;
        [self.history insertObject:searchTerm atIndex:0];//插入一个对象
    }
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.history];
    item.historyData = data;
    
    _searchBar.placeholder = searchTerm;
    self.searchTuan = searchTerm;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 初始化表格
-(void)initTableview
{
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 115, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-115) style:UITableViewStylePlain];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.layer.borderColor = [[UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9] CGColor];//边框颜色
    
    /*cell预创建*/
    //创建UINib对象,该对象代表包含BNRItemCell的NIB文件
    UINib *nib1 = [UINib nibWithNibName:@"FYJTuanTableViewCell" bundle:nil];
    //通过UINib对象注册相应的NIB文件
    [self.tableView registerNib:nib1 forCellReuseIdentifier:@"jtuancell"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"jcell"];
    
    [self.tableView registerClass:[FYJBiaotiTableViewCell class] forCellReuseIdentifier:@"jbiaotiCell"];
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTable:)];
    move.delegate = self;
    move.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:move];
    
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
    _number = 1;
    NSString *strUrl = [_searchTuan stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    //NSString *httpArg = [NSString stringWithFormat:@"city_id=600060000&location=120.540456%%2C29.987982&radius=10000&page=%d&page_size=10&deals_per_shop=20",_number];
    NSString *httpArg1 = [NSString stringWithFormat:@"city_id=600060000&location=120.540456%%2C29.987982&keyword=%@&radius=3000&page=%d&page_size=10&deals_per_shop=10",strUrl,_number];
    
    [self request: httpUrl withHttpArg: httpArg1];
}

-(void)addNewData
{
    _number++;
    NSString *strUrl = [_searchTuan stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *httpUrl = @"http://apis.baidu.com/baidunuomi/openapi/searchshops";
    //NSString *httpArg = [NSString stringWithFormat:@"city_id=600060000&location=120.576826%%2C29.986709&radius=10000&page=%d&page_size=10&deals_per_shop=20",_number];
    
    NSString *httpArg1 = [NSString stringWithFormat:@"city_id=600060000&location=120.540456%%2C29.987982&keyword=%@&radius=3000&page=%d&page_size=10&deals_per_shop=10",strUrl,_number];
    [self request2: httpUrl withHttpArg: httpArg1];
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _dataTuanlist.count;
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        BOOL led = [_ledTuanlist[section] boolValue];
        if (led == YES)
        {
            return 4;
        }else
        {
            return 1+[_dataTuanlist[section][@"deals"] count];
        }
        
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row == 0)
        {

                return 60;
            
        }else if (indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section] boolValue];
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        
        if (indexPath.row == 0)
        {
            FYJBiaotiTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jbiaotiCell" forIndexPath:indexPath];
            
            [cell setAct:_dataTuanlist[indexPath.section]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            return cell;
            
        }
        else if(indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section] boolValue];
            if (led == YES)
            {
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"jcell" forIndexPath:indexPath];

                long tuan = [_dataTuanlist[indexPath.section][@"deals"] count]-2;
                cell.textLabel.text = [NSString stringWithFormat:@"其他%ld个团购",tuan];
                cell.textLabel.textAlignment = NSTextAlignmentCenter;
                cell.textLabel.font = [UIFont systemFontOfSize:12];
                cell.textLabel.textColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.9];
                
                return cell;
            }else
            {
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section][@"deals"][indexPath.row-1];
                FYJTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jtuancell"];

                [cell setActM:tuanlist];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }
        }else
        {
            NSDictionary *tuanlist = self.dataTuanlist[indexPath.section][@"deals"][indexPath.row-1];
            FYJTuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jtuancell"];
            
            [cell setActM:tuanlist];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld", (long)indexPath.section,(long)indexPath.row);//row 行 section 段

    if (indexPath.row == 0)
    {
        NSString *urlStr = _dataTuanlist[indexPath.section][@"shop_murl"];
        NSURL *url = [NSURL URLWithString: urlStr];
        FYWebViewController *web0 = [[FYWebViewController alloc]init];
        [web0 setURL:url];
        web0.name = _dataTuanlist[indexPath.section][@"shop_name"];
        web0.LED = NO;
        web0.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
        [self.navigationController pushViewController:web0 animated:YES];//1.点击，相应跳转
    }else
    {
        if(indexPath.row == 3)
        {
            BOOL led = [_ledTuanlist[indexPath.section] boolValue];
            if (led == YES)
            {
                NSNumber *led = [NSNumber numberWithBool:NO];
                [_ledTuanlist removeObjectAtIndex:indexPath.section];
                [_ledTuanlist insertObject:led atIndex:indexPath.section];
                
                [self.tableView reloadData];
                
            }else
            {
                NSDictionary *tuanlist = self.dataTuanlist[indexPath.section][@"deals"][indexPath.row-1];
                
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
            NSDictionary *tuanlist = self.dataTuanlist[indexPath.section][@"deals"][indexPath.row-1];
            
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
    if (section == 0)
    {
        return 0.0001;
    }else
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
    
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    
    footerView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    
    return footerView;
}

#pragma mark - 获取数据

-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg
{
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    
    
    //NSLog(@"%@",urlStr);
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
                                                  [self.tableView.mj_header endRefreshing];
                                                  [self.tableView.mj_footer endRefreshing];
                                              });
                                          } else {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              
                                              if ([jsonObject[@"errno"] integerValue] == 0)
                                              {
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
                                                  
                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 刷新成功2 ");
                                                      [self.tableView reloadData];
                                                      if ([jsonObject[@"data"][@"total"] integerValue] <= 10)
                                                      {
                                                          
                                                      }else
                                                      {
                                                          self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(addNewData)];
                                                      }
                                                      
                                                      
                                                      [self.tableView.mj_header endRefreshing];
                                                      
                                                  });

                                              }else
                                              {
                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 输入错误2 ");
                                                      [SVProgressHUD showErrorWithStatus:@"没有找到相关信息"];
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
                                                  NSLog(@" 加载失败2 ");
                                                  [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                                                  [self.tableView reloadData];
                                                  [self.tableView.mj_footer endRefreshing];
                                              });
                                          } else {
                                              NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              
                                              if ([jsonObject[@"errno"] integerValue] == 0)
                                              {
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
                                                      NSLog(@" 加载成功2 ");
                                                      [self.tableView reloadData];
                                                      [self.tableView.mj_footer endRefreshing];
                                                      if ([jsonObject[@"data"][@"total"] integerValue] <= 10*_number)
                                                      {
                                                          [self.tableView.mj_footer endRefreshingWithNoMoreData];
                                                      }
                                                  });

                                              }else
                                              {
                                                  dispatch_async(dispatch_get_main_queue(),^{
                                                      NSLog(@" 加载成功2 ");
                                                      [SVProgressHUD showErrorWithStatus:@"没有找到相关信息"];
                                                      [self.tableView reloadData];
                                                      [self.tableView.mj_footer endRefreshing];
                           
                                                  });

                                              }
                                              
                                              
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
    
    menu = [[JSDropDownMenu alloc] initWithOrigin:CGPointMake(0, 80) andHeight:40];
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

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)moveTable:(UIPanGestureRecognizer *)gr
{
    
    if (![_searchBar isExclusiveTouch])
    {
        [_searchBar resignFirstResponder];
        
    }
}

#pragma  mark - 弹出窗口
-(void)showSuccessHUD:(NSString *)string{
    [SVProgressHUD showInfoWithStatus:string];
}

-(void)showErrorHUD:(NSString *)string{
    [SVProgressHUD showErrorWithStatus:string];
}


@end
