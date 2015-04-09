//
//  MBNSegueShowProductFromCategory.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSegueShowProductFromCategory.h"

@implementation MBNSegueShowProductFromCategory

- (void)perform {
    [[[self sourceViewController] navigationController] pushViewController:[self destinationViewController] animated:YES];
}

@end
