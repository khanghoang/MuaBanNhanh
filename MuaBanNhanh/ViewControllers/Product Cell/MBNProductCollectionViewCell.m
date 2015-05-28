//
//  MBNProductCollectionViewCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductCollectionViewCell.h"
#import <NSDate+TimeAgo/NSDate+TimeAgo.h>

@interface MBNProductCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lblUpdateAt;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCategories;
@property (weak, nonatomic) IBOutlet UIView *wrapperView;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewProductImage;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;

@end

@implementation MBNProductCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
    self.wrapperView.layer.cornerRadius = 3.0;
    [self.wrapperView.layer masksToBounds];
    
    self.layer.shadowRadius = 1.0;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0, 1.0);
    self.layer.shadowColor = [UIColor colorFromHexString:@"#aaaaaa"].CGColor;
    self.layer.shouldRasterize = YES;
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    self.btnCall.layer.borderWidth = 1;
    self.btnCall.layer.borderColor = [UIColor colorFromHexString:@"#cccccc"].CGColor;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [@[self.lblUpdateAt, self.lblProductName, self.lblPrice, self.lblCategories] enumerateObjectsUsingBlock:^(UILabel *label, NSUInteger idx, BOOL *stop) {
        label.text = @"";
    }];
    
    self.imageViewProductImage.image = nil;
    [self.btnCall setTitle:@"" forState:UIControlStateNormal];
}

- (void)configWithData:(id)data {
    
    if(![data isKindOfClass:[MBNProduct class]]) {
        return;
    }
    
    MBNProduct *product = data;
    
    // price
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
    
    NSString *priceString = [formatter stringFromNumber:product.price];
    priceString = !priceString ? @"Giá liên hệ" : [NSString stringWithFormat:@"%@ %@", priceString, @"vnđ"];
    
    self.lblPrice.text = priceString;
    
    // update at
    self.lblUpdateAt.text = [NSString stringWithFormat:@"Cập nhật %@", [[product.createdAt timeAgo] lowercaseString]];
    
    // thumb
    [self.imageViewProductImage fp_setImageWithURL:product.defaultThumbnailImage];
    
    // categories
    NSString *concatCategories = @"";
    for(MBNCategory *cat in product.categories) {
        concatCategories = [concatCategories stringByAppendingString:[NSString stringWithFormat:( concatCategories.length == 0 ? @"%@" : @" - %@"), cat.name]];
    }
    self.lblCategories.text = concatCategories;
    
    // name
    self.lblProductName.text = product.name;
    
    // call button
    [self.btnCall setTitle:product.user.phone forState:UIControlStateNormal];
}

- (IBAction)onBtnCall:(id)sender {
    UIButton *buttonCall = (id)sender;
    [[MBNActionsManagers sharedInstance] callNumber:buttonCall.titleLabel.text];
}


@end
