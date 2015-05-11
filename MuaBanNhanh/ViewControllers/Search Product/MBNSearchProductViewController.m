//
//  MBNSearchProductViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 5/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSearchProductViewController.h"
#import "MBNSearchProductViewModel.h"
#import "MBNProvinceManager.h"
#import "MBNProductCollectionViewCell.h"
#import "MBNProductCellFactory.h"
#import "MBNProductDetailsViewController.h"
#import <RMPickerViewController.h>

typedef NS_ENUM(NSInteger, PickerViewType){
    PickerViewTypeCategory = 0,
    PickerViewTypeProvince
};

@interface MBNSearchProductViewController ()
<UIPickerViewDataSource,
UIPickerViewDelegate,
UISearchBarDelegate,
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *provincePickerButton;
@property (weak, nonatomic) IBOutlet UIView *dismissView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) MBNSearchProductViewModel *viewModel;
@property (strong, nonatomic) RMPickerViewController *reusePickerViewController;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;

@end

@implementation MBNSearchProductViewController

- (RMPickerViewController *)reusePickerViewController
{
    if (!_reusePickerViewController) {
        _reusePickerViewController = [RMPickerViewController pickerController];
        _reusePickerViewController.picker.delegate = self;
        _reusePickerViewController.picker.dataSource = self;
    }
    return _reusePickerViewController;
}

- (MBNSearchProductViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[MBNSearchProductViewModel alloc] init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupButtonSignal];
    [self observeViewModelSignal];
    [self registerNibCollectionView];
}

- (void)observeViewModelSignal {
    @weakify(self);
    [[RACObserve(self, viewModel.products) ignore:nil] subscribeNext:^(NSArray *products) {
        @strongify(self);
        if (products.count == 0) {
            self.infoLabel.hidden = NO;
            self.infoLabel.text = @"Không có sản phẩm";
        } else {
            self.infoLabel.hidden = YES;
            [self.productCollectionView reloadData];
        }
    }];
}

- (void)setupButtonSignal {
    @weakify(self);
    self.categoryPickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Chuyên mục" pickerType:PickerViewTypeCategory selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            MBNCategory *selectedCategory = self.viewModel.categories[selectedRow];
            self.viewModel.selectedCategory = selectedCategory;
            [sender setTitle:selectedCategory.name forState:UIControlStateNormal];
            sender.tag = selectedRow;
        } sender:sender];
        return [RACSignal empty];
    }];
    self.provincePickerButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Tỉnh thành" pickerType:PickerViewTypeProvince selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            MBNProvince *selectedProvince = self.viewModel.provinces[selectedRow];
            self.viewModel.selectedProvince = selectedProvince;
            [sender setTitle:selectedProvince.name forState:UIControlStateNormal];
            sender.tag = selectedRow;
        } sender:sender];
        return [RACSignal empty];
    }];
}

- (void)showPickerViewControllerWithTitle:(NSString *)title
                               pickerType:(PickerViewType)type
                       selectButtonAction:(void(^)(RMPickerViewController *controller, NSArray *rows))selectButtonHandler
                                   sender:(UIButton *)sender
{
    self.reusePickerViewController.titleLabel.text = title;
    self.reusePickerViewController.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    self.reusePickerViewController.picker.tag = type;
    [self.reusePickerViewController setSelectButtonAction:selectButtonHandler];
    [self.reusePickerViewController.picker reloadAllComponents];
    [self.reusePickerViewController.picker selectRow:sender.tag inComponent:0 animated:NO];
    [self presentViewController:self.reusePickerViewController animated:YES completion:nil];
}

- (void)registerNibCollectionView {
    [self.productCollectionView registerNib:[MBNProductCollectionViewCell nib] forCellWithReuseIdentifier:[MBNProductCollectionViewCell kind]];
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case PickerViewTypeProvince:
            return self.viewModel.provinces.count;
        case PickerViewTypeCategory:
            return self.viewModel.categories.count;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == PickerViewTypeProvince) {
        MBNProvince *province = self.viewModel.provinces[row];
        return province.name;
    } else {
        MBNCategory *category = self.viewModel.categories[row];
        return category.name;
    }
}

#pragma mark - UICollectionViewProtocol

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(300, 142);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBNProductCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MBNProductCollectionViewCell kind] forIndexPath:indexPath];
    [cell configWithData:self.viewModel.products[indexPath.item]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.products.count;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProduct *product = self.viewModel.products[indexPath.item];
    
    MBNProductDetailsViewController *productVC = [MBNProductDetailsViewController tme_instantiateFromStoryboardNamed:@"ProductDetails"];
    
    productVC.productID = product.ID;
    
    [self.navigationController pushViewController:productVC animated:YES];
}

#pragma mark - UISearchBarProtocol

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    self.dismissView.hidden = NO;
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (!self.viewModel.selectedCategory) {
        self.infoLabel.hidden = NO;
        self.infoLabel.text = @"Chưa chọn chuyên mục";
    } else if (!self.viewModel.selectedProvince) {
        self.infoLabel.hidden = NO;
        self.infoLabel.text = @"Chưa chọn tỉnh thành";
    } else {
        self.infoLabel.hidden = YES;
        [self.viewModel searchProductsWithKeyWord:searchBar.text];
        [self.view endEditing:YES];
        self.dismissView.hidden = YES;
    }
}

- (void)dismissKeyboard:(UIGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
    gestureRecognizer.view.hidden = YES;
}

@end
