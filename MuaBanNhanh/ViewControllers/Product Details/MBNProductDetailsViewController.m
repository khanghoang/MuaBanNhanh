//
//  MBNProductDetailsViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductDetailsViewController.h"
#import "MBNProductDetailsViewModel.h"
#import "MBNProductImagesViewController.h"
#import "MBNUserProductViewController.h"
#import "MBNProductDetailBottomViewController.h"

@interface MBNProductDetailsViewController ()

@property (strong, nonatomic) MBNProductDetailsViewModel *viewModel;
@property (strong, nonatomic) MBNProductDetailBottomViewController *bottomVC;

@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblViewCount;
@property (weak, nonatomic) IBOutlet UILabel *lblCategories;
@property (weak, nonatomic) IBOutlet UILabel *lblCondition;
@property (weak, nonatomic) IBOutlet UILabel *lblCity;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UITextView *txtViewDescription;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintDescriptionHeight;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) MBNProductImagesViewController *productImagesVC;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewCover;
@property (weak, nonatomic) IBOutlet UILabel *lblCreateAt;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomContainerHeightConstraint;

@end

@implementation MBNProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationItem.backBarButtonItem.title = @"Trở về";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.viewModel = [[MBNProductDetailsViewModel alloc] init];
    [self loadProductDetailsAndObserver];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)loadProductDetailsAndObserver {
    [self.viewModel loadProductDetailsWithID:self.productID];
    
    RAC(self, title) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.name;
    }];
    
    RAC(self.lblProductName, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.name;
    }];
    
    RAC(self.lblCreateAt, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        NSDateFormatter *formatter = [MBNProduct sharedDateFormatter];
        return [NSString stringWithFormat:@"Ngày đăng %@", [formatter stringFromDate:product.createdAt]];
    }];
    
    RAC(self.lblViewCount, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return [NSString stringWithFormat:@"Lượt xem (%@)", [product.viewCount stringValue]];
    }];
    
    RAC(self.lblCategories, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return [[product.categories rac_sequence] foldLeftWithStart:@"" reduce:^id(NSString *accumulator, MBNCategory *cat) {
            return [NSString stringWithFormat:@"%@ %@", accumulator, cat.name];
        }];
    }];
    
    RAC(self.lblCondition, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.conditions;
    }];
    
    RAC(self.lblCity, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.province.name;
    }];
    
    RAC(self.lblPrice, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return [product getPriceDisplayString];
    }];
    
    @weakify(self);
    [[RACObserve(self.viewModel, product) ignore:nil] subscribeNext:^(MBNProduct *product) {
        @strongify(self);
        [self.btnCall setTitle:product.user.phone forState:UIControlStateNormal];
    }];
    
    [[RACObserve(self.viewModel, product) ignore:nil] subscribeNext:^(MBNProduct *product) {
        @strongify(self);
        self.txtViewDescription.text = product.des;
        self.constraintDescriptionHeight.constant = [self.txtViewDescription measureHeightOfUITextView];
        [self.view layoutIfNeeded];
        [self.view updateConstraintsIfNeeded];
    }];
    
    [[RACObserve(self.viewModel, product) ignore:nil] subscribeNext:^(MBNProduct *product) {
        @strongify(self);
        if( product.user.avatarImageUrl ) {
            [self.imgViewAvatar setImageWithURL:product.user.avatarImageUrl placeholderImage:[UIImage imageNamed:@"avatar-d"]];
        }
    }];
    
    [[RACObserve(self.viewModel, product) ignore:nil] subscribeNext:^(MBNProduct *product) {
        @strongify(self);
        if( product.user.coverImageUrl ) {
            [self.imgViewCover setImageWithURL:product.user.coverImageUrl placeholderImage:[UIImage imageNamed:@"avatar-d"]];
        }
    }];
    
    RAC(self.lblUsername, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.user.name;
    }];
    
    RAC(self.lblAddress, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return [product getDisplayAddressString];
    }];
    
    [[RACObserve(self.viewModel, product) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        self.productImagesVC.viewModel = self.viewModel;
    }];
    
    RACSignal *arrayProductCountSignal = [[RACObserve(self, bottomVC.listProductCollectionView.contentSize) ignore:nil] map:^id(NSValue *sizeValue) {
        CGFloat height = sizeValue.CGSizeValue.height;
        return @(height < 142 ? 0 : height);
    }];
    
    [arrayProductCountSignal subscribeNext:^(NSNumber *height) {
        @strongify(self);
        self.bottomContainerHeightConstraint.constant = [height floatValue];
        [self.view layoutIfNeeded];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"EmberProductImageSegue"]) {
        MBNProductImagesViewController *imagesVC = segue.destinationViewController;
        self.productImagesVC = imagesVC;
    } else if ([segue.identifier isEqualToString:@"EmberProductBottomSegue"]) {
        MBNProductDetailBottomViewController *bottomVC = segue.destinationViewController;
        self.bottomVC = bottomVC;
        self.bottomVC.user = self.viewModel.product.user;
    }
}

- (IBAction)onBtnCall:(UIButton *)button {
    [[MBNActionsManagers sharedInstance] callNumber:button.titleLabel.text];
}

- (IBAction)onGoToUserProducts:(id)sender {
    MBNUserProductViewController *userProducts = [MBNUserProductViewController tme_instantiateFromStoryboardNamed:@"UserProducts"];
    userProducts.user = self.viewModel.product.user;
    [self.navigationController pushViewController:userProducts animated:YES];
}


@end
