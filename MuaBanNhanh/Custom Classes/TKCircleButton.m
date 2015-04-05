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
    self.layer.shadowOpacity = 0.6f;
    self.layer.shadowRadius = 3.0f;
    self.layer.shadowColor = [UIColor colorFromHexString:@"#000000"].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 2.0f);
    [super drawRect:rect];
}

@end
