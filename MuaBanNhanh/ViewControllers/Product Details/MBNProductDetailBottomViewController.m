//
//  MBNProductDetailBottomViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/7/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductDetailBottomViewController.h"
#import "MBNProductDetailsViewController.h"
#import "MBNProductCollectionViewCell.h"
#import "MBNCollectionHeaderView.h"
#import "MBNUserProductViewController.h"

static CGFloat const PRODUCT_COLLECTION_CELL_HEIGHT = 142;

@interface MBNProductDetailBottomViewController ()
<
UICollectionViewDelegate
>

@property (strong, nonatomic) NSArray *arrUserProducts;

@end

@implementation MBNProductDetailBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.listProductCollectionView registerNib:[MBNProductCollectionViewCell nib] forCellWithReuseIdentifier:NSStringFromClass([MBNProductCollectionViewCell class])];
    
    [self.listProductCollectionView registerNib:[MBNCollectionHeaderView nib] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MBNCollectionHeaderView class])];
    
}

- (void)reload {
    [MBNProductManager getProductWithUserID:self.user.ID andPage:0 completeBlock:^(NSArray *arrProduct, NSError *error) {
        self.arrUserProducts = [arrProduct subarrayWithRange:NSMakeRange(0, MIN(4, arrProduct.count))];
        [self.listProductCollectionView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrUserProducts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MBNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNProductCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithData:self.arrUserProducts[indexPath.row]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.bounds.size.width - 20, PRODUCT_COLLECTION_CELL_HEIGHT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    
    MBNCollectionHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([MBNCollectionHeaderView class]) forIndexPath:indexPath];
    
    [header configWithHeaderText:@"Cùng người bán"];
    
    @weakify(self);
    header.btnViewAll.rac_command = [[RACCommand alloc] initWithSignalBlock:^(id _) {
        @strongify(self);
        MBNUserProductViewController *userProducts = [MBNUserProductViewController tme_instantiateFromStoryboardNamed:@"UserProducts"];
        userProducts.user = self.user;
        [self.navigationController pushViewController:userProducts animated:YES];
        return [RACSignal empty];
    }];
    
    return header;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(collectionView.bounds.size.width, 50);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MBNProduct *product = self.arrUserProducts[indexPath.item];
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    productVC.productID = product.ID;
    [self.navigationController pushViewController:productVC animated:YES];
}


@end
