//
//  MBNUser.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUser.h"

@implementation MBNUser


+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"ID": @"id",
             @"name": @"name",
             @"phone": @"phone",
             @"avatarImageUrl": @"avatar_image_url",
             @"coverImageUrl": @"cover_image_url",
             };
}

+ (NSValueTransformer *)avatarImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)coverImageUrlJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
