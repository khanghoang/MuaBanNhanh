//
//  MBNPaddingTextField.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNPaddingTextField.h"

static UIEdgeInsets const kPaddingEdgeInsets = {0, 10, 0, 10};

@implementation MBNPaddingTextField

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tintColor = [UIColor colorWithHexString:@"#4CAF50"];
}

- (CGRect)textRectForBounds:(CGRect)bounds {
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, kPaddingEdgeInsets)];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, kPaddingEdgeInsets)];
}

@end
