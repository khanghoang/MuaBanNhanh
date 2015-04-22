//
//  TMECropImageVC.h
//  ThreeMin
//
//  Created by Khoa Pham on 11/22/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "IMGLYAbstractEditorBaseViewController.h"
#import "IMGLYAbstractEditorBaseViewController_Private.h"

typedef NS_ENUM(NSInteger, TMECropImageVCSelectionMode) {
    TMECropImageVCSelectionModeFree,
    TMECropImageVCSelectionMode1to1,
    TMECropImageVCSelectionMode4to3,
    TMECropImageVCSelectionMode16to9
};

@interface TMECropImageVC : IMGLYAbstractEditorBaseViewController

@property (nonatomic, strong, setter = setInputImage:) UIImage *inputImage;
@property (nonatomic, assign, setter = setSelectionMode:) TMECropImageVCSelectionMode selectionMode;

@end
