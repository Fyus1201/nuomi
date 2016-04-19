//
//  FYFiveViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYMbannerViewCellDelegate <NSObject>

@optional
-(void)didSelectedMbannerViewCellIndex:(NSInteger)index;

@end

@interface FYMbannerViewCell : UITableViewCell

@property (nonatomic, assign) id<FYMbannerViewCellDelegate> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
