//
//  MBNProduct.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProduct.h"

@implementation MBNProduct

#pragma mark - Mantle 

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID": @"id",
             @"name": @"name",
             @"slug": @"slug",
             @"defaultImage": @"default_image",
             @"defaultThumbnailImage": @"default_thumbnail_image",
             @"categories": @"categories",
             @"price": @"price",
             @"isSale": @"is_sale",
             @"conditions": @"conditions",
             @"isShow": @"is_show",
             @"isPremium": @"is_premium",
             @"status": @"status",
             @"createdAt": @"created_at",
             @"updatedAt": @"updated_at",
             @"expiredAt": @"expired_at",
             
             };
}

@end
