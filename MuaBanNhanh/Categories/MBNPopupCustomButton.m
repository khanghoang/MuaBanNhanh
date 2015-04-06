//
//  MBNPopupCustomButton.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/6/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//


#import "MBNPopupCustomButton.h"

@implementation MBNPopupCustomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)drawRect:(CGRect)rect {
    
    [super drawRect:rect];
    UIImage *image = self.currentBackgroundImage;
    UIEdgeInsets insets = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
    UIImage *strechedImage = [image resizableImageWithCapInsets:insets];
    [self setBackgroundImage:strechedImage forState:UIControlStateNormal];
    
}

@end
