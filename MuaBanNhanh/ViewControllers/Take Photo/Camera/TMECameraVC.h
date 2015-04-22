//
//  TMECameraVC.h
//  ThreeMin
//
//  Created by Khoa Pham on 11/19/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "IMGLYFilter.h"

typedef NS_ENUM(NSInteger, TMECameraVCResult) {
    TMECameraVCResultCancelled,
    TMECameraVCResultDone,
};

typedef void (^TMECameraVCCompletionHandler)(TMECameraVCResult result,
                                                           UIImage *image,
                                                           IMGLYFilterType filterType);

/*
 Shows the live stream of the camera and allows to apply a certain filter on the stream. It also allows to take a photo.
 */
@interface TMECameraVC : UIViewController

/*
 Specifies a block to be called when the user is finished. This block is not guaranteed to be called on any particular
 thread. It is cleared after being called.
 */
@property (nonatomic, copy) TMECameraVCCompletionHandler completionHandler;


/*
 The camera view controller operates in two modes. First the camera mode, and second the accept mode.
 The accept mode is activ when the used has taken a photo, and sees the accept / save controls.
 After another viewcontroller was active e.g. the editor, we must be able to switch back to the
 camera mode. This function allows us to do so.
 */
- (void)restartCamera;

@end
