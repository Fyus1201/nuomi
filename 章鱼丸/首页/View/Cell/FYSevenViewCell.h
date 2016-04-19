//
//  FYSevenViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/10.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYSevenDelegate <NSObject>

@optional
-(void)didSelectedSevenAtIndex:(NSInteger)index;

@end

@interface FYSevenViewCell : UITableViewCell

@property (nonatomic, assign) id<FYSevenDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array ;

@end
