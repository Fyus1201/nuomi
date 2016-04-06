//
//  FYBiaotiTableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYBiaotiTableViewCellDelegate <NSObject>

@optional
-(void)didSelectedBiaotiAtIndex:(NSInteger)index;

@end

@interface FYBiaotiTableViewCell : UITableViewCell

@property (nonatomic, assign) id<FYBiaotiTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *act;
@property (nonatomic) NSInteger nsn;

@end