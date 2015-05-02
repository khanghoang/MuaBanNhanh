//
//  MBNSelectCategoryViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/29/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSelectCategoryViewController.h"
#import "MBNCreateProductViewModel.h"
#import "MBNExpandableTableCell.h"
#import "MBNSelectedTagCell.h"
#import "MBNExpandableTableHeader.h"
#import "MBNSelectCategoryViewModel.h"

typedef NS_ENUM(NSInteger, TableViewTagType) {
    TableViewTagTypeListSelectedCategory,
    TableViewTagTypeListCategory
};

@interface MBNSelectCategoryViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet TKDesignableButton *saveButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITableView *listCategoryTableView;
@property (weak, nonatomic) IBOutlet UIImageView *noSelectedCategoryWarningImage;
@property (weak, nonatomic) IBOutlet UITableView *listSelectedCategoryTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *listCategoryTableViewHeightConstraint;

@property (assign, nonatomic) NSInteger openingSection;
@property (strong, nonatomic) MBNSelectCategoryViewModel *viewModel;

@end

@implementation MBNSelectCategoryViewController

- (MBNSelectCategoryViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MBNSelectCategoryViewModel new];
    }
    return _viewModel;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.openingSection = -1; //Prevent case opening section = 0 when nil
    [self registerNibTableView];
    [self setupSignals];
}

- (void)registerNibTableView
{
    [self.listCategoryTableView registerNib:[MBNExpandableTableHeader nib] forHeaderFooterViewReuseIdentifier:[MBNExpandableTableHeader kind]];
}

- (void)setupSignals
{
    [self setupButtonSignal];
    [self setupObserveViewModelSignal];
    [self setupAutoExpandTableViewSignal];
}

- (void)setupButtonSignal
{
    @weakify(self);
    self.saveButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        self.createProductViewModel.selectedCategories = [[NSMutableArray alloc] initWithArray:self.viewModel.selectedCategories copyItems:YES];
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
    self.cancelButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
        return [RACSignal empty];
    }];
}

- (void)setupObserveViewModelSignal
{
    @weakify(self);
    [[RACObserve(self, viewModel.categories) ignore:nil] subscribeNext:^(NSArray *categories) {
        @strongify(self);
        [self.listCategoryTableView reloadData];
    }];
    [[RACObserve(self, viewModel.pullCategoriesErrorMessage) ignore:nil] subscribeNext:^(NSString *errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    [self.viewModel pullCategories];

    RACSignal *selectedCategoriesChangeSignal = [RACObserve(self, viewModel.selectedCategories) ignore:nil];
    [selectedCategoriesChangeSignal subscribeNext:^(NSArray *selectedCategories) {
        @strongify(self);
        [self.listSelectedCategoryTableView reloadData];
    }];
    RAC(self, noSelectedCategoryWarningImage.hidden) = [selectedCategoriesChangeSignal map:^id(NSArray *selectedCategories) {
        return @(selectedCategories.count);
    }];
    self.viewModel.selectedCategories = [[NSMutableArray alloc] initWithArray:self.createProductViewModel.selectedCategories copyItems:YES];
}

- (void)setupAutoExpandTableViewSignal
{
    RACSignal *changeListCategoryTableHeightSignal = [RACObserve(self, listCategoryTableView.contentSize) map:^id(NSValue *contentSizeValue) {
        return @([contentSizeValue CGSizeValue].height);
    }];
    RAC(self, listCategoryTableViewHeightConstraint.constant) = changeListCategoryTableHeightSignal;
    @weakify(self);
    [changeListCategoryTableHeightSignal subscribeNext:^(id x) {
        @strongify(self);
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Table View Cell Datasource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @weakify(self);
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        MBNSelectedTagCell *cell = [tableView dequeueReusableCellWithIdentifier:[MBNSelectedTagCell kind]];
        cell.tagNameLabel.text = [self.viewModel.selectedCategories[indexPath.row] name];
        cell.closeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
            @strongify(self);
            NSMutableArray *selectedCategories = [self.viewModel mutableArrayValueForKey:@"selectedCategories"];
            [selectedCategories removeObjectAtIndex:indexPath.row];
            return [RACSignal empty];
        }];
        return cell;
    }
    MBNExpandableTableCell *cell = [tableView dequeueReusableCellWithIdentifier:[MBNExpandableTableCell kind]];
    MBNCategory *category = self.viewModel.categories[indexPath.section];
    MBNCategory *subCategory = category.subCategories[indexPath.row];
    cell.cellNameLabel.text = subCategory.name;
    RACSignal *seletedCategoriesChagingSignal = [[RACObserve(self, viewModel.selectedCategories) ignore:nil] takeUntil:cell.rac_prepareForReuseSignal];
    [seletedCategoriesChagingSignal subscribeNext:^(NSArray *selectedCategories) {
        if ([selectedCategories containsObject:subCategory]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        } else {
            cell.selected = NO;
        }
    }];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return 46.0f;
    }
    return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return self.viewModel.selectedCategories.count;
    }
    if (section == self.openingSection) {
        MBNCategory *category = self.viewModel.categories[section];
        return category.subCategories.count;
    } else {
        return 0;
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return nil;
    }
    if (self.viewModel.selectedCategories.count == 3) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chỉ được chọn tối đa 3 chuyên mục"];
        return nil;
    }
    MBNCategory *category = self.viewModel.categories[indexPath.section];
    MBNCategory *subCategory = category.subCategories[indexPath.row];
    NSMutableArray *selectedCategories = [self.viewModel mutableArrayValueForKey:@"selectedCategories"];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if([self.viewModel.selectedCategories containsObject:subCategory]) {
        return nil;
    }
    
    [cell setSelected:YES];
    
    [selectedCategories addObject:subCategory];
    return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return nil;
    }
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    MBNCategory *category = self.viewModel.categories[indexPath.section];
    MBNCategory *subCategory = category.subCategories[indexPath.row];
    NSMutableArray *selectedCategories = [self.viewModel mutableArrayValueForKey:@"selectedCategories"];
    if([self.viewModel.selectedCategories containsObject:subCategory]) {
        cell.selected = NO;
        [selectedCategories removeObject:subCategory];
        return indexPath;
    }
    return nil;
}

#pragma mark - Table View Header Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return 1;
    }
    return self.viewModel.categories.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return 0.0f;
    }
    return 44.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag == TableViewTagTypeListSelectedCategory) {
        return nil;
    }
    MBNExpandableTableHeader *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:[MBNExpandableTableHeader kind]];
    MBNCategory *category = self.viewModel.categories[section];
    headerView.headerNameLabel.text = category.name;
    headerView.tag = section;
    @weakify(self);
    headerView.headerSelectedButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        [self clickedOnSection:section];
        return [RACSignal empty];
    }];
    RACSignal *changeOpeningSectionSignal = [RACObserve(self, openingSection) takeUntil:headerView.rac_prepareForReuseSignal];
    RAC(headerView, headerSelectedButton.backgroundColor) = [changeOpeningSectionSignal map:^id(NSNumber *openingSection) {
        return [openingSection integerValue] == section ? [UIColor colorFromHexString:@"#EFEFEF"] : [UIColor whiteColor];
    }];
    RAC(headerView, headerSeparatorView.hidden) = [changeOpeningSectionSignal map:^id(NSNumber *openingSection) {
        return @([openingSection integerValue] == section);
    }];
    RAC(headerView, arrowIconImageView.image) = [changeOpeningSectionSignal map:^id(NSNumber *openingSection) {
        return [openingSection integerValue] == section ? [UIImage imageNamed:@"up-arrow-icon"] : [UIImage imageNamed:@"down-arrow-icon"];
    }];
    return headerView;
}

#pragma mark - Expand Collapse handle

- (void)clickedOnSection:(NSInteger)section
{
    NSInteger openingSection = self.openingSection; //Keep opening section before reset it
    [self collapseSection:section];
    if (openingSection != section) {
        [self expandSection:section];
    }
}

- (void)expandSection:(NSInteger)section
{
    MBNCategory *currentCategory = self.viewModel.categories[section];
    NSArray *indexPathsToInsert = [self indexPathsForSection:section withNumberOfRows:currentCategory.subCategories.count];
    self.openingSection = section;
    [self.listCategoryTableView beginUpdates];
    [self.listCategoryTableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationFade];
    [self.listCategoryTableView endUpdates];
}

- (void)collapseSection:(NSInteger)section
{
    if (self.openingSection == -1) {
        return;
    }
    MBNCategory *currentCategory = self.viewModel.categories[self.openingSection];
    NSArray *indexPathsToDelete = [self indexPathsForSection:self.openingSection withNumberOfRows:currentCategory.subCategories.count];
    self.openingSection = -1;
    [self.listCategoryTableView beginUpdates];
    [self.listCategoryTableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationFade];
    [self.listCategoryTableView endUpdates];
}

- (NSArray *)indexPathsForSection:(NSInteger)section withNumberOfRows:(NSInteger)numberOfRows {
    NSMutableArray *indexPaths = [NSMutableArray new];
    for (NSInteger i = 0; i < numberOfRows; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:section];
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

@end
