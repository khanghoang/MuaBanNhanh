//
//  TKCircleButton.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "TKCircleButton.h"

@implementation TKCircleButton

- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = YES;
    [super drawRect:rect];
}

@end
