//
//  FYDataModel.h
//  章鱼丸
//
//  Created by 寿煜宇 on 16/3/17.
//  Copyright © 2016年 Fyus. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FYData;

@interface FYDataModel : NSObject

+(instancetype)sharedStore;
- (BOOL)saveChanges;

-(NSArray *)allItems;
-(void)createItem;

@end
