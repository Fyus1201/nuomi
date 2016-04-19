//
//  FYXingViewCell.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/9.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYXingViewCell.h"
#import "UIImageView+WebCache.h"

@implementation FYXingViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setHomeNewDataDic:(NSDictionary *)homeNewDataDic
{
    _homeNewDataDic = homeNewDataDic;
    self.titleLabel.text = [homeNewDataDic objectForKey:@"subTitle"];
    [self.imglableView sd_setImageWithURL:[NSURL URLWithString:[homeNewDataDic objectForKey:@"titlePictureUrl"]] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
    [self.imgView sd_setImageWithURL:[NSURL URLWithString:[homeNewDataDic objectForKey:@"pictureUrl"]] placeholderImage:[UIImage imageNamed:@"ugc_photo"]];
}

@end
