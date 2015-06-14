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
#import "MBNProductDetailsViewController.h"
#import <KHTableViewController/KHOrderedDataProvider.h>

@interface MBNCategoryProductsViewController ()
<
UICollectionViewDelegateFlowLayout,
KHBasicOrderedCollectionViewControllerProtocol,
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
    [self enablePullToRefresh];
    
    id oldDelegate = self.collectionView.delegate;
    self.chainDelegate = [[LBDelegateMatrioska alloc] initWithDelegates:@[self, oldDelegate]];
    self.collectionView.delegate = (id) self.chainDelegate;
    
    [MBNCategoryManager sharedProvider].currentSelectCategory = self.category;
}

- (id <KHCollectionViewCellFactoryProtocol> )cellFactory {
    MBNProductCellFactory *cellFactory = [[MBNProductCellFactory alloc] init];
    return cellFactory;
}

- (id <KHTableViewSectionModel> )getLoadingContentViewModel {
    return [[KHOrderedDataProvider alloc] init];
}

- (id <KHLoadingOperationProtocol> )loadingOperationForSectionViewModel:(id <KHTableViewSectionModel> )viewModel forPage:(NSUInteger)page {
    return [[MBNLoadProductForCategoryOperation alloc] initWithCategoryID:self.category.ID andPage:page+1];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProduct *product = [self.collectionController.model itemAtIndexpath:indexPath];
    
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    
    productVC.productID = product.ID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

@end
