//
//  UIViewController+Transition.h
//  Dash
//
//  Created by Torin on 6/11/12.
//  Copyright (c) 2012 Mark Corless. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Transition)

#pragma mark - Custom transition

- (void)presentModalViewController:(UIViewController *)modalViewController withPushDirection: (NSString *) direction;
- (void)dismissModalViewControllerWithPushDirection:(NSString *) direction;
- (void)dismissModalViewControllerWithFadeDuration:(CGFloat)duration;


#pragma mark - Helpers

- (BOOL)hasNativeFacebookApp;
- (BOOL)openFacebookPageID:(NSString*)pageID;
- (BOOL)hasNativeTwitterApp;
- (BOOL)openTwitterScreenName:(NSString*)screenName;

- (UIView *)dismissKeyboard;

#pragma mark - Storyboard
+ (instancetype)tme_instantiateFromStoryboardNamed:(NSString *)storyboardName;

#pragma mark - ChildVC
- (void)addChildVC:(UIViewController *)childVC containerView:(UIView *)containerView masConstraintBlock:(void(^)(MASConstraintMaker *make))block;
- (void)addChildVC:(UIViewController *)childVC containerView:(UIView *)containerView;
- (void)removeChildVC:(UIViewController *)childVC;

@end
