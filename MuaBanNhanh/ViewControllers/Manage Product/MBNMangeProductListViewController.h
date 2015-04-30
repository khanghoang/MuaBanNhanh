//
//  MBNMangeProductListViewController.h
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KHTableViewController/KHBasicOrderedCollectionViewController.h>

@interface MBNMangeProductListViewController : KHBasicOrderedCollectionViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *typeString;

- (instancetype)initWithStringType:(NSString *)type;

@end
