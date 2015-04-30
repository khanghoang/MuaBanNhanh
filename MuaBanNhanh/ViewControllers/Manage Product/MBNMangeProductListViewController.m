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
#import "MBNPopupMenuViewController.h"
#import "MBNManageProductCollectionViewCell.h"
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
    @weakify(self);
    void (^tapMenuActionBlock)(NSIndexPath *selectedIndexPath, UIButton *menuButton) = ^(NSIndexPath *selectedIndexPath, UIButton *menuButton){
        @strongify(self);
        [self presentPopupMenuForIndexPath:selectedIndexPath fromButton:menuButton];
        NSLog(@"%@", [self.collectionController.model itemAtIndexpath:selectedIndexPath]);
    };
    cellFactory.tapMenuButtonActionBlock = tapMenuActionBlock;
    return cellFactory;
}

- (id <KHTableViewSectionModel> )getLoadingContentViewModel {
    return [[KHOrderedDataProvider alloc] init];
}

- (id <KHLoadingOperationProtocol> )loadingOperationForSectionViewModel:(id <KHTableViewSectionModel> )viewModel forPage:(NSUInteger)page {
    return [[MBNManageProductLoadOperation alloc] initWithType:@"INACTIVED" andPage:page+1];
}

- (void)presentPopupMenuForIndexPath:(NSIndexPath *)indexPath fromButton:(UIButton *)sender
{
    CGRect buttonFrameInCollectionView = [self.navigationController.view convertRect:sender.frame fromView:sender.superview];
    MBNPopupMenuViewController *popupMenuViewController = [[MBNPopupMenuViewController alloc] initWithDestinationFrame:buttonFrameInCollectionView];
    [self presentPopupMenuViewController:popupMenuViewController];
}

- (void)presentPopupMenuViewController:(MBNPopupMenuViewController *)menuViewController {
    if (IS_IOS8_OR_ABOVE) {
        self.navigationController.providesPresentationContextTransitionStyle = YES;
        self.navigationController.definesPresentationContext = YES;
        [menuViewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    } else {
        [self.navigationController setModalPresentationStyle:UIModalPresentationCurrentContext];
    }
    self.navigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    menuViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:menuViewController animated:YES completion:nil];
}

@end
