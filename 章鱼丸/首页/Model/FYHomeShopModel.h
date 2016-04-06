//
//  FYHomeShopModel.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/13.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface FYHomeShopModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSMutableArray *tuan_list;
@property (nonatomic, strong) NSNumber *tuan_num;

@end


@interface FYShopTuanModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSString *deal_id;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *brand_name;//标题
@property (nonatomic, strong) NSString *short_title;//小标题
@property (nonatomic, strong) NSNumber *sale_count;

@property (nonatomic, strong) NSNumber *groupon_price;
@property (nonatomic, strong) NSNumber *market_price;
@property (nonatomic, strong) NSNumber *pay_start_time;
@property (nonatomic, strong) NSNumber *pay_end_time;
@property (nonatomic, strong) NSNumber *newgroupon;//new_groupon

@property (nonatomic, strong) NSNumber *sale_out;
@property (nonatomic, strong) NSNumber *groupon_type;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, strong) NSNumber *comment_num;
@property (nonatomic, strong) NSNumber *bought_weekly;

@property (nonatomic, strong) NSString *reason;//无
@property (nonatomic, strong) NSNumber *is_latest;
@property (nonatomic, strong) NSString *other_desc;//已售
@property (nonatomic, strong) NSString *score_desc;// 打分
@property (nonatomic, strong) NSNumber *appoint;

@property (nonatomic, strong) NSNumber *is_flash;
@property (nonatomic, strong) NSNumber *is_t10;
@property (nonatomic, strong) NSNumber *is_card;
@property (nonatomic, strong) NSMutableDictionary *favour_list;
@property (nonatomic, strong) NSString *distance;//距离

@property (nonatomic, strong) NSNumber *user_distance_status;
@property (nonatomic, strong) NSNumber *user_distance_poi;
@property (nonatomic, strong) NSNumber *user_distance;
@property (nonatomic, strong) NSString *s;//神秘代码
@property (nonatomic, strong) NSNumber *ifvirtual;

@property (nonatomic, strong) NSString *virtual_redirect_url;//uil

@end