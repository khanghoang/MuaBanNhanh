//
//  MBNImage.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNImage.h"
#import "NSString+MBNAdditions.h"

@implementation MBNImage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"ID": @"id",
             @"caption": @"caption",
             @"imageURL": @"image_url",
             @"imageFileName": @"image_filename"
             };
}

+ (NSValueTransformer *)imageURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

+ (NSValueTransformer *)captionJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(NSString *caption) {
        return [caption strippingHTMLString];
    }];
}

@end
