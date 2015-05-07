//
//  MBNProductDetailBottomViewController.h
//  MuaBanNhanh
//
//  Created by iSlan on 5/7/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MBNProductDetailBottomViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *listProductCollectionView;
@property (strong, nonatomic) MBNUser *user;

@end
