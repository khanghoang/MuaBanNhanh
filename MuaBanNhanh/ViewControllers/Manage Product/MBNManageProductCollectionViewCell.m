//
//  MBNManageProductCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductCollectionViewCell.h"
#import "TKDesignableLabel.h"

@interface MBNManageProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgViewProduct;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet TKDesignableLabel *lblInactive;

@end

@implementation MBNManageProductCollectionViewCell

- (void)configWithData:(id)data {
    
    if(![data isKindOfClass:[MBNProduct class]]) {
        return;
    }
    
    MBNProduct *product = (MBNProduct *)data;
    [self.imgViewProduct setImageWithURL:product.defaultThumbnailImage];
    self.lblProductName.text = product.name;
    self.lblPrice.text = [product getPriceDisplayString];
    self.lblViewCount.text = [NSString stringWithFormat:@"Đã xem: %ld", [product.viewCount integerValue]];
    self.lblInactive.hidden = ![product.isShow boolValue];
}

@end
