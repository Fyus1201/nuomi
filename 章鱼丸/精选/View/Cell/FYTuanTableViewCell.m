//
//  FYTuanTableViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYTuanTableViewCell.h"

#import "UIImageView+WebCache.h"

@interface FYTuanTableViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price_current;
@property (weak, nonatomic) IBOutlet UILabel *price_ori;
@property (weak, nonatomic) IBOutlet UILabel *minusFlag;
@property (weak, nonatomic) IBOutlet UILabel *other_desc;

@end

@implementation FYTuanTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setAct:(NSDictionary *)act
{
    if ([act[@"favour"] count]>1)
    {
        if ([act[@"favour"][@"activityList"] count]>0)
        {
            self.minusFlag.text = act[@"favour"][@"activityList"][0][@"name"];
            self.minusFlag.layer.borderWidth = 0.5;//边框线
            self.minusFlag.layer.borderColor = [UIColor colorWithRed:252/255.0 green:74/255.0 blue:132/255.0 alpha:0.9].CGColor;
            
            float price = [act[@"favour"][@"price"] floatValue]/100;
            if ((int)price == price)
            {
                self.price_current.text = [NSString stringWithFormat:@"￥%d",(int)price];
            }else
            {
                self.price_current.text = [NSString stringWithFormat:@"￥%.1f",price];
            }
        }else
        {
            self.minusFlag.text = @"";
            
            float price = [act[@"price_current"] floatValue]/100;
            if ((int)price == price)
            {
                self.price_current.text = [NSString stringWithFormat:@"￥%d",(int)price];
            }else
            {
                self.price_current.text = [NSString stringWithFormat:@"￥%.1f",price];
            }
        }

    }else
    {
        self.minusFlag.text = @"";
        
        float price = [act[@"price_current"] floatValue]/100;
        if ((int)price == price)
        {
            self.price_current.text = [NSString stringWithFormat:@"￥%d",(int)price];
        }else
        {
            self.price_current.text = [NSString stringWithFormat:@"￥%.1f",price];
        }
    }
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:act[@"tiny_image"]] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
    
    self.name.text = act[@"title_high_price"];
    
    self.other_desc.text = [NSString stringWithFormat:@"%@",act[@"other_desc"]];
    //中间的划线
    NSString *oldStr = [NSString stringWithFormat:@"%ld",[act[@"price_ori"] integerValue]/100];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
    self.price_ori.attributedText = attribtStr;
    
    self.userInteractionEnabled = YES;
    /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
    
    self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
    self.pressRecognizer.minimumPressDuration = 0.05;
    self.pressRecognizer.delegate = self;
    self.pressRecognizer.cancelsTouchesInView = NO;
    
    [self addGestureRecognizer:self.pressRecognizer];
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


@end
