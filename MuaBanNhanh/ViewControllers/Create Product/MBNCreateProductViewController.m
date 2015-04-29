//
//  MBNCreateProductViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCreateProductViewController.h"
#import "MBNSelectCategoryViewController.h"
#import "MBNCreateProductViewModel.h"
#import "MBNPaddingTextField.h"
#import "MBNTextView.h"
#import <RMPickerViewController.h>

typedef NS_ENUM(NSInteger, PickerViewType){
    PickerViewTypeQuality = 0,
    PickerViewTypeCity,
    PickerViewTypeTransaction
};

@interface MBNCreateProductViewController () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet MBNPaddingTextField *productTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *productTitleValidationLabel;
@property (weak, nonatomic) IBOutlet TKDesignableButton *repickCategoryButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *productTransactionTypePickButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *productQualityButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *cityPickButton;
@property (weak, nonatomic) IBOutlet MBNPaddingTextField *productPriceTextField;
@property (weak, nonatomic) IBOutlet MBNTextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *productImagePickButtons;
@property (strong, nonatomic) IBOutletCollection(MBNTextView) NSArray *productImageDescriptionTextViews;

@property (strong, nonatomic) MBNCreateProductViewModel *viewModel;
@property (strong, nonatomic) RMPickerViewController *reusePickerViewController;

@end

@implementation MBNCreateProductViewController

- (RMPickerViewController *)reusePickerViewController
{
    if (!_reusePickerViewController) {
        _reusePickerViewController = [RMPickerViewController pickerController];
        _reusePickerViewController.picker.delegate = self;
        _reusePickerViewController.picker.dataSource = self;
    }
    return _reusePickerViewController;
}

- (MBNCreateProductViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MBNCreateProductViewModel new];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupCommandForButtons];
    [self setupTextFieldBorderLine];
}

- (void)getProvinces {
    [self.viewModel getProvinces];
}

- (void)setupViewModel {
    [[RACObserve(self, viewModel.getProvincesErrorMessage) ignore:nil] subscribeNext:^(NSString *errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    [self getProvinces];
    RAC(self, viewModel.productTitle) = self.productTitleTextField.rac_textSignal;
    RAC(self, viewModel.productDescription) = self.productDescriptionTextView.rac_textSignal;
    RAC(self, viewModel.productPrice) = self.productPriceTextField.rac_textSignal;
    RAC(self, viewModel.productTransactionTypeSelectedIndex) = RACObserve(self, productTransactionTypePickButton.tag);
    RAC(self, viewModel.productQualitySelectedIndex) = RACObserve(self, productQualityButton.tag);
    RAC(self, viewModel.provinceSelectedIndex) = RACObserve(self, cityPickButton.tag);
    RAC(self, productTitleValidationLabel.hidden) = [self.productTitleTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
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

- (void)addBorderLineToView:(UIView *)view
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
}

- (void)setupCommandForButtons {
    @weakify(self);
    self.repickCategoryButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        MBNSelectCategoryViewController *vc = [[UIStoryboard storyboardWithName:@"SelectCategory" bundle:nil] instantiateViewControllerWithIdentifier:NSStringFromClass([MBNSelectCategoryViewController class])];
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal empty];
    }];
    self.productQualityButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Chọn tráng thái sản phẩm" pickerType:PickerViewTypeQuality selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            [sender setTitle:self.viewModel.productQualityTitles[selectedRow] forState:UIControlStateNormal];
            sender.tag = selectedRow;
        } sender:sender];
        return [RACSignal empty];
    }];
    self.cityPickButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Chọn thành phố" pickerType:PickerViewTypeCity selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            MBNProvince *selectedProvince = self.viewModel.provinces[selectedRow];
            [sender setTitle:selectedProvince.name forState:UIControlStateNormal];
            sender.tag = selectedRow;
        } sender:sender];

        return [RACSignal empty];
    }];
    self.productTransactionTypePickButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Chọn loại giao dịch" pickerType:PickerViewTypeTransaction selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            [sender setTitle:self.viewModel.productTransactionTypeTitles[selectedRow] forState:UIControlStateNormal];
            sender.tag = selectedRow;
        } sender:sender];

        return [RACSignal empty];
    }];
    
    [self.productImagePickButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
        //Will reuse some commands here
        button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }];
}

- (void)setupTextFieldBorderLine {
    @weakify(self);
    [@[self.productTitleTextField, self.productPriceTextField, self.productDescriptionTextView] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        [self addBorderLineToView:view];
    }];
    [self.productImageDescriptionTextViews enumerateObjectsUsingBlock:^(UITextView *textView, NSUInteger idx, BOOL *stop) {
        @strongify(self);
        [self addBorderLineToView:textView];
    }];
}

#pragma mark - UIPickerViewDatasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (pickerView.tag) {
        case PickerViewTypeCity:
            return self.viewModel.provinces.count;
        case PickerViewTypeQuality:
        case PickerViewTypeTransaction:
            return 2;
        default:
            return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == PickerViewTypeCity) {
        MBNProvince *province = self.viewModel.provinces[row];
        return province.name;
    } else if (pickerView.tag == PickerViewTypeQuality) {
        return self.viewModel.productQualityTitles[row];
    } else {
        return self.viewModel.productTransactionTypeTitles[row];
    }
}

@end
