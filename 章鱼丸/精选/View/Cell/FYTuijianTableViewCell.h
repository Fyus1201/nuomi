//
//  FYTuijianTableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYTuijianTableViewCellDelegate <NSObject>

@optional
-(void)didSelectedTuiJianAtIndex:(NSInteger)index;

@end

@interface FYTuijianTableViewCell : UITableViewCell

@property (nonatomic, assign) id<FYTuijianTableViewCellDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array ;

@end
