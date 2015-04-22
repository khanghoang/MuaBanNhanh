//
//  TMECameraFilterSelectorVC.h
//  ThreeMin
//
//  Created by Khoa Pham on 11/19/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMGLYFilter.h"

@protocol TMECameraFilterSelectorVCDelegate <NSObject>

- (void)filterSelectorVCDidSelectFilterType:(IMGLYFilterType)filterType;

@end

@interface TMECameraFilterSelectorVC : UICollectionViewController

@property (nonatomic, weak) id<TMECameraFilterSelectorVCDelegate> delegate;

- (void)reset;

@end
