//
//  MBNFloatButton.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/2/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNFloatButton : UIView

@property (weak, nonatomic) IBOutlet UIButton *btnFloat;

- (IBAction)openPopup:(id)sender;
- (void)openPopup:(id)sender completion:(void(^)(void))completion DEPRECATED_MSG_ATTRIBUTE("Use togglePopup method instead.");
- (void)togglePopup:(id)sender completion:(void(^)(void))completion;

@end
