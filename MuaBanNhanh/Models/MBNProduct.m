//
//  MBNProduct.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProduct.h"
#import "NSString+MBNAdditions.h"

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
             @"user": @"user",
             @"gallery": @"gallery",
             @"viewCount": @"view_count",
             @"conditions": @"conditions",
             @"province": @"province",
             @"address": @"address.address",
             @"des": @"description.user"
             };
}

+ (NSValueTransformer *)userJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MBNUser class]];
}

+ (NSValueTransformer *)provinceJSONTransformer {
    return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:[MBNProvince class]];
}

+ (NSValueTransformer *)galleryJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MBNImage class]];
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

+ (NSValueTransformer *)desJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^NSString *(NSString *originalDes) {
        return [originalDes strippingHTMLString];
    }];
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

#pragma marks - Helpers

- (NSString *)getDisplayAddressString {
    return [self.address isEqualToString:@""] ? @"Địa chỉ chưa cập nhật" : self.address;
}

- (NSString *)getPriceDisplayString {
    // price
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *priceString = [formatter stringFromNumber:self.price];
    priceString = !priceString ? @"Giá liên hệ" : [NSString stringWithFormat:@"%@ %@", priceString, @"vnđ"];
    return priceString;
}

#pragma marks - Helper methods 

+ (NSDateFormatter *)sharedDateFormatter
{
    static NSDateFormatter *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NSDateFormatter alloc] init];
        instance.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        [instance setTimeZone:[[NSTimeZone alloc] initWithName:@"UTC"]];
    });

    return instance;
}

@end
