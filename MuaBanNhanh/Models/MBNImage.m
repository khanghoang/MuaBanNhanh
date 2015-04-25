//
//  MBNImage.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNImage.h"

@implementation MBNImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID": @"id",
             @"caption": @"caption",
             @"imageURL": @"image_url"
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

@end
