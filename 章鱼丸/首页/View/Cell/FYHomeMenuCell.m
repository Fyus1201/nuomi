//
//  TSHomeMenuCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#define TAG 1000

#import "FYHomeMenuCell.h"
#import "FYMenuBtnView.h"

@interface FYHomeMenuCell()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIView *_backView1;
    UIView *_backView2;
    UIView *_backView3;
    
    UIView *_backView0;//用来实现滚动效果
    UIView *_backView4;
    
    UIPageControl *_pageControl;
}

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation FYHomeMenuCell

+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray
{
    static NSString *cellID = @"cell0";
    
    FYHomeMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil) {
        cell = [[FYHomeMenuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID menuArray:menuArray];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier menuArray:(NSArray *)menuArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        _backView1 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _backView2 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*2, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _backView3 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        
        scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*5, 180);
        
        scrollView.pagingEnabled = YES;//当值是 YES 会自动滚动到 subview 的边界，默认是NO
        scrollView.contentOffset = CGPointMake(scrollView.frame.size.width , 0);
        scrollView.delegate = self;
        
        scrollView.showsHorizontalScrollIndicator = NO;//滚动条是否可见 水平
        scrollView.showsVerticalScrollIndicator=NO;//滚动条是否可见 垂直
        
        /* 用来实现滚动效果的附加view */
        _backView0 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        _backView4 = [[UIView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*4, 0, [UIScreen mainScreen].bounds.size.width, 180)];
        [scrollView addSubview:_backView0];
        [scrollView addSubview:_backView4];
        
        /* ～ */
        NSArray *backView = @[_backView1,_backView2,_backView3];
        
        [scrollView addSubview:_backView1];
        [scrollView addSubview:_backView2];
        [scrollView addSubview:_backView3];
        
        [self addSubview:scrollView];
        
        for(int i = 0; i < [menuArray count]; i++)
        {
            CGRect frame = CGRectMake(i%5*[UIScreen mainScreen].bounds.size.width/5, (i/5)%2*80, [UIScreen mainScreen].bounds.size.width/5, 80);
            NSString *title = [menuArray[i] objectForKey:@"title"];
            NSString *imagestr = [menuArray[i] objectForKey:@"image"];
                
            FYMenuBtnView *btnView = [[FYMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
            btnView.tag = TAG + i;

            [backView[i/10] addSubview:btnView];

            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            
            [btnView addGestureRecognizer:tap];
            /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
            self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
            self.pressRecognizer.minimumPressDuration = 0.05;
            
            self.pressRecognizer.delegate = self;//用来实现长按不独占
            self.pressRecognizer.cancelsTouchesInView = NO;
            
            [btnView addGestureRecognizer:self.pressRecognizer];
        }
        
        for(int i = 0; i < 10; i++)
        {
            CGRect frame = CGRectMake(i%5*[UIScreen mainScreen].bounds.size.width/5, (i/5)%2*80, [UIScreen mainScreen].bounds.size.width/5, 80);
            NSString *title = [menuArray[i] objectForKey:@"title"];
            NSString *imagestr = [menuArray[i] objectForKey:@"image"];
            
            FYMenuBtnView *btnView = [[FYMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
            btnView.tag = TAG + i;
            
            [_backView4 addSubview:btnView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            
            [btnView addGestureRecognizer:tap];
            /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
            self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
            self.pressRecognizer.minimumPressDuration = 0.05;
            self.pressRecognizer.delegate = self;
            self.pressRecognizer.cancelsTouchesInView = NO;
            
            [btnView addGestureRecognizer:self.pressRecognizer];
        }
        
        for(int i = (int)[menuArray count]-10; i < [menuArray count]; i++)
        {
            CGRect frame = CGRectMake(i%5*[UIScreen mainScreen].bounds.size.width/5, (i/5)%2*80, [UIScreen mainScreen].bounds.size.width/5, 80);
            NSString *title = [menuArray[i] objectForKey:@"title"];
            NSString *imagestr = [menuArray[i] objectForKey:@"image"];
            
            FYMenuBtnView *btnView = [[FYMenuBtnView alloc]initWithFrame:frame title:title imagestr:imagestr];
            btnView.tag = TAG + i;
            
            [_backView0 addSubview:btnView];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
            
            [btnView addGestureRecognizer:tap];
            /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
            self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
            self.pressRecognizer.minimumPressDuration = 0.05;
            self.pressRecognizer.delegate = self;
            self.pressRecognizer.cancelsTouchesInView = NO;
            
            [btnView addGestureRecognizer:self.pressRecognizer];
        }
        
        double cun;
        if([UIScreen mainScreen].bounds.size.width == 375)//375*667
        {
            cun = 2.35;
        }else if([UIScreen mainScreen].bounds.size.width == 414)//414*736
        {
            cun = 2.6;
        }else//[UIScreen mainScreen].bounds.size.width == 320 * 568/480
        {
            cun = 2;
        }

        //底下的 那个显示
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/cun, 160, 0, 20)];
        _pageControl.currentPage = 0;
        _pageControl.numberOfPages = [scrollView.subviews count] -2;
        //self.backgroundColor = [UIColor redColor];
        [self addSubview:_pageControl];
        [_pageControl setCurrentPageIndicatorTintColor:[UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9]];
        [_pageControl setPageIndicatorTintColor:[UIColor grayColor]];
        
    }
    return self;//ScrollView由三个和屏幕等宽的view拼接而成
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView//手指拖动后调用
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;

    _pageControl.currentPage = page-1;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView//拖动结束后调用
{
    CGFloat scrollViewW = scrollView.frame.size.width;
    CGFloat x = scrollView.contentOffset.x;
    int page = (x + scrollViewW/2)/scrollViewW;
    
    if (page == 0)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*([scrollView.subviews count] -2), 0);
    }
    if (page == [scrollView.subviews count] -1)
    {
        scrollView.contentOffset  = CGPointMake(scrollView.frame.size.width*1, 0);
    }
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
        return YES;//长按手势会独占对象，故用代理将他取消独占
}

-(void)longPress:(UITapGestureRecognizer *)sender//长按触发
{

    if (sender.state == UIGestureRecognizerStateBegan)
    {
        sender.view.backgroundColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9];
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        sender.view.backgroundColor = [UIColor whiteColor];
    }

}

-(void)Clicktap:(UITapGestureRecognizer *)sender//点击释放触发
{
    NSLog(@"tag:%ld",sender.view.tag);
    UIView *backView = (UIView *)sender.view;
    int tag = (int)backView.tag-100;
    [self.delegate didSelectedHomeMenuCellAtIndex:tag];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end

