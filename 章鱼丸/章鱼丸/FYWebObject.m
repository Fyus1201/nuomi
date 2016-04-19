//
//  FYWebObject.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/4/15.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYWebObject.h"

@implementation FYWebObject

//一下方法都是只是打了个log 等会看log 以及参数能对上就说明js调用了此处的iOS 原生方法
-(void)TestNOParameter
{
    NSLog(@"this is ios TestNOParameter");
}
-(void)TestOneParameter:(NSString *)message
{
    NSLog(@"this is ios TestOneParameter=%@",message);
}
-(void)TestTowParameter:(NSString *)message1 SecondParameter:(NSString *)message2
{
    NSLog(@"this is ios TestTowParameter=%@  Second=%@",message1,message2);
}

@end
