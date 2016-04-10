//
//  TSHomeMenuCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/7.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYHomeMenuCellDelegate <NSObject>

@optional
-(void)didSelectedHomeMenuCellAtIndex:(NSInteger)index;

@end

@interface FYHomeMenuCell : UITableViewCell

@property (nonatomic, assign) id<FYHomeMenuCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView menuArray:(NSMutableArray *)menuArray;

@end
