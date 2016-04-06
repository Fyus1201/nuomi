//
//  TSMenuBtnView.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYMenuBtnView.h"
#import "UIImageView+WebCache.h"

@implementation FYMenuBtnView

//横着 小  彩色
-(id)initWithFrame9:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title long_title:(NSString *)long_title
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width/2, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = title;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-80, 6, 80, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        subtitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:subtitleLabel];
        
        //推荐
        UILabel *longtitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, frame.size.width, frame.size.height-25)];
        longtitle.font = [UIFont systemFontOfSize:12];
        longtitle.text = long_title;
        longtitle.textAlignment = NSTextAlignmentLeft;
        longtitle.textColor = [UIColor whiteColor];
        
        longtitle.lineBreakMode = NSLineBreakByWordWrapping;
        longtitle.numberOfLines = 0;
        
        [self addSubview:longtitle];
        
    }
    return self;
}

//竖着 大 彩色
-(id)initWithFrame8:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.textColor = [self randomColor];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, frame.size.width, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, frame.size.width - 40, 140)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}


//横着 小  彩色
-(id)initWithFrame7:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title tuijian:(NSString *)tuijian imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width/2-20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        titleLabel.textColor = [self randomColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, frame.size.width/2-20, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //推荐
        if (tuijian.length > 0)
        {
            UILabel *tuijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-10, 12, 25, 15)];
            tuijianLabel.font = [UIFont systemFontOfSize:10];
            tuijianLabel.text = tuijian;
            tuijianLabel.textAlignment = NSTextAlignmentCenter;
            tuijianLabel.textColor = [UIColor whiteColor];
            tuijianLabel.backgroundColor = [UIColor blueColor];
            [self addSubview:tuijianLabel];
        }
        
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2+10, 5, 70, 70)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}

//竖着 小   彩色
-(id)initWithFrame6:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = title;
        titleLabel.textColor = [self randomColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 70, 70)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}

//横着 小
-(id)initWithFrame5:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title tuijian:(NSString *)tuijian imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width/2-20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 35, frame.size.width/2-20, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //推荐
        if (tuijian.length > 0)
        {
            UILabel *tuijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width/2-10, 12, 35, 15)];
            tuijianLabel.font = [UIFont systemFontOfSize:10];
            tuijianLabel.text = tuijian;
            tuijianLabel.textAlignment = NSTextAlignmentLeft;
            tuijianLabel.textColor = [UIColor whiteColor];
            tuijianLabel.backgroundColor = [UIColor blueColor];
            [self addSubview:tuijianLabel];
        }

        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width/2+10, 5, 70, 70)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}

//竖着 大
-(id)initWithFrame4:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:18];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 25, frame.size.width, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 45, frame.size.width - 40, 140)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}

//竖着 小
-(id)initWithFrame3:(CGRect)frame subtitle:(NSString *)subtitle title:(NSString *)title imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, frame.size.width, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25, frame.size.width, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = subtitle;
        subtitleLabel.textAlignment = NSTextAlignmentCenter;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 45, 70, 70)];
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:imagestr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
    }
    return self;
}

-(id)initWithFrame2:(CGRect)frame title:(NSString *)title imagestr:(NSString *)imagestr
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        UILabel *imageView = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width/3.2, 0, frame.size.width/2, frame.size.height)];
        imageView.text = imagestr;
        imageView.textAlignment = NSTextAlignmentLeft;
        imageView.font = [UIFont systemFontOfSize:12];
        [self addSubview:imageView];
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, frame.size.width/3, frame.size.height)];
        titlelab.text = title;
        titlelab.textColor = [UIColor colorWithRed:255/255.0 green:69/255.0 blue:0/255.0 alpha:0.9];
        titlelab.textAlignment = NSTextAlignmentLeft;
        titlelab.font = [UIFont systemFontOfSize:12];
        [self addSubview:titlelab];
        
    }
    return self;
}

//最上滑动
-(id)initWithFrame1:(CGRect)frame title:(NSString *)title imagestr:(NSString *)imagestr//形成视图和文字的view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-15, 15, 30, 30)];
        imageView.image = [UIImage imageNamed:imagestr];
        [self addSubview:imageView];
        
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+30, frame.size.width, 15)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:12];
        [self addSubview:titlelab];
    }
    
    return self;
}

//最上滑动
-(id)initWithFrame:(CGRect)frame title:(NSString *)title imagestr:(NSString *)imagestr//形成视图和文字的view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-22, 15, 44, 44)];
        imageView.image = [UIImage imageNamed:imagestr];
        [self addSubview:imageView];
        
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+44, frame.size.width, 20)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:12];
        [self addSubview:titlelab];
    }
    
    return self;
}


-(UIColor *)randomColor//随机颜色
{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned int)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)0x7fffffff;
    CGFloat green = (CGFloat)random()/(CGFloat)0x7fffffff;
    CGFloat blue = (CGFloat)random()/(CGFloat)0x7fffffff;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

@end
