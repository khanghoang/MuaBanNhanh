//
//  MBNProductCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductCollectionViewCell.h"

@interface MBNProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblUpdateAt;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet TKAlignTopLabel *lblCategories;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProductImage;

@end

@implementation MBNProductCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)configWithData:(id)data {
    
    if(![data isKindOfClass:[MBNProduct class]]) {
        return;
    }
    
    MBNProduct *product = data;
    
    // price
    self.lblPrice.text = product.price.stringValue;
    
    // update at
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/YYYY - hh:mm";
    self.lblUpdateAt.text = [NSString stringWithFormat:@"Cập nhật ngày: %@", [dateFormatter stringFromDate:product.updatedAt]];
    
    // thumb
    [self.imageViewProductImage setImageWithURL:product.defaultImage];
    
    // categories
    NSString *concatCategories = @"";
    for(MBNCategory *cat in product.categories) {
        [concatCategories stringByAppendingString:[NSString stringWithFormat:@" - %@", cat.name]];
    }
    self.lblCategories.text = concatCategories;
}

@end
