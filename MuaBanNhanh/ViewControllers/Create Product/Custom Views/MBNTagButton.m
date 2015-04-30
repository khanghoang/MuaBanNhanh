//
//  MBNTagButton.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNTagButton.h"

@implementation MBNTagButton

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    MBNTagButton *button = [super buttonWithType:buttonType];
    [button commonInit];
    return button;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    self.contentEdgeInsets = UIEdgeInsetsMake(3, 10, 3, 10);
    self.titleLabel.font = [UIFont systemFontOfSize:12.0f];
}


@end
