//
//  FYFiveViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/11.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYFiveViewCellDelegate <NSObject>

@optional
-(void)didSelectedFiveViewCellIndex:(NSInteger)index;

@end

@interface FYFiveViewCell : UITableViewCell

@property (nonatomic, assign) id<FYFiveViewCellDelegate> delegate;


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Array:(NSArray *)array;

-(void)addTimer;
-(void)closeTimer;

@end
