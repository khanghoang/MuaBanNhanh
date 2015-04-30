//
//  MBNPopupMenuViewController.h
//  MuaBanNhanh
//
//  Created by iSlan on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNPopupMenuViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIButton *openProductDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *editProductButton;
@property (weak, nonatomic) IBOutlet UIButton *removeProductButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewLeadingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewTopConstraint;

- (instancetype)initWithDestinationFrame:(CGRect)frame;

@end
