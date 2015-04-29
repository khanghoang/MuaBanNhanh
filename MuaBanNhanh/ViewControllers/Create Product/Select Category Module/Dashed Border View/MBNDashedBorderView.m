//
//  MBNDashedBorderView.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNDashedBorderView.h"

@interface MBNDashedBorderView()

@property (strong, nonatomic) CAShapeLayer *border;

@end

@implementation MBNDashedBorderView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addDashedBorder];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addDashedBorder];
    }
    return self;
}

- (void)addDashedBorder
{
    _border = [CAShapeLayer layer];
    _border.fillColor = nil;
    _border.strokeColor = [UIColor colorFromHexString:@"#EFEFEF"].CGColor;
    _border.lineWidth = 3.0f;
    _border.lineDashPattern = @[@10, @10];
    [self.layer addSublayer:_border];
}

- (void)layoutSubviews
{
    _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    _border.frame = self.bounds;
}

@end
