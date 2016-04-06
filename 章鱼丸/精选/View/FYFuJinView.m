//
//  FYFuJinView.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/27.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYFuJinView.h"
#import "UIImageView+WebCache.h"

@implementation FYFuJinView

//精品 标题
-(id)initWithFrame2:(CGRect)frame name:(NSString *)name distance:(NSNumber *)distance discount:(NSString *)discount
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = name;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-155, 40, 100, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = discount;
        subtitleLabel.textAlignment = NSTextAlignmentRight;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        
        
        //距离
        UILabel *tuijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-50, 40,50, 20)];
        tuijianLabel.font = [UIFont systemFontOfSize:12];
        
        float price = [distance floatValue]/1000;
        if (price < 1)
        {
            tuijianLabel.text = [NSString stringWithFormat:@"<1km"];
        }else
        {
            if ((int)price == price)
            {
                tuijianLabel.text = [NSString stringWithFormat:@"%dkm",(int)price];
            }else
            {
                tuijianLabel.text = [NSString stringWithFormat:@"%.1fkm",price];
            }
        }
        
        tuijianLabel.textAlignment = NSTextAlignmentCenter;
        tuijianLabel.textColor = [UIColor grayColor];
        [self addSubview:tuijianLabel];
        
        //其他
        UILabel *tuijianLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35,100, 20)];
        tuijianLabel1.font = [UIFont systemFontOfSize:14];
        tuijianLabel1.text = @"暂无评价";
        tuijianLabel1.textAlignment = NSTextAlignmentLeft;
        tuijianLabel1.textColor = [UIColor grayColor];
        [self addSubview:tuijianLabel1];
        
        
    }
    return self;
}

//团购 标题
-(id)initWithFrame1:(CGRect)frame name:(NSString *)name distance:(NSString *)distance discount:(NSString *)discount
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, 30)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = name;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-155, 40, 100, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = discount;
        subtitleLabel.textAlignment = NSTextAlignmentRight;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];

        
        //距离
        UILabel *tuijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-50, 40,50, 20)];
        tuijianLabel.font = [UIFont systemFontOfSize:12];
        tuijianLabel.text = distance;
        tuijianLabel.textAlignment = NSTextAlignmentCenter;
        tuijianLabel.textColor = [UIColor grayColor];
        [self addSubview:tuijianLabel];
        
        //其他
        UILabel *tuijianLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 35,100, 20)];
        tuijianLabel1.font = [UIFont systemFontOfSize:14];
        tuijianLabel1.text = @"暂无评价";
        tuijianLabel1.textAlignment = NSTextAlignmentLeft;
        tuijianLabel1.textColor = [UIColor grayColor];
        [self addSubview:tuijianLabel1];

        
    }
    return self;
}

//附近3推荐
-(id)initWithFrame0:(CGRect)frame name:(NSString *)name distance:(NSString *)distance discount:(NSString *)discount imagestr:(NSString *)imagestr array:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        //标题
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 105, frame.size.width-20, 25)];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.text = name;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:titleLabel];
        //小标题
        UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 130, frame.size.width-20, 20)];
        subtitleLabel.font = [UIFont systemFontOfSize:12];
        subtitleLabel.text = discount;
        subtitleLabel.textAlignment = NSTextAlignmentLeft;
        subtitleLabel.textColor = [UIColor grayColor];
        [self addSubview:subtitleLabel];
        
        //图
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, frame.size.width-20, 100)];
        
        NSRange range0 = [imagestr rangeOfString:@"&src="];
        NSString *images ;
        if (range0.location != NSNotFound)
        {
            NSString *subStr = [imagestr substringFromIndex:range0.location+range0.length];
            subStr = [subStr stringByRemovingPercentEncoding];//换格式
            images = subStr;
            
        }else
        {
            images = imagestr;
            
        }
        
        [imageView sd_setImageWithURL:[NSURL URLWithString:images] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        [self addSubview:imageView];
        
        //推荐
        UILabel *tuijianLabel = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width-10-50, 100-10,50, 15)];
        tuijianLabel.font = [UIFont systemFontOfSize:10];
        tuijianLabel.text = distance;
        tuijianLabel.textAlignment = NSTextAlignmentCenter;
        tuijianLabel.textColor = [UIColor whiteColor];
        tuijianLabel.backgroundColor = [UIColor blackColor];
        tuijianLabel.backgroundColor = [tuijianLabel.backgroundColor colorWithAlphaComponent:0.5];
        [self addSubview:tuijianLabel];
        
        //小标题
        UILabel *zuijing = [[UILabel alloc] initWithFrame:CGRectMake(10, 150, frame.size.width-20, 20)];
        zuijing.font = [UIFont systemFontOfSize:12];
        zuijing.text = array[0];
        zuijing.textAlignment = NSTextAlignmentLeft;
        zuijing.textColor = [UIColor orangeColor];
        [self addSubview:zuijing];
        
    }
    return self;
}

@end
