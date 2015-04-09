//
//  MBNShowLoginSegue.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/10/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNShowLoginSegue.h"

@implementation MBNShowLoginSegue

- (void)perform {
    [[self sourceViewController] presentViewController:[self destinationViewController] animated:YES completion:nil];
}

@end
