//
//  FYBiaotiTableViewCell.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/26.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYJBiaotiTableViewCellDelegate <NSObject>

@optional
-(void)didSelectedJBiaotiAtIndex:(NSInteger)index;

@end

@interface FYJBiaotiTableViewCell : UITableViewCell

@property (nonatomic, assign) id<FYJBiaotiTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSDictionary *act;

@end