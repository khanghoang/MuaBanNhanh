//
//  MBNSubcategoryTableViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/8/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSubcategoryTableViewCell.h"

@interface MBNSubcategoryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;

@end

@implementation MBNSubcategoryTableViewCell

- (void)setBounds:(CGRect)bounds
{
    [super setBounds:bounds];
    self.contentView.frame = self.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.lblCategoryName.preferredMaxLayoutWidth = CGRectGetWidth(self.lblCategoryName.frame);
    
    [self.contentView updateConstraintsIfNeeded];
    [self.contentView layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configWithData:(id)data {
    if(![data isKindOfClass:[MBNCategory class]]) {
        return;
    }
    
    MBNCategory *cat = data;
    NSString *unformattedString = [NSString stringWithFormat:@"%@ (%@)", cat.name, cat.articleCount];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc] initWithString:unformattedString];
    [displayString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(cat.name.length, unformattedString.length - cat.name.length)];
    [displayString addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(cat.name.length, unformattedString.length - cat.name.length)];
    self.lblCategoryName.attributedText = displayString;
}

@end
