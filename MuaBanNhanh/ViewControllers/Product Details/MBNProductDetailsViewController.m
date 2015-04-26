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

@interface MBNProductDetailsViewController ()

@property (strong, nonatomic) MBNProductDetailsViewModel *viewModel;

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

@end

@implementation MBNProductDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewModel = [[MBNProductDetailsViewModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadProductDetailsAndObserver];
}

- (void)loadProductDetailsAndObserver {
    [self.viewModel loadProductDetailsWithID:self.productID];
    
    RAC(self.lblProductName, text) = [[RACObserve(self.viewModel, product) ignore:nil] map:^id(MBNProduct *product) {
        return product.name;
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
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MBNProductImagesViewController *imagesVC = segue.destinationViewController;
    self.productImagesVC = imagesVC;
}

@end
