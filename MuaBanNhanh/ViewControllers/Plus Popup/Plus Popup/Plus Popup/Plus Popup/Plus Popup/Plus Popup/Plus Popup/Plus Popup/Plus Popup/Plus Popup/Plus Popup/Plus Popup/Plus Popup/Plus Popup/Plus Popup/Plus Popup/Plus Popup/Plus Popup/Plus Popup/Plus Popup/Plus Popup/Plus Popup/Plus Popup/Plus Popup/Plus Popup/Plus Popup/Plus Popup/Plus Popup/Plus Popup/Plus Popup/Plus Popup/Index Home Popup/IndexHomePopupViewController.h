//
//  IndexHomePopupViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUnregisterHomePopup.h"

@interface IndexHomePopupViewController : UIViewController

@property (readonly, nonatomic) UIUnregisterHomePopup *popup;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@end
