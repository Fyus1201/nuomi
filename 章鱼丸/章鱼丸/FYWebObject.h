//
//  FYWebObject.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/15.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

//首先创建一个实现了JSExport协议的协议
@protocol TestJSObjectProtocolDelegate <JSExport>

//此处我们测试几种参数的情况
-(void)TestNOParameter;
-(void)TestOneParameter:(NSString *)message;
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2;

@end

@interface FYWebObject : NSObject<TestJSObjectProtocolDelegate>

@end
