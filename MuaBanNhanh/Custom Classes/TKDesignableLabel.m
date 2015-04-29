//
//  TKDesignableLabel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "TKDesignableLabel.h"

@implementation TKDesignableLabel

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 */

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];
    self.layer.cornerRadius = _borderRadius;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = _borderColor.CGColor;
    self.layer.borderWidth = _borderWidth;
}

@end
