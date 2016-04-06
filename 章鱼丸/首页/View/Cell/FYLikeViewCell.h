//
//  FYLikeViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/16.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHomeShopModel.h"


@interface FYLikeViewCell : UITableViewCell

@property (nonatomic, strong) FYShopTuanModel *shopM;

@property (weak, nonatomic) IBOutlet UIImageView *shopImageView;

@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDesLabel;

@property (weak, nonatomic) IBOutlet UILabel *newpriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end
