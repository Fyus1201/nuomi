//
//  FYItemView.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYItemView.h"
#import "UIImageView+WebCache.h"

@implementation FYItemView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame title:(NSString *)title juli:(NSString *)juli pingfeng:(NSString *)pingfeng xianjia:(NSNumber *)xianjia yuanjia:(NSNumber *)yuanjia imagestr:(NSString *)imagestr//形成视图和文字的view
{
    self = [super initWithFrame:frame];
    if(self)
    {
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 110)];
        NSRange range = [imagestr rangeOfString:@"src="];
        if (range.location != NSNotFound)
        {
            NSString *subStr = [imagestr substringFromIndex:range.location+range.length];
            subStr = [subStr stringByRemovingPercentEncoding];
            [imageView sd_setImageWithURL:[NSURL URLWithString:subStr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
        }
        [self addSubview:imageView];
        
        //标题
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 115, frame.size.width-50, 20)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentLeft;
        titlelab.font = [UIFont systemFontOfSize:14];
        [self addSubview:titlelab];
        
        //距离
        UILabel *julilab = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-45, 115, 45, 20)];
        julilab.text = juli;
        julilab.textAlignment = NSTextAlignmentRight;
        julilab.font = [UIFont systemFontOfSize:12];
        julilab.textColor = [UIColor grayColor];
        [self addSubview:julilab];
        
        //现价
        UILabel *newStrlab = [[UILabel alloc]initWithFrame:CGRectMake(0, 135, 45, 20)];
        
        float price = [xianjia floatValue]/100;
        NSString *tuan;
        if ((int)price == price)
        {
            tuan = [NSString stringWithFormat:@"%ld",[xianjia integerValue]/100];
        }else
        {
            tuan = [NSString stringWithFormat:@"%.1f",[xianjia floatValue]/100];
        }
        
        NSMutableAttributedString *tuanatt =  [[NSMutableAttributedString alloc] init];
        NSAttributedString *tuan0 = [[NSAttributedString alloc]initWithString:@"￥"];
        NSMutableAttributedString *tuan1 = [[NSMutableAttributedString alloc]initWithString:tuan];
        [tuan1 addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:25]
                      range:NSMakeRange(0, tuan1.length)];
        
        [tuanatt appendAttributedString: tuan0];//拼接
        [tuanatt appendAttributedString: tuan1];
        
        newStrlab.attributedText = tuanatt;
        
        newStrlab.textAlignment = NSTextAlignmentLeft;
        newStrlab.font = [UIFont systemFontOfSize:14];
        newStrlab.textColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9];
        [self addSubview:newStrlab];
        
        //原价
        NSString *oldStr = [NSString stringWithFormat:@"%ld",[yuanjia integerValue]/100];
        NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
        
        UILabel *oldStrlab = [[UILabel alloc]initWithFrame:CGRectMake(60, 135, 45, 20)];
        oldStrlab.attributedText = attribtStr;
        oldStrlab.textAlignment = NSTextAlignmentLeft;
        oldStrlab.font = [UIFont systemFontOfSize:14];
        oldStrlab.textColor = [UIColor grayColor];
        [self addSubview:oldStrlab];
        
        //评分
        UILabel *pinglab = [[UILabel alloc]initWithFrame:CGRectMake(frame.size.width-45, 135, 45, 20)];
        pinglab.text = pingfeng;
        pinglab.textAlignment = NSTextAlignmentRight;
        pinglab.font = [UIFont systemFontOfSize:13];
        pinglab.textColor = [UIColor orangeColor];
        [self addSubview:pinglab];
        
        /*
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width/2-22, 15, 44, 44)];
        imageView.image = [UIImage imageNamed:imagestr];
        [self addSubview:imageView];
        
        
        UILabel *titlelab = [[UILabel alloc]initWithFrame:CGRectMake(0, 15+44, frame.size.width, 20)];
        titlelab.text = title;
        titlelab.textAlignment = NSTextAlignmentCenter;
        titlelab.font = [UIFont systemFontOfSize:12];
        [self addSubview:titlelab];
         */
        
        
        //self.layer.borderWidth = 0.5;//边框线
        //self.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9].CGColor;
    }
    
    return self;
}

@end
