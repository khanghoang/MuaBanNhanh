//
//  MBNRevealViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNRevealViewController.h"
#import <PKRevealController/PKRevealControllerView.h>

@interface MBNRevealViewController ()

@property (nonatomic, strong, readwrite) PKRevealControllerView *frontView;
@property (nonatomic, strong, readwrite) PKRevealControllerView *leftView;
@property (nonatomic, strong, readwrite) PKRevealControllerView *rightView;

@end

@implementation MBNRevealViewController

- (void)hideRearViews
{
    [self.frontView setUserInteractionForContainedViewEnabled:YES];
}

@end
