//
//  TKDesignableTableView.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/6/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "TKDesignableTableView.h"

@implementation TKDesignableTableView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.layer.cornerRadius = _borderRadius;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
    
    self.layer.shadowOffset = _shadowOffset;
    self.layer.shadowColor = _shadowColor.CGColor;
    self.layer.shadowRadius = _shadowRadius;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

@end
