//
//  UIImage+fixOrientation.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/23/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (fixOrientation)

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToSizeWithSameAspectRatio:(CGSize)targetSize;

@end