//
//  FYFiveViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYEbannerViewCellDelegate <NSObject>

@optional
-(void)didSelectedEbannerViewCellIndex:(NSInteger)index;

@end

@interface FYEbannerViewCell : UITableViewCell

@property (nonatomic, assign) id<FYEbannerViewCellDelegate> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
