//
//  UIImage+TMEAdditions.m
//  ThreeMin
//
//  Created by Khoa Pham on 11/18/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "UIImage+TMEAdditions.h"

@implementation UIImage (TMEAdditions)

+ (UIImage *)originalImageNamed:(NSString *)name
{
    return [[self imageNamed:name] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
