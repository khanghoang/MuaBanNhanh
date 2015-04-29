//
//  MBNCategoryProductsViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KHTableViewController/KHBasicOrderedCollectionViewController.h>

@interface MBNCategoryProductsViewController : KHBasicOrderedCollectionViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) MBNCategory *category;

@end
