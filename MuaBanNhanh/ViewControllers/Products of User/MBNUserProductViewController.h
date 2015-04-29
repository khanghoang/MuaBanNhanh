//
//  MBNUserProductViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KHTableViewController/KHBasicOrderedCollectionViewController.h>
#import <KHTableViewController/KHBasicFluentCollectionViewController.h>

@interface MBNUserProductViewController :KHBasicOrderedCollectionViewController

@property (strong, nonatomic) MBNUser *user;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
