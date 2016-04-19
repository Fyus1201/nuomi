//
//  FY31TableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/14.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FY31Block2Delegate <NSObject>

@optional
-(void)didSelectedHomeBlock2AtIndex:(NSInteger)index;

@end

@interface FY31TableViewCell : UITableViewCell

@property (nonatomic, assign) id<FY31Block2Delegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array;


@end
