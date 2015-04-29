//
//  MBNMangeProductListViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNMangeProductListViewController.h"
#import "MBNManageProductLoadOperation.h"
#import "MBNMangeProductCellFactory.h"
#import "MBNManageProductLoadOperation.h"
#import <KHTableViewController/KHOrderedDataProvider.h>

@interface MBNMangeProductListViewController ()
<
KHBasicOrderedCollectionViewControllerProtocol
>

@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) KHBasicTableViewModel *collectionViewModel;

@end

@implementation MBNMangeProductListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self enablePullToRefresh];
}

- (id <KHCollectionViewCellFactoryProtocol> )cellFactory {
    MBNMangeProductCellFactory *cellFactory = [[MBNMangeProductCellFactory alloc] init];
    return cellFactory;
}

- (id <KHTableViewSectionModel> )getLoadingContentViewModel {
    return [[KHOrderedDataProvider alloc] init];
}

- (id <KHLoadingOperationProtocol> )loadingOperationForSectionViewModel:(id <KHTableViewSectionModel> )viewModel forPage:(NSUInteger)page {
    return [[MBNManageProductLoadOperation alloc] initWithType:@"INACTIVED" andPage:page+1];
}

@end
