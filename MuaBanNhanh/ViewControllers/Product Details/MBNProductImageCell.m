//
//  MBNProductImageCell.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/26/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductImageCell.h"

@interface MBNProductImageCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation MBNProductImageCell

- (void)configWithData:(MBNImage *)image {
    [self.imageView setImageWithURL:image.imageURL];
}

@end
