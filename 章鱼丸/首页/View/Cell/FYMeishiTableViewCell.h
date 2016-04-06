//
//  FY33TableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/16.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYMeiDelegate <NSObject>

@optional
-(void)didSelectedHomeMeiAtIndex:(NSInteger)index;

@end

@interface FYMeishiTableViewCell : UITableViewCell

@property (nonatomic, assign) id<FYMeiDelegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array ;


@end

