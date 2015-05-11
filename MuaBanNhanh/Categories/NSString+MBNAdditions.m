//
//  NSString+MBNAdditions.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/11/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "NSString+MBNAdditions.h"

@implementation NSString (MBNAdditions)

- (NSString *)strippingHTMLString {
    return [self stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
}

@end
