//
//  FYXingViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/9.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYXingViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *homeNewDataDic;


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *imglableView;

@end
