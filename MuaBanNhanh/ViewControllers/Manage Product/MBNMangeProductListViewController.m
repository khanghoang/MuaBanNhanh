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
#import "MBNProductDetailsViewController.h"
#import <KHTableViewController/KHOrderedDataProvider.h>
#import "MBNShowLoginSegue.h"
#import "MBNNavigationViewController.h"
#import "AppDelegate.h"
#import "MBNCreateProductViewController.h"

@interface MBNMangeProductListViewController ()
<
KHBasicOrderedCollectionViewControllerProtocol,
UICollectionViewDelegate
>

@property (strong, nonatomic) KHCollectionController *collectionController;
@property (strong, nonatomic) KHBasicTableViewModel *collectionViewModel;
@property (strong, nonatomic) NSIndexPath *popupSelectedIndexpath;

@property (strong, nonatomic) LBDelegateMatrioska *chainDelegate;

@end

@implementation MBNMangeProductListViewController

- (instancetype)initWithStringType:(NSString *)type {
    self = [super init];
    if (self) {
        _typeString = type;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self enablePullToRefresh];
    
    id oldDelegate = self.collectionView.delegate;
    self.chainDelegate = [[LBDelegateMatrioska alloc] initWithDelegates:@[oldDelegate, self]];
    self.collectionView.delegate = (id) self.chainDelegate;
}

- (id <KHCollectionViewCellFactoryProtocol> )cellFactory {
    MBNMangeProductCellFactory *cellFactory = [[MBNMangeProductCellFactory alloc] init];
    @weakify(self);
    void (^tapMenuActionBlock)(NSIndexPath *selectedIndexPath, UIButton *menuButton) = ^(NSIndexPath *selectedIndexPath, UIButton *menuButton){
        @strongify(self);
        [self presentPopupMenuForIndexPath:selectedIndexPath fromButton:menuButton];
        self.popupSelectedIndexpath = selectedIndexPath;
//        NSLog(@"%@", [self.collectionController.model itemAtIndexpath:selectedIndexPath]);
    };
    cellFactory.tapMenuButtonActionBlock = tapMenuActionBlock;
    return cellFactory;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    MBNProduct *product = [self.collectionController.model itemAtIndexpath:indexPath];
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    productVC.productID = product.ID;
    [self.navigationController pushViewController:productVC animated:YES];
}

- (id <KHTableViewSectionModel> )getLoadingContentViewModel {
    return [[KHOrderedDataProvider alloc] init];
}

- (id <KHLoadingOperationProtocol> )loadingOperationForSectionViewModel:(id <KHTableViewSectionModel> )viewModel forPage:(NSUInteger)page {
    return [[MBNManageProductLoadOperation alloc] initWithType:self.typeString andPage:page+1];
}

- (void)presentPopupMenuForIndexPath:(NSIndexPath *)indexPath fromButton:(UIButton *)sender
{
    CGRect buttonFrameInCollectionView = [self.navigationController.view convertRect:sender.frame fromView:sender.superview];
    MBNPopupMenuViewController *popupMenuViewController = [[MBNPopupMenuViewController alloc] initWithDestinationFrame:buttonFrameInCollectionView];
    
    [self presentPopupMenuViewController:popupMenuViewController];
    
    @weakify(self);
    @weakify(popupMenuViewController);
    popupMenuViewController.openProductDetailButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @strongify(popupMenuViewController);
        [popupMenuViewController dismissViewControllerAnimated:YES completion:nil];
        MBNProduct *product = [self.collectionController.model itemAtIndexpath:self.popupSelectedIndexpath];
        MBNCreateProductViewController *productVC = [MBNCreateProductViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
        productVC.editingProduct = product;
        [self.navigationController pushViewController:productVC animated:YES];
        return [RACSignal empty];
    }];
    
    popupMenuViewController.editProductButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(popupMenuViewController);
        [popupMenuViewController dismissViewControllerAnimated:YES completion:nil];
        MBNProduct *product = [self.collectionController.model itemAtIndexpath:self.popupSelectedIndexpath];
        MBNCreateProductViewController *vc = [MBNCreateProductViewController tme_instantiateFromStoryboardNamed:@"CreateProduct"];
        MBNNavigationViewController *navVC = [[MBNNavigationViewController alloc] initWithRootViewController:vc];
        vc.editingProduct = product;
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        MBNShowLoginSegue *segue = [[MBNShowLoginSegue alloc] initWithIdentifier:@"MBNLoginSegue" source:appDelegate.rootNavigationController destination:navVC];
        [segue perform];
        return [RACSignal empty];
    }];
    
    popupMenuViewController.removeProductButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        
        @strongify(popupMenuViewController);
        [popupMenuViewController dismissViewControllerAnimated:YES completion:nil];
        
        [SVProgressHUD showWithStatus:@"Đang xoá sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
        MBNProduct *product = [self.collectionController.model itemAtIndexpath:self.popupSelectedIndexpath];
        [MBNProductManager deleteProductWithID:product.ID withCompletion:^(NSString *successString, NSString *errorString) {
            [self reloadAlData];
            if(successString) {
                [SVProgressHUD showSuccessWithStatus:@"Xoá sản phẩm thành công"];
                return;
            }
            
            [SVProgressHUD showErrorWithStatus:errorString];
        }];
        return [RACSignal empty];
    }];
    
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
