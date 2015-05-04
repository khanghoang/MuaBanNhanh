//
//  MBNCloseNavigationSegue.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/4/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCloseNavigationSegue.h"

@implementation MBNCloseNavigationSegue

- (void)perform {
    UIViewController *viewController = self.sourceViewController;
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
