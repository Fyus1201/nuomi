//
//  FYJiageViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/31.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYJiageViewCell.h"


@interface FYJiageViewCell()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *xianjia;
@property (weak, nonatomic) IBOutlet UILabel *yuanjia;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *namedescription;

@end

@implementation FYJiageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setAct:(NSDictionary *)act
{
    if (act)
    {
        self.name.text = act[@"title"];
        self.namedescription.text = act[@"description"];
        
        float price = [act[@"current_price"] floatValue]/100;
        NSString *tuan;
        if ((int)price == price)
        {
            tuan = [NSString stringWithFormat:@"%ld",[act[@"current_price"] integerValue]/100];
        }else
        {
            tuan = [NSString stringWithFormat:@"%.1f",[act[@"current_price"] floatValue]/100];
        }
        //富文本
        NSMutableAttributedString *tuanatt =  [[NSMutableAttributedString alloc] init];
        NSAttributedString *tuan0 = [[NSAttributedString alloc]initWithString:@"￥"];
        NSMutableAttributedString *tuan1 = [[NSMutableAttributedString alloc]initWithString:tuan];
        NSAttributedString *tuan2 = [[NSAttributedString alloc]initWithString:@"团购价"];
        [tuan1 addAttribute:NSFontAttributeName
                      value:[UIFont systemFontOfSize:25]
                      range:NSMakeRange(0, tuan1.length)];
        
        NSString *oldStr = [NSString stringWithFormat:@"门市价 %ld",[act[@"market_price"] integerValue]/100];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc]initWithString:oldStr
                                                                     attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.f],
                                                                                  NSForegroundColorAttributeName:[UIColor grayColor],
                                                                                  NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
                                                                                  NSStrikethroughColorAttributeName:[UIColor grayColor]}];
        
        [tuanatt appendAttributedString: tuan0];//拼接
        [tuanatt appendAttributedString: tuan1];
        [tuanatt appendAttributedString: tuan2];
        
        self.xianjia.attributedText= attrStr;
        self.yuanjia.attributedText = tuanatt;
    }

}

@end
