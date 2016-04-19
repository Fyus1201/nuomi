//
//  FYHomepageModel.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYHomeGroupModel.h"

@implementation FYHomeGroupModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"hotService":@"hotService",
             @"topten":@"topten",
             @"nuomiNews":@"nuomiNews",
             @"nuomiBigNewBanner":@"nuomiBigNewBanner",
             @"banners":@"banners",
             @"activityGroup":@"activityGroup",
             @"category":@"category",
             @"daoDianfu":@"daoDianfu",
             @"meishiGroup":@"meishiGroup",
             @"entertainment":@"entertainment",
             };
}

+ (NSValueTransformer *)group3JSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[FYHomeGroup3Model class]];
}

+ (NSValueTransformer *)toptenJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[FYHometopModel class]];
}


@end


@implementation FYHomeGroup3Model

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ceilTitle":@"ceilTitle",
             @"descTitle":@"descTitle",
             @"descColor":@"descColor",
             @"listInfo":@"listInfo",
             @"moreLink":@"moreLink",
             @"titleColor":@"titleColor",
             @"banner":@"banner",
             };
}

@end

//4
@implementation FYHometopModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"activetime":@"activetime",
             @"list":@"list",
             @"isLogo":@"isLogo",
             @"target_url":@"target_url"
             };
}

@end
