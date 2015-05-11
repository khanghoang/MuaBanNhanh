//
//  MBNSafeBuyCollectionCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/12/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSafeBuyCollectionCell.h"

@interface MBNSafeBuyCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *text;


@end

@implementation MBNSafeBuyCollectionCell

- (void)configWithData:(id)data {
    [self.imageView setImage:[UIImage imageNamed:data[@"image"]]];
    self.text.text = data[@"text"];
}

@end
