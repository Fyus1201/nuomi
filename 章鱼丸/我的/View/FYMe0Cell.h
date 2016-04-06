//
//  FYMe0Cell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/23.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol FYMe0Delegate <NSObject>

@optional
-(void)didSelectedMe0AtIndex:(NSInteger)index;

@end

@interface FYMe0Cell : UITableViewCell

@property (nonatomic, assign) id<FYMe0Delegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array;

@end
