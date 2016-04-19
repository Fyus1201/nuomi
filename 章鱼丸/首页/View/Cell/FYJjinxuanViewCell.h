//
//  FYJjinxuanViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/9.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYJjinxuanViewCell : UITableViewCell

@property (nonatomic, strong) NSArray *listArray;

@property (nonatomic, strong) NSArray *activeTimeArray;

@property (weak, nonatomic) IBOutlet UILabel *hourLabel;
@property (weak, nonatomic) IBOutlet UILabel *minLabel;
@property (weak, nonatomic) IBOutlet UILabel *secLabel;

@property (weak, nonatomic) IBOutlet UILabel *label;

@end
