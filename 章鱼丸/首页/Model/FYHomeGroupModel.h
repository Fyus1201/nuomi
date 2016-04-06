//
//  FYHomepageModel.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Mantle/Mantle.h>

//服务
@interface FYHomeGroup3Model : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *ceilTitle;
@property (nonatomic, strong) NSString *descTitle;
@property (nonatomic, strong) NSString *descColor;
@property (nonatomic, strong) NSArray *listInfo;

@property (nonatomic, strong) NSString *moreLink;
@property (nonatomic, strong) NSString *titleColor;

@property (nonatomic, strong) NSArray *banner;



@end


//主
@interface FYHomeGroupModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) FYHomeGroup3Model *hotService;

@property (nonatomic, strong) NSDictionary *topten;
@property (nonatomic, strong) NSArray *nuomiNews;
@property (nonatomic, strong) NSArray *nuomiBigNewBanner;
@property (nonatomic, strong) NSArray *banners;

@property (nonatomic, strong) NSDictionary *activityGroup;//listInfo 数组
@property (nonatomic, strong) NSArray *category;
@property (nonatomic, strong) NSArray *daoDianfu;

@property (nonatomic, strong) FYHomeGroup3Model *meishiGroup;
@property (nonatomic, strong) FYHomeGroup3Model *entertainment;

@end

