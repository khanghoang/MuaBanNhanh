//
//  MBNCategoryProductsViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCategoryProductsViewController.h"
#import "MBNProductCellFactory.h"
#import "MBNLoadProductForCategoryOperation.h"
#import "MBNContentLoadingViewModel.h"
#import "MBNProductDetailsViewController.h"

@interface MBNCategoryProductsViewController ()
<
UICollectionViewDelegate
>

@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) KHBasicTableViewModel *collectionViewModel;

@property (strong, nonatomic) LBDelegateMatrioska *chainDelegate;

@end

@implementation MBNCategoryProductsViewController

- (void)loadView {
    [super loadView];
}

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
    MBNLoadProductForCategoryOperation *operation = [[MBNLoadProductForCategoryOperation alloc] initWithIndexes:indexes andCategoryID:@(0)];
    return operation;
}

- (id<KHContentLoadingProtocol, KHTableViewSectionModel>)getLoadingTotalPageObject {
    MBNContentLoadingViewModel *loadingTotalItems = [[MBNContentLoadingViewModel alloc] init];
    loadingTotalItems.delegate = (id)self;
    [loadingTotalItems loadContent];
    return loadingTotalItems;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProduct *product = [self.collectionViewModel.sectionModel objectAtIndex:indexPath.row];
    
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    
    productVC.productID = product.ID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

@end
