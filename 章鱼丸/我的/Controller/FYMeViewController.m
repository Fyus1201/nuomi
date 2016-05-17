//
//  FYMeViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMeViewController.h"
#import "FYDengluViewController.h"

#import "FYMe0Cell.h"

@interface FYMeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,FYMe0Delegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *NavView;

@property (nonatomic, strong) UIButton *denglu;

@property (nonatomic, strong) UIButton *fenxiang;
@property (nonatomic, strong) UILabel *lab;

@property (nonatomic) BOOL led;

@end

@implementation FYMeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self initTableView];
    
    [self initScrollView];
    
    [self setNav];
    
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}


-(void)setNav
{
    self.NavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    self.NavView.backgroundColor = [UIColor whiteColor];
    self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
    [self.view addSubview:self.NavView];
    self.lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, 40)];
    self.lab.textAlignment = NSTextAlignmentCenter;
    self.lab.text = @"";
    self.lab.textColor = [UIColor blackColor];
    
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
    [self.NavView addSubview:self.fenxiang];
}


-(void)OnZhuceBtn:(UIButton *)sender
{
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
    
    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}



-(void)initScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, -50, [UIScreen mainScreen].bounds.size.width, 50)];
    self.scrollView.backgroundColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    self.scrollView.delegate = self;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    _denglu = [UIButton buttonWithType:UIButtonTypeCustom];
    _denglu.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2-70, 120, 140, 50);
    [_denglu setTitle: @"登陆" forState:UIControlStateNormal];
    [_denglu setTitleColor:[UIColor redColor]forState:UIControlStateNormal];
    _denglu.backgroundColor = [UIColor whiteColor];
    
    [_denglu setTitleColor:[UIColor grayColor]forState:UIControlStateHighlighted];
    
    _denglu.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;//居中

    [_denglu addTarget:self action:@selector(OnZhuceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:_denglu];
    
    [self.tableView addSubview:self.scrollView];
}



-(void)initTableView
{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height+40) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.showsVerticalScrollIndicator = NO;
    //self.tableView.tableHeaderView = self.scrollView;
    [self.view addSubview:self.tableView];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.tableView)
    {
        CGFloat offsetY = self.tableView.contentOffset.y;
        if (offsetY <= 0 && offsetY >= -100)
        {
            self.scrollView.frame = CGRectMake(0, -50 + offsetY / 2, [UIScreen mainScreen].bounds.size.width, 220 - offsetY / 2);
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:0];
            
            if (self.led == NO)
            {
                self.led = YES;
                self.lab.text = @"";
                UIImage *home1008 = [UIImage imageNamed:@"home-10-07"];
                [self.fenxiang setBackgroundImage:home1008 forState:UIControlStateNormal];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
            }
        }
        else if (offsetY < -100)
        {
            [self.tableView setContentOffset:CGPointMake(0, -100)];
        }
        else if (offsetY > 0)
        {
            self.NavView.backgroundColor = [self.NavView.backgroundColor colorWithAlphaComponent:offsetY / 120];
            self.scrollView.frame = CGRectMake(0, -50 + offsetY / 2, [UIScreen mainScreen].bounds.size.width, 220 - offsetY / 2);
            if (self.led == YES)
            {
                self.led = NO;
                self.lab.text = @"我的";
                UIImage *home1008 = [UIImage imageNamed:@"home-10-04"];
                [self.fenxiang setBackgroundImage:home1008 forState:UIControlStateNormal];
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
            }
            
        }
    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }else  if (section == 6)
    {
        return 1;
    }
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 80;
    }else  if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }else
        {
            return 80;
        }
    }else  if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }else
        {
            return 80;
        }
    }else  if (indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }else
        {
            return 80;
        }
    }else  if (indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            return 50;
        }else
        {
            return 80;
        }
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 170;
    } else
    {
        return 3;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell303";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
    }
    
    if (indexPath.section == 0)
    {
        NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"me1Data" ofType:@"plist"];
        NSArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
        
        static NSString *cellIndentifier = @"cell0";
        FYMe0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
        if (cell == nil)
        {
            cell = [[FYMe0Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:array];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        return cell;
    }else
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"订单";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"meData" ofType:@"plist"];
            NSArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
            
            static NSString *cellIndentifier = @"cell11";
            FYMe0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil)
            {
                cell = [[FYMe0Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:array];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"资产";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"me2Data" ofType:@"plist"];
            NSArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
            
            static NSString *cellIndentifier = @"cell21";
            FYMe0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil)
            {
                cell = [[FYMe0Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:array];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 3)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"百度钱包";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else
        {
            NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"me2Data" ofType:@"plist"];
            NSArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
            
            static NSString *cellIndentifier = @"cell31";
            FYMe0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil)
            {
                cell = [[FYMe0Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:array];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 4)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"推荐";
            return cell;
        }else
        {
            NSString *plistPath0 = [[NSBundle mainBundle]pathForResource:@"meData" ofType:@"plist"];
            NSArray *array = [[NSMutableArray alloc]initWithContentsOfFile:plistPath0];
            
            static NSString *cellIndentifier = @"cell41";
            FYMe0Cell *cell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
            if (cell == nil)
            {
                cell = [[FYMe0Cell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier array:array];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            return cell;
        }
    }else if(indexPath.section == 5)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"帮助与反馈";
            return cell;
        }else  if (indexPath.row == 1)
        {
            cell.textLabel.text = @"设置";
            return cell;
        }else
        {
            cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
            return cell;
        }

    }else if(indexPath.section == 6)
    {
        cell.textLabel.text = @"我要开店";
        return cell;
    }else
    {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row];
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"%ld,%ld", indexPath.section,indexPath.row);//row 行 section 段
    
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
    
    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;  //这种是点击的时候有效果，返回后效果消失
    
}

-(void)didSelectedMe0AtIndex:(NSInteger)index
{
    FYDengluViewController *denglu = [[FYDengluViewController alloc]initWithNibName:@"FYDengluViewController" bundle:nil];
    
    //denglu.hidesBottomBarWhenPushed = YES;//隐藏 tabBar 在navigationController结构中
    [self presentViewController:denglu animated:YES completion:nil];//1.点击，相应跳转
}

@end

