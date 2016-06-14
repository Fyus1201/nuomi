//
//  FYDengluViewController.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/17.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYDengluViewController.h"
#import "FYWebViewController.h"

@interface FYDengluViewController ()

@property (weak, nonatomic) IBOutlet UIView *viewz;

@property (weak, nonatomic) IBOutlet UIView *view0;
@property (weak, nonatomic) IBOutlet UIView *view1;

@end

@implementation FYDengluViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initNav];
    [self initData];
    [self addPanRecognizer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 入出 设置
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

 - (void)viewDidAppear:(BOOL)animated
 {
 [super viewDidAppear:animated];
 
  }

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated//考虑到滑动推出，另外加两个进行过度
{
     [super viewDidDisappear:animated];
}

- (void)addPanRecognizer {
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(OnCloseBtn:)];
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:swipeRecognizer];
}

-(void)initNav
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    //退出
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(20, 30, 20, 20);
    [closeBtn setImage:[UIImage imageNamed:@"icon_nav_quxiao_normal"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(OnCloseBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:closeBtn];
    //标题
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/2-75, 30, 150, 25)];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.text = @"短信验证登陆";
    [backView addSubview:titleLabel];
    
    UIButton *zhuceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuceBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 30, 50, 25);
    /*设置按钮不是用这些。。。*/
    //zhuceBtn.titleLabel.text = @"注册";
    //zhuceBtn.titleLabel.backgroundColor = [UIColor redColor];
    //zhuceBtn.titleLabel.textColor = [UIColor redColor];
    [zhuceBtn setTitle: @"注册" forState:UIControlStateNormal];
    [zhuceBtn setTitleColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9]forState:UIControlStateNormal];
    zhuceBtn.contentHorizontalAlignment =UIControlContentHorizontalAlignmentCenter;
    
    [zhuceBtn addTarget:self action:@selector(OnZhuceBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:zhuceBtn];
}

-(void)OnCloseBtn:(UIButton *)sender//推出设置
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)OnZhuceBtn:(UIButton *)sender
{
    NSLog(@"注册");
}
- (IBAction)denglu:(id)sender
{
    //abort();//退出//在plist添加屬性Application does not run in background = YES
    //exit(0);
    
}

-(void)initData
{
    self.viewz.layer.borderWidth = 1.0;//边框线
    self.viewz.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
    
    self.view0.layer.borderWidth = 0.5;//边框线
    self.view0.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
    
    self.view1.layer.borderWidth = 0.5;//边框线
    self.view1.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
    
}

@end
