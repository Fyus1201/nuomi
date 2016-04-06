//
//  FYHomeTwoCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/8.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYHomeTwoCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier twoArray:(NSArray *)twoArray;

-(void)addTimer;
-(void)closeTimer;

@end
