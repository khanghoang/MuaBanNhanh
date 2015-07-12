//
//  MBNProductDetailsViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNProductDetailsViewController : UIViewController

@property (strong, nonatomic) NSNumber *productID;

// own product will call different API with
// the normal product details API
@property (assign, nonatomic) BOOL isOwnProduct;

@end
