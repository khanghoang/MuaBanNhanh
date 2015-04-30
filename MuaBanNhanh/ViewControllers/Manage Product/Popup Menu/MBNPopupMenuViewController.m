//
//  MBNPopupMenuViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNPopupMenuViewController.h"

@interface MBNPopupMenuViewController ()

@property (weak, nonatomic) IBOutlet UIView *dismissView;
@property (assign, nonatomic) CGRect destinationFrame;

@end

@implementation MBNPopupMenuViewController

- (instancetype)initWithDestinationFrame:(CGRect)frame
{
    if (self = [super init]) {
        _destinationFrame = frame;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapOutsideToDismissGesture];
    [self adjustMenuViewPosition];
}

- (void)adjustMenuViewPosition
{
    self.menuViewLeadingConstraint.constant = CGRectGetMaxX(self.destinationFrame) - CGRectGetWidth(self.menuView.frame);
    self.menuViewTopConstraint.constant = CGRectGetMinY(self.destinationFrame);
    [self.view layoutIfNeeded];
}

- (void)addTapOutsideToDismissGesture
{
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(dismissMenu:)];
    [self.dismissView addGestureRecognizer:tapGesture];
}

- (void)dismissMenu:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
