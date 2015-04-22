//
//  UIImage+Additions.h
//  Aelo
//
//  Created by Xu Xiaojiang on 30/8/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Additions)

- (UIImage *)scaleToSize:(CGSize)size;
- (UIImage *)scaleToWidth:(CGFloat)width;

- (UIImage *)crop:(CGRect)rect;
- (UIImage *)squareCrop;

- (UIImage *)resizableImageWithStandardInsets;

- (UIImage *)convertToGrayscale;

/*
 * Generate an image from size & single color
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

- (UIImage *)hueAdjust:(CGFloat)hueAdjust;

- (UIImage *)changeColor:(UIColor*)color;

/*
 * Adjust an image for theme
 * - yellow/blue/red/any string: will be suffix to the base image name
 * - #ABABAB: hex string containing a # character, will be used to colorize the base image
 * - 0-360: a number will be used to perform hue shift on the base image
 */
//+ (UIImage *)imageNamed:(NSString *)imageNamed withThemeName:(NSString *)themeName;

+ (UIImage *)oneTimeImageWithImageName:(NSString *)imageName isIcon:(BOOL)isIcon;

@end
