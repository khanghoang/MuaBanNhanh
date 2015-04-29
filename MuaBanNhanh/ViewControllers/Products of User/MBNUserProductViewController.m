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
#import "MBNUserProductsContentLoadingViewModel.h"
#import "MBNProductDetailsViewController.h"

@interface MBNUserProductViewController ()
<
UICollectionViewDelegate
>

@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) KHBasicTableViewModel *collectionViewModel;

@property (strong, nonatomic) LBDelegateMatrioska *chainDelegate;

@end

@implementation MBNUserProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // table is just the dump name, it should be collection view
    self.cellFactory = [[MBNProductCellFactory alloc] init];
    [self setEnableRefreshControl:YES];
    
    id oldDelegate = self.collectionView.delegate;
    self.chainDelegate = [[LBDelegateMatrioska alloc] initWithDelegates:@[self, oldDelegate]];
    self.collectionView.delegate = (id) self.chainDelegate;
}

- (id<KHLoadingOperationProtocol>)loadingOperationForSectionViewModel:(id<KHTableViewSectionModel>)viewModel indexes:(NSIndexSet *)indexes {
    MBNUserProductsLoadProductOperation *operation = [[MBNUserProductsLoadProductOperation alloc] initWithIndexes:indexes andUserId:self.user.ID];
    return operation;
}

- (id<KHContentLoadingProtocol, KHTableViewSectionModel>)getLoadingTotalPageObject {
    MBNUserProductsContentLoadingViewModel *loadingTotalItems = [[MBNUserProductsContentLoadingViewModel alloc] initWithUserID:self.user.ID];
    loadingTotalItems.delegate = (id)self;
    [loadingTotalItems loadContent];
    return loadingTotalItems;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProduct *product = [self.collectionController.model itemAtIndexpath:indexPath];
    
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    
    productVC.productID = product.ID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

@end
