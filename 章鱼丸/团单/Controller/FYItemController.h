//
//  FYItemController.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/23.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYItemController : UIViewController

@property (nonatomic, strong) NSString *httpUrl;
@property (nonatomic, strong) NSString *HttpArg;
@property (nonatomic) NSURLSession *session;

@end
