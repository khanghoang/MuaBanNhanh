//
//  MBNExpandableTableCell.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNExpandableTableCell.h"

@implementation MBNExpandableTableCell

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    self.imgViewTick.hidden = !selected;
}

@end
