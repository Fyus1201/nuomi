//
//  FYItemTuanTableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/1.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FYItemTuanTableViewCellDelegate <NSObject>

@optional
-(void)didSelectedItemTuanAtIndex:(NSInteger)index;

@end

@interface FYItemTuanTableViewCell : UITableViewCell

@property (nonatomic, assign) id<FYItemTuanTableViewCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array;


@end
