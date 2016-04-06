//
//  FYHomeTwoCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/8.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYHomeTwoCell.h"
#import "FYMenuBtnView.h"

@interface FYHomeTwoCell()<UIScrollViewDelegate>
{
    
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    
    NSInteger _page;
    NSInteger _page1;

}

@property (nonatomic,strong) NSTimer *timer;

@end

@implementation FYHomeTwoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier twoArray:(NSArray *)twoArray
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UIImageView *vip2000 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, [UIScreen mainScreen].bounds.size.width/4 - 10, 20)];
        vip2000.image = [UIImage imageNamed:@"home_vip_new@2x"];
        
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4, 0, [UIScreen mainScreen].bounds.size.width*0.75 +10, 30)];
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width*0.75 +10, 30*3);
        
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;//可以禁止手动滚动
        
        _scrollView.delegate = self;
        
        _scrollView.showsHorizontalScrollIndicator = NO;//滚动条是否可见 水平
        _scrollView.showsVerticalScrollIndicator=NO;//滚动条是否可见 垂直
        
        [_scrollView setPagingEnabled:YES];
        
        [self addSubview:vip2000];
        [self addSubview:_scrollView];
        
        for(int i = 0; i < [twoArray count]; i++)
        {
    
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(10, i*30, [UIScreen mainScreen].bounds.size.width*0.75 +10 , 30)];
                
                CGRect frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width*0.75 +10, 30);
                NSString *title = [twoArray[i] objectForKey:@"title"];
                NSString *imagestr = [twoArray[i] objectForKey:@"image"];
                
                FYMenuBtnView *btnView = [[FYMenuBtnView alloc]initWithFrame2:frame title:title imagestr:imagestr];
                btnView.tag = 2000 + i;
                [backView addSubview:btnView];
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Clicktap:)];
                [btnView addGestureRecognizer:tap];
            
            [_scrollView addSubview:backView];
            
            
        }
        
        //定义PageController 设定总页数，当前页，定义当控件被用户操作时,要触发的动作。
        _pageControl.numberOfPages = [twoArray count];
        _pageControl.currentPage = 0;
        _page = 0;
        _page1 = [twoArray count] - 1;
        //[_pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        
        //4.添加定时器
        [self addTimer];
        
    
    }
    return self;
}

-(void)Clicktap:(UITapGestureRecognizer *)sender
{
    NSLog(@"tag:%ld",sender.view.tag);
}


#pragma mark - timer方法
/**
 *  添加定时器
 */
-(void)addTimer
{
    self.timer =  [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(nextImage) userInfo:nil repeats:YES];
    //多线程 UI IOS程序默认只有一个主线程，处理UI的只有主线程。如果拖动第二个UI，则第一个UI事件则会失效。
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


-(void)nextImage
{
    if (_page == _page1)
    {
        _page=0;
        _scrollView.contentOffset = CGPointMake(0, _page*_scrollView.frame.size.height);
        _page=1;
        
    }else{
        _page++;
        
    }

    [_scrollView setContentOffset:CGPointMake(0, _page*_scrollView.frame.size.height) animated:YES];

}



/**
 *  关闭定时器
 */
-(void)closeTimer
{
    [self.timer invalidate];
}




#pragma mark - scrollView事件

/**
 * scrollView滚动的时候调用 用来计算当前是第几页
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    分页计算方法
    //    当前页=(scrollView.contentOffset.x+scrollView.frame.size.width/2)/scrollView.frame.size.width
    CGFloat page = (scrollView.contentOffset.y+scrollView.frame.size.height/2)/(scrollView.frame.size.height);
    _pageControl.currentPage=page;
    
}


/**
 *  scrollView 开始拖拽的时候调用
 *
 *  @param scrollView <#scrollView description#>
 */
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self closeTimer];
}


/**
 *  scrollView 结束拖拽的时候调用
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}





@end
