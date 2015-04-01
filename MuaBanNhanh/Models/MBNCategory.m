//
//  MBNCategory.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCategory.h"

@implementation MBNCategory

#pragma mark - Mantle 
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"ID": @"id",
             @"parentID": @"parent_id",
             @"name": @"name",
             @"slug": @"slug",
             @"imageUrl": @"image_url",
             @"imageHoverUrl": @"image_hover_url",
             @"ordering": @"ordering",
             @"articleCount": @"article_count",
             
             };
}

+ (NSValueTransformer *)subCategoriesJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:[MBNCategory class]];
}

@end
