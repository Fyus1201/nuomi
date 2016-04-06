//
//  FYLikeViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/16.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYLikeViewCell.h"
#import "UIImageView+WebCache.h"

@interface FYLikeViewCell()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILongPressGestureRecognizer *pressRecognizer;

@end

@implementation FYLikeViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setShopM:(FYShopTuanModel *)shopM
{
    _shopM = shopM;
    NSRange range = [shopM.image rangeOfString:@"src="];
    if (range.location != NSNotFound) {
        NSString *subStr = [shopM.image substringFromIndex:range.location+range.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        [self.shopImageView sd_setImageWithURL:[NSURL URLWithString:subStr] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
    }
    
    self.layer.borderWidth = 0.5;//边框线
    self.layer.borderColor = [UIColor colorWithRed:0.93 green:0.93 blue:0.93 alpha:0.9].CGColor;
    
    self.shopNameLabel.text = shopM.brand_name;
    self.shopDesLabel.text = shopM.short_title;
    self.distanceLabel.text = shopM.distance;
    
    float price = [shopM.groupon_price floatValue]/100;
    if ((int)price == price)
    {
        self.newpriceLabel.text = [NSString stringWithFormat:@"￥%ld",[shopM.groupon_price integerValue]/100];
    }else
    {
        self.newpriceLabel.text = [NSString stringWithFormat:@"￥%.1f",[shopM.groupon_price floatValue]/100];
    }

    self.scoreLabel.text = shopM.score_desc;
    
    //中间的划线
    NSString *oldStr = [NSString stringWithFormat:@"%ld",[shopM.market_price integerValue]/100];
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldStr attributes:attribtDic];
    self.oldPriceLabel.attributedText = attribtStr;
    
    /* 长按手势来形成按钮效果（按钮会和scrollView以及tableView的滑动冲突） */
    self.pressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];//用长按来做出效果
    self.pressRecognizer.minimumPressDuration = 0.05;
    
    self.pressRecognizer.delegate = self;//用来实现长按不独占
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
