//
//  NSString+urlString.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/15.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "NSString+urlString.h"

@implementation NSString (urlString)

+(NSString *)convertImgStr:(NSString *)imgStr
{
    NSRange range = [imgStr rangeOfString:@"src="];
    if (range.location != NSNotFound) {
        NSString *subStr = [imgStr substringFromIndex:range.location+range.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        return subStr;
    }else{
        return @"ugc_photo";
    }
}

+(NSString *)getSpecialId:(NSString *)special
{
    NSRange range = [special rangeOfString:@"specialid="];
    if (range.location != NSNotFound) {
        NSString *subStr = [special substringFromIndex:range.location+range.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        return subStr;
    }else{
        return @"";
    }
}

+(NSString *)getWebUrl:(NSString *)cont
{
    NSRange range = [cont rangeOfString:@"web?url="];
    if (range.location != NSNotFound) {
        NSString *subStr = [cont substringFromIndex:range.location+range.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        return subStr;
    }else{
        return @"https://www.baidu.com/";
    }
}

+(NSString *)getComponentUrl:(NSString *)cont
{
    NSRange range = [cont rangeOfString:@"component?url="];
    if (range.location != NSNotFound)
    {
        NSString *subStr = [cont substringFromIndex:range.location+range.length];
        subStr = [subStr stringByRemovingPercentEncoding];
        return subStr;
    }else{
        return @"https://www.baidu.com/";
    }
}

@end
