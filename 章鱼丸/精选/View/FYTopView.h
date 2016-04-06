//
//  FYTopView.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/5.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYTopViewDelegate <NSObject>

@optional

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name;

@end

@interface FYTopView : UIView

@property(nonatomic, assign) id<FYTopViewDelegate> delegate;

@property (nonatomic, strong) NSArray *bigGroupArray;//获取右侧数据
@property (nonatomic, strong) NSArray *topArray;//获取左侧数据

@end
