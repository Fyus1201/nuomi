//
//  main.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/4.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
CFAbsoluteTime StartTime;
int main(int argc, char * argv[]) {
    StartTime = CFAbsoluteTimeGetCurrent();
    NSLog(@"启动时间 是 %f sec", StartTime);//启动时间
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
    
}

