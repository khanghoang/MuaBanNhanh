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
#import "INSSearchBar.h"
#import <RMPickerViewController.h>

typedef NS_ENUM(NSInteger, PickerViewType){
    PickerViewTypeCategory = 0,
    PickerViewTypeProvince
};

@interface MBNSearchProductViewController () <UIPickerViewDataSource, UIPickerViewDelegate, INSSearchBarDelegate>

@property (weak, nonatomic) IBOutlet UIButton *categoryPickerButton;
@property (weak, nonatomic) IBOutlet UIButton *provincePickerButton;
@property (weak, nonatomic) IBOutlet UIView *dismissView;
@property (strong, nonatomic) INSSearchBar *searchBar;

@property (strong, nonatomic) MBNProvince *selectedProvince;
@property (strong, nonatomic) MBNCategory *selectedCategory;

@property (strong, nonatomic) MBNSearchProductViewModel *viewModel;
@property (strong, nonatomic) RMPickerViewController *reusePickerViewController;

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
    self.searchDisplayController.displaysSearchBarInNavigationBar = YES;
    [self setupButtonSignal];
    self.searchBar = [[INSSearchBar alloc] initWithFrame:CGRectMake(138, 45, 40, 40)];
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
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
            self.selectedCategory = selectedCategory;
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
            self.selectedProvince = selectedProvince;
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

#pragma mark - INSSearchbarDelegate

- (void)searchBarDidTapReturn:(INSSearchBar *)searchBar
{
    
}

- (void)searchBar:(INSSearchBar *)searchBar willStartTransitioningToState:(INSSearchBarState)destinationState
{
    self.dismissView.hidden = NO;
}

- (CGRect)destinationFrameForSearchBar:(INSSearchBar *)searchBar
{
    CGRect frame = searchBar.frame;
    frame.size.width = 172;
    return frame;
}

- (IBAction)dismissKeyboard:(UITapGestureRecognizer *)sender {
    [self.searchBar hideSearchBar:nil];
    self.dismissView.hidden = YES;
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


@end
