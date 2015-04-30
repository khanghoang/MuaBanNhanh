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

@end

@implementation MBNPopupMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addTapOutsideToDismissGesture];
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
