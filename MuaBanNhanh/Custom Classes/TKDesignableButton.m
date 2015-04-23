//
//  TKDesignableButton.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/23/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "TKDesignableButton.h"

@implementation TKDesignableButton

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.layer.cornerRadius = _borderRadius;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
}

@end
