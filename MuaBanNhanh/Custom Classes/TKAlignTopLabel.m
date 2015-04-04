//
//  TKAlignTopLabel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "TKAlignTopLabel.h"

@implementation TKAlignTopLabel

- (void)drawTextInRect:(CGRect)rect {
    if (self.text) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = self.lineBreakMode;
        CGSize labelStringSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName:self.font,NSParagraphStyleAttributeName: paragraphStyle.copy}
                                                         context:nil].size;
        [super drawTextInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame),ceilf(labelStringSize.height))];
    } else {
        [super drawTextInRect:rect];
    }
}

@end
