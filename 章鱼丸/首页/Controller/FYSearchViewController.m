//
//  FYSearchViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/24.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYSearchViewController.h"

#import "FYTSearchViewController.h"

#import "FYData.h"
#import "FYDataModel.h"
#import "FYiflyMSCViewController.h"

@interface FYSearchViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *NavView;
@property (nonatomic, strong) UIView *footView;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *history;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation FYSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];

    [self initTableView];
    [self setupnav];
    [self setFoot];
    
    //UIKeyboardWillChangeFrameNotification
    //键盘改变时调用    键盘监听事件
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChangNotAppear:)
                                                name:UIKeyboardDidChangeFrameNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardChangAppear:)
                                                name:UIKeyboardWillChangeFrameNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillAppear:)
                                                name:UIKeyboardWillShowNotification
                                              object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(keyboardWillDisappear:)
                                                name:UIKeyboardWillHideNotification
                                              object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    
    if ([item.searchTerm length] > 0)
    {
        FYTSearchViewController *tuans = [[FYTSearchViewController alloc] init];
        tuans.searchTuan = item.searchTerm;
        [self.navigationController pushViewController:tuans animated:YES];//1.点击，相应跳转
    }
    
    [self initData];
    [self.tableView reloadData];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    item.searchTerm = @"";
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 60, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-120) style:UITableViewStyleGrouped];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    UIPanGestureRecognizer *move = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveTable:)];
    move.delegate = self;
    move.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:move];
    [self.view addSubview:self.tableView];
}
/*
-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -60, [UIScreen mainScreen].bounds.size.width, 60)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    [self.tableView addSubview:self.scrollView];
    
}*/

- (void)initData
{
    self.history = [[NSMutableArray alloc] init];
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    [self.history addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithData:item.historyData]];
}

#pragma mark - 初始化头部
-(void)setupnav
{
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 80)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.NavView];
    
    //搜索
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 30, [UIScreen mainScreen].bounds.size.width-60, 40)];
    _searchBar.placeholder = @"搜索商家或地点";
    _searchBar.keyboardType = UIKeyboardTypeDefault;
    //searchBar.searchBarStyle = UISearchBarStyleDefault;
    //searchBar.barStyle = UIBarStyleDefault;
    
    UIImage *backImage = [self OriginImage:[UIImage imageNamed:@"searchbar_textfield_background_os7"] scaleToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-60, 40)];
    _searchBar.backgroundImage = backImage;
    _searchBar.tintColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    _searchBar.delegate = self;
    
    [_searchBar becomeFirstResponder];
    [self.NavView addSubview:_searchBar];
    
    //退出
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 35, 50, 25);
    [closeBtn setTitle: @"取消" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9]forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.NavView addSubview:closeBtn];
}

#pragma mark - 初始化底部
-(void)setFoot
{
    self.footView = [[UIView alloc]initWithFrame:CGRectMake(-1, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width+1, 60)];
    self.footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footView];
    
    self.footView.backgroundColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.9];
    self.footView.layer.borderWidth = 0.5;//边框线
    self.footView.layer.borderColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.9].CGColor;
    //语音
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60);
    [closeBtn setTitle: @"语音" forState:UIControlStateNormal];

    closeBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;//居中
    [closeBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9]forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(yuying:) forControlEvents:UIControlEventTouchUpInside];
    [self.footView addSubview:closeBtn];
}

-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(-8, 0, size.width+16, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(void)OnCloseBtn:(UIButton *)sender//推出设置
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 搜索事件   UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"就绪");
    //[searchBar setShowsCancelButton:NO animated:YES];
    //self.tableView.allowsSelection=NO;
    //self.tableView.scrollEnabled=NO;
    
    //self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    FYData *item = [[FYDataModel sharedStore] allItems][0];
    
    NSString *searchTerm = searchBar.text;
    [self.history insertObject:searchTerm atIndex:0];//插入一个对象
    //[self.history addObject:searchTerm];
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.history];
    item.historyData = data;
    
    [self.tableView reloadData];
    
    NSLog(@"执行 %@",self.history);
    
    FYTSearchViewController *tuans = [[FYTSearchViewController alloc] init];
    tuans.searchTuan = searchTerm;
    [self.navigationController pushViewController:tuans animated:YES];//1.点击，相应跳转
}

- (void)yuying:(UIButton *)sender
{
    
    FYiflyMSCViewController *iflyMSC = [[FYiflyMSCViewController alloc]init];
    [self presentViewController:iflyMSC animated:YES completion:nil];//1.点击，相应跳转
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.history count]+2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0001;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell110";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"最近搜过";
        cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if (indexPath.row == [self.history count]+1)
    {
        cell.textLabel.text = @"清除历史纪录";
        cell.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:1];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
        return cell;
    }else
    {
        cell.textLabel.text = self.history[indexPath.row-1];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld", indexPath.section,indexPath.row);//row 行 section 段
    
    if (indexPath.row == [self.history count]+1)
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
        _history = [[NSMutableArray alloc] init];
        
        FYData *item = [[FYDataModel sharedStore] allItems][0];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.history];
        item.historyData = data;
        [self.tableView reloadData];
        
    }else if(indexPath.row > 0)
    {
        FYTSearchViewController *tuans = [[FYTSearchViewController alloc] init];
        tuans.searchTuan = self.history[indexPath.row-1];
        [self.navigationController pushViewController:tuans animated:YES];//1.点击，相应跳转
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    }else
    {
    }
    
}

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

/*
#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
       if (self.tableView.contentOffset.y != -20 )
    {
        if (![_searchBar isExclusiveTouch])
        {
            [_searchBar resignFirstResponder];
            
            self.footView.frame = CGRectMake(-1, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width+1, 60);
            self.x = NO;
        }
        
    }

}*/

#pragma  mark - 键盘变化

-(void)keyboardChangAppear:(NSNotification *)notification//开变
{
  // NSLog(@"开变%f",[self keyboardEndingFrameHeight:[notification userInfo]]);
    
    CGRect oldFrame = CGRectMake(-1, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width+1, 60);
    
    CGRect currentFrame = self.footView.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = oldFrame.origin.y - change ;
    //if (currentFrame.origin.y < self.footView.frame.origin.y)
    //{
        self.footView.frame = currentFrame;
    //}

}

-(void)keyboardChangNotAppear:(NSNotification *)notification//变好
{
    //NSLog(@"变好%f",[self keyboardEndingFrameHeight:[notification userInfo]]);
}

-(void)keyboardWillAppear:(NSNotification *)notification//出现
{
    /*
    CGRect oldFrame = CGRectMake(-1, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width+1, 60);
    
    CGRect currentFrame = self.footView.frame;
    CGFloat change = [self keyboardEndingFrameHeight:[notification userInfo]];
    currentFrame.origin.y = oldFrame.origin.y - change ;
    if (currentFrame.origin.y < self.footView.frame.origin.y)
    {
        self.footView.frame = currentFrame;
    }*/
    //NSLog(@"开秀%f",[self keyboardEndingFrameHeight:[notification userInfo]]);

}

-(void)keyboardWillDisappear:(NSNotification *)notification//消失
{

    self.footView.frame = CGRectMake(-1, [UIScreen mainScreen].bounds.size.height-60, [UIScreen mainScreen].bounds.size.width+1, 60);

   // NSLog(@"秀好%f",[self keyboardEndingFrameHeight:[notification userInfo]]);
}


-(CGFloat)keyboardEndingFrameHeight:(NSDictionary *)userInfo//计算键盘的高度
{
    CGRect keyboardEndingUncorrectedFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGRect keyboardEndingFrame = [self.view convertRect:keyboardEndingUncorrectedFrame fromView:nil];
    return keyboardEndingFrame.size.height;
    
}


@end

