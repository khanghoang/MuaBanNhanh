//
//  MBNManageProductTypeCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductTypeCollectionViewCell.h"

@interface MBNManageProductTypeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *viewHighlight;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

@implementation MBNManageProductTypeCollectionViewCell

- (void)configWithTitle:(NSString *)title {
    self.lblTitle.text = title;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.viewHighlight.hidden = !selected;
}

@end
