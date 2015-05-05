//
//  MBNBasePopupTableViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/6/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MBNFloatButtonPopup

- (void)dismissWithCompletion:(void(^)(void))completion;
- (CGFloat)getViewHeight;

@end

@interface MBNBasePopupTableViewController : UITableViewController

@end
