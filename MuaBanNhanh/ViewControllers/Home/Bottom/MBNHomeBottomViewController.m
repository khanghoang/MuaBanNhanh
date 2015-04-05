//
//  MBNHomeBottomViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

static CGFloat const PRODUCT_COLLECTION_CELL_HEIGHT = 157;

#import "MBNHomeBottomViewController.h"
#import "MBNProductCollectionViewCell.h"

@interface MBNHomeBottomViewController ()
<
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewLatestProduct;
@property (strong, nonatomic) NSArray *arrLatestProducts;

@end

@implementation MBNHomeBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.collectionViewLatestProduct registerNib:[MBNProductCollectionViewCell nib] forCellWithReuseIdentifier:NSStringFromClass([MBNProductCollectionViewCell class])];
    
    [MBNProductManager getLatestProducts:^(NSArray *arrProducts) {
        
        self.arrLatestProducts = arrProducts;
        [self updateLatestProductsCollection];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateLatestProductsCollection {
    [self.collectionViewLatestProduct reloadData];
    [self.view.superview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((PRODUCT_COLLECTION_CELL_HEIGHT + 10) * self.arrLatestProducts.count + 10));
    }];
    
    [UIView animateWithDuration:0.45 animations:^{
        [self.view.superview layoutIfNeeded];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrLatestProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MBNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNProductCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithData:self.arrLatestProducts[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - 20, PRODUCT_COLLECTION_CELL_HEIGHT);
}


@end
