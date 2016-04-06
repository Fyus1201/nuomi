//
//  FY33TableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/16.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FY33Block3Delegate <NSObject>

@optional
-(void)didSelectedHomeBlock3AtIndex:(NSInteger)index;

@end

@interface FY33TableViewCell : UITableViewCell

@property (nonatomic, assign) id<FY33Block3Delegate> delegate;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier array:(NSArray *)array ;


@end

