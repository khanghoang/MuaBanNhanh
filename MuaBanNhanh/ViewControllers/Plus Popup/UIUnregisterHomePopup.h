//
//  UIUnregisterHomePopup.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/10/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBNBasePopupTableViewController.h"

@interface UIUnregisterHomePopup : MBNBasePopupTableViewController

- (void)dismissWithCompletion:(void(^)(void))completion;

@end
