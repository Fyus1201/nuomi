//
//  FYHomepageModel.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Mantle/Mantle.h>

//1
@interface FYHomebannersModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSNumber *banner_id;
@property (nonatomic, strong) NSString *picture_url;
@property (nonatomic, strong) NSNumber *goto_type;
@property (nonatomic, strong) NSString *cont;

@end

//2
@interface FYHomecategoryModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *category_id;
@property (nonatomic, strong) NSString *category_name;
@property (nonatomic, strong) NSString *category_picurl;
@property (nonatomic, strong) NSString *icon_url;
@property (nonatomic, strong) NSNumber *has_icon;

@property (nonatomic, strong) NSString *schema;

@end

//3
@interface FYHomespecialModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSDictionary *block_1;
@property (nonatomic, strong) NSArray *block_2;
@property (nonatomic, strong) NSArray *block_3;

@end

//4
@interface FYHometoptenModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *activetime;
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSNumber *isLogo;
@property (nonatomic, strong) NSString *target_url;

@end
//主
@interface FYHomepageModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *banners;
@property (nonatomic, strong) NSArray *category;
@property (nonatomic, strong) FYHomespecialModel *special;
@property (nonatomic, strong) NSArray *recommend;
@property (nonatomic, strong) FYHometoptenModel *topten;

@end


