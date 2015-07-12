//
//  MBNProductDetailsViewModel.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBNProductDetailsViewModel : NSObject

@property (readonly, nonatomic) MBNProduct *product;

- (void)loadProductDetailsWithID:(NSNumber *)productID;
- (void)loadOwnProductDetailsWithID:(NSNumber *)productID;

@end
