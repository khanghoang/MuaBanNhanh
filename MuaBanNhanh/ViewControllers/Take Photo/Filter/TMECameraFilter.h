//
//  TMECameraFilter.h
//  ThreeMin
//
//  Created by Khoa Pham on 11/20/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "IMGLYFilter.h"

@interface TMECameraFilter : NSObject

@property (nonatomic, assign) IMGLYFilterType filterType;
@property (nonatomic, copy) NSString *filterName;
@property (nonatomic, strong) UIImage *image;

@end
