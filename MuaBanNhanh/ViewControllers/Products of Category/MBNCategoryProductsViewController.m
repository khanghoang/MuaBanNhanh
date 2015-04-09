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

@interface MBNCategoryProductsViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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
}

- (id<KHLoadingOperationProtocol>)loadingOperationForSectionViewModel:(id<KHTableViewSectionModel>)viewModel indexes:(NSIndexSet *)indexes {
    MBNLoadProductForCategoryOperation *operation = [[MBNLoadProductForCategoryOperation alloc] initWithIndexes:indexes];
    return operation;
}

- (id<KHContentLoadingProtocol, KHTableViewSectionModel>)getLoadingTotalPageObject {
    MBNContentLoadingViewModel *loadingTotalItems = [[MBNContentLoadingViewModel alloc] init];
    loadingTotalItems.delegate = (id)self;
    [loadingTotalItems loadContent];
    return loadingTotalItems;
}

@end
