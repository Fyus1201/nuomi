//
//  FYData+CoreDataProperties.h
//  
//
//  Created by 寿煜宇 on 16/3/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FYData.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYData (CoreDataProperties)

@property (nonatomic) double orderingValue;
@property (nullable, nonatomic, retain) NSString *city;
@property (nullable, nonatomic, retain) NSString *searchTerm;
@property (nullable, nonatomic, retain) NSData *historyData;

@end

NS_ASSUME_NONNULL_END
