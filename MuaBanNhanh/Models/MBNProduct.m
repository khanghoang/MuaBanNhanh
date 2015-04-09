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
             @"user": @"user"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MBNUser class]];
}

+ (NSValueTransformer *)defaultImageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)defaultThumbnailImageJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)categoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MBNCategory class]];
}

+ (NSValueTransformer *)createdAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        NSDateFormatter *formatter = [self sharedDateFormatter];
        return [formatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [date description];
    }];
}

+ (NSValueTransformer *)updatedAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        NSDateFormatter *formatter = [self sharedDateFormatter];
        return [formatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [date description];
    }];
}

+ (NSValueTransformer *)expiredAtJSONTransformer
{
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *dateString) {
        NSDateFormatter *formatter = [self sharedDateFormatter];
        return [formatter dateFromString:dateString];
    } reverseBlock:^(NSDate *date) {
        return [date description];
    }];
}

#pragma marks - Helper methods 

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
        instance.dateFormat = @"yyyy-dd-MM HH:mm:ss";
        [instance setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
    });

    return instance;
}

@end
