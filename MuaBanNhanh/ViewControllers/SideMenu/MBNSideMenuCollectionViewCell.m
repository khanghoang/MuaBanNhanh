//
//  MBNSideMenuCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 3/31/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSideMenuCollectionViewCell.h"

@interface MBNSideMenuCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategory;


@end

@implementation MBNSideMenuCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configWithData:(id)data {
    
    if(![data isKindOfClass:[MBNCategory class]]) {
        return;
    }
    
    MBNCategory *category = data;
    
    self.lblCategoryName.text = category.name;
    [self.imageViewCategory setImageWithURL:category.iconUrl];
    
}

@end
