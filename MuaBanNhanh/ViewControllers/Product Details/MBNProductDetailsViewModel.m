//
//  MBNProductDetailsViewModel.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductDetailsViewModel.h"

@interface MBNProductDetailsViewModel()

@property (strong, nonatomic) MBNProduct *product;

@end

@implementation MBNProductDetailsViewModel

- (void)loadProductDetailsWithID:(NSNumber *)productID {
    [MBNProductManager getProductDetailsWithID:productID withCompletion:^(MBNProduct *product, NSError *error) {
        self.product = product;
    }];
}

@end
