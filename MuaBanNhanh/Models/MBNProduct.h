//
//  MBNProduct.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBNUser.h"
#import "MBNProvince.h"

@interface MBNProduct : MTLModel
<
MTLJSONSerializing
>

@property (copy, nonatomic) NSNumber *ID;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *slug;
@property (copy, nonatomic) NSURL *defaultImage;
@property (copy, nonatomic) NSURL *defaultThumbnailImage;
@property (strong, nonatomic) NSArray *categories;
@property (copy, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSNumber *isSale;
@property (copy, nonatomic) NSNumber *isPremium;
@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSNumber *viewCount;
@property (copy, nonatomic) NSNumber *isShow;
@property (copy, nonatomic) NSString *conditions;
@property (copy, nonatomic) NSString *des;
@property (copy, nonatomic) NSString *address;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSDate *expiredAt;
@property (strong, nonatomic) MBNUser *user;
@property (strong, nonatomic) NSArray *gallery;
@property (strong, nonatomic) MBNProvince *province;

+ (NSDateFormatter *)sharedDateFormatter;

- (NSString *)getDisplayAddressString;
- (NSString *)getPriceDisplayString;
- (NSString *)getTransactionString;

+ (NSString *)getPriceDisplayString:(NSString *)textPrice;

@end
