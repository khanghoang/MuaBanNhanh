//
//  MBNUserProductViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNUserProductViewController.h"
#import "MBNProductCellFactory.h"
#import "MBNUserProductsLoadProductOperation.h"
#import "MBNProductDetailsViewController.h"
#import "MBNUserProductHeaderCollectionReusableView.h"
#import <KHTableViewController/KHOrderedDataProvider.h>

@interface MBNUserProductViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
KHBasicOrderedCollectionViewControllerProtocol,
UICollectionViewDelegate
>

@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) KHBasicTableViewModel *collectionViewModel;

@property (strong, nonatomic) LBDelegateMatrioska *chainDelegate;
@property (strong, nonatomic) LBDelegateMatrioska *chainDatasource;

@end

@implementation MBNUserProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = self.user.name;
    
    // table is just the dump name, it should be collection view
    [self enablePullToRefresh];
    
    id oldDatasource = self.collectionView.dataSource;
    self.chainDatasource = [[LBDelegateMatrioska alloc] initWithDelegates:@[oldDatasource, self]];
    self.collectionView.dataSource = (id) self.chainDatasource;
    
    id oldDelegate = self.collectionView.delegate;
    self.chainDelegate = [[LBDelegateMatrioska alloc] initWithDelegates:@[oldDelegate, self]];
    self.collectionView.delegate = (id) self.chainDelegate;
}

- (id <KHCollectionViewCellFactoryProtocol> )cellFactory {
    MBNProductCellFactory *cellFactory = [[MBNProductCellFactory alloc] init];
    return cellFactory;
}

- (id <KHTableViewSectionModel> )getLoadingContentViewModel {
    return [[KHOrderedDataProvider alloc] init];
}

- (id <KHLoadingOperationProtocol> )loadingOperationForSectionViewModel:(id <KHTableViewSectionModel> )viewModel forPage:(NSUInteger)page {
    return [[MBNUserProductsLoadProductOperation alloc] initWithUserID:self.user.ID andPage:page+1];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProduct *product = [self.collectionController.model itemAtIndexpath:indexPath];
    
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    
    productVC.productID = product.ID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    MBNUserProductHeaderCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"MBNUserProductHeaderCollectionReusableView" forIndexPath:indexPath];
    [header configWithUser:self.user];
    return header;
}

@end
