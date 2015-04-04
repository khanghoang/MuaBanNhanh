//
//  MBNHomeTopCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/2/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNHomeTopCollectionViewCell.h"

@interface MBNHomeTopCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageViewCategory;
@property (weak, nonatomic) IBOutlet UILabel *lblCategoryName;

@end

@implementation MBNHomeTopCollectionViewCell

- (void)configWithData:(id)data {
    if(![data isKindOfClass:[MBNCategory class]]) {
        return;
    }
    
    MBNCategory *category = data;
    
    [self.imageViewCategory setImageWithURL:category.imageUrl];
    self.lblCategoryName.text = category.name;
}

@end
