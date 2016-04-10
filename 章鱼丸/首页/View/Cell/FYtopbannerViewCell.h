//
//  FYFiveViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYtopbannerViewCellDelegate <NSObject>

@optional
-(void)didSelectedTopbannerViewCellIndex:(NSInteger)index;

@end

@interface FYtopbannerViewCell : UITableViewCell

@property (nonatomic, assign) id<FYtopbannerViewCellDelegate> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
