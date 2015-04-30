//
//  MBNTagCell.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNTagCell.h"

@implementation MBNTagCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorFromHexString:@"EFEFEF"];
    [self.tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)configWithString:(NSString *)string
{
    [self.tagButton setTitle:string forState:UIControlStateNormal];
    [self.tagButton sizeToFit];
}

+ (CGSize)getCellSizeWithString:(NSString *)string
{
    MBNTagButton *tempTagButton = [MBNTagButton buttonWithType:UIButtonTypeCustom];
    [tempTagButton setTitle:string forState:UIControlStateNormal];
    [tempTagButton sizeToFit];
    return CGSizeMake(tempTagButton.frame.size.width, tempTagButton.frame.size.height);
}

@end
