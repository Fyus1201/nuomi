//
//  FYHomepageModel.m
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import "FYHomepageModel.h"

@implementation FYHomepageModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"banners":@"banners",
             @"category":@"category",
             @"special":@"special",
             @"recommend":@"recommend",
             @"topten":@"topten"
             };
}

+(NSValueTransformer *)bannersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FYHomebannersModel class]];
}

+(NSValueTransformer *)categoryJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FYHomecategoryModel class]];
}

+(NSValueTransformer *)specialJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[FYHomespecialModel class]];
}

+ (NSValueTransformer *)toptenJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[FYHometoptenModel class]];
}

@end



//1
@implementation FYHomebannersModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"banner_id":@"banner_id",
             @"picture_url":@"picture_url",
             @"goto_type":@"goto_type",
             @"cont":@"cont"
             };
}

@end


//2
@implementation FYHomecategoryModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"category_id":@"category_id",
             @"category_name":@"category_name",
             @"category_picurl":@"category_picurl",
             @"icon_url":@"icon_url",
             @"has_icon":@"has_icon",
             
             @"schema":@"schema"
             };
}

@end

//3
@implementation FYHomespecialModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"block_1":@"block_1",
             @"block_2":@"block_2",
             @"block_3":@"block_3"
             };
}

@end


//4
@implementation FYHometoptenModel

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

