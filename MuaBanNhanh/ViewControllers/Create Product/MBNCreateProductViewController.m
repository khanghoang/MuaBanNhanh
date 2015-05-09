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
#import "MBNTagCell.h"
#import "TMEPhotoButton.h"
#import "MBNImage.h"
#import "AFHTTPRequestOperationManager+Helper.h"
#import <RMPickerViewController.h>

typedef NS_ENUM(NSInteger, PickerViewType){
    PickerViewTypeQuality = 0,
    PickerViewTypeCity,
    PickerViewTypeTransaction
};

@interface MBNCreateProductViewController ()
<UIPickerViewDelegate, UIPickerViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,
UIActionSheetDelegate,
UITextViewDelegate
>

@property (weak, nonatomic) IBOutlet MBNPaddingTextField *productTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *productTitleValidationLabel;
@property (weak, nonatomic) IBOutlet TKDesignableButton *repickCategoryButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *productTransactionTypePickButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *productQualityButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *cityPickButton;
@property (weak, nonatomic) IBOutlet MBNPaddingTextField *productPriceTextField;
@property (weak, nonatomic) IBOutlet MBNTextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UICollectionView *tagCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagCollectionViewHeightConstraint;
@property (weak, nonatomic) UIButton *selectedButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *productImagePickButtons;
@property (strong, nonatomic) IBOutletCollection(MBNTextView) NSArray *productImageDescriptionTextViews;

@property (nonatomic, strong) UINavigationController *cameraVC;

@property (strong, nonatomic) MBNCreateProductViewModel *viewModel;
@property (strong, nonatomic) RMPickerViewController *reusePickerViewController;

@property (strong, nonatomic) NSOperationQueue *createProductOperationQueue;

@property (strong, nonatomic) NSMutableArray *productImages;

@property (strong, nonatomic) NSDictionary *selectedProductQuality;
@property (strong, nonatomic) NSDictionary *selectedProductTransactionType;
@property (strong, nonatomic) MBNProvince *selectedProvince;

@property (weak, nonatomic) IBOutlet UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *arrCaptions;

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

- (NSMutableArray *)productImages {
    if (!_productImages) {
        _productImages = [@[[NSNull null], [NSNull null], [NSNull null], [NSNull null], [NSNull null]] mutableCopy];
    }
    
    return _productImages;
}

- (MBNCreateProductViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [MBNCreateProductViewModel new];
    }
    return _viewModel;
}

- (NSOperationQueue *)createProductOperationQueue {
    if (!_createProductOperationQueue) {
        _createProductOperationQueue = [[NSOperationQueue alloc] init];
    }
    
    return _createProductOperationQueue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewModel];
    [self setupCommandForButtons];
    [self setupTextFieldBorderLine];
    [self setupCollectionViewHeightChangingSignal];
    [self registerForKeyboardNotifications];
    
    [self updateUIIfEditingProduct];
}

- (void)updateUIIfEditingProduct {
    if (!self.editingProduct) {
        return;
    }
    
//    NSArray *provinceList = [[[MBNProvinceManager sharedManager] provinces] select:^BOOL(MBNProvince *province) {
//        return [province.ID isEqual:self.editingProduct.province.ID];
//    }];
    
    [SVProgressHUD showWithStatus:@"Đang tải thông tin sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    
    [MBNProductManager getProductDetailsWithID:self.editingProduct.ID withCompletion:^(MBNProduct *product, NSError *error) {
        self.editingProduct = product;
        
        [SVProgressHUD dismiss];
        
        self.selectedProductTransactionType = self.editingProduct.isSale ? @{@"Cần bán/ Dịch vụ" : @0} : @{@"Cần mua/ Cần tìm" : @1};
        self.selectedProductQuality = self.viewModel.productQualityDictionary[self.editingProduct.conditions] ? self.viewModel.productQualityDictionary[self.editingProduct.conditions] : @{@"Mới 100%" : @0};
        
        self.selectedProvince = self.editingProduct.province;
        
        self.productTitleTextField.text = self.editingProduct.name;
        
        [self.productTransactionTypePickButton setTitle:[[self.selectedProductTransactionType allKeys] firstObject] forState:UIControlStateNormal];
    
        
        [self.cityPickButton setTitle:self.selectedProvince.name forState:UIControlStateNormal];
        
        [self.productQualityButton setTitle:[[self.selectedProductQuality allKeys] firstObject] forState:UIControlStateNormal];
        
        self.productPriceTextField.text = [self.editingProduct.price stringValue];
        self.productDescriptionTextView.text = self.editingProduct.des;
        
        self.viewModel.selectedCategories = [self.editingProduct.categories mutableCopy];
        
        [self.editingProduct.gallery enumerateObjectsUsingBlock:^(MBNImage *image, NSUInteger idx, BOOL *stop) {
            
            [self.productImagePickButtons[idx] setBackgroundImageForState:UIControlStateNormal withURL:[self.editingProduct.gallery[idx] imageURL]];
            UITextView *textView = (UITextView *) self.arrCaptions[idx];
            [textView setText:[self.editingProduct.gallery[idx] caption]];
            
            [self.productImages replaceObjectAtIndex:idx withObject:image];
        }];
    }];
    
}

- (UINavigationController *)cameraVC {
    if (!_cameraVC) {
        _cameraVC = [[UIStoryboard storyboardWithName:@"Camera" bundle:nil] instantiateInitialViewController];
        TMECameraVC *topVC = [_cameraVC.viewControllers firstObject];
        @weakify(self);
        topVC.completionHandler = ^(TMECameraVCResult result, UIImage *image, IMGLYFilterType filterType) {
            @strongify(self);
            [self showEditorVCWithImage:image button:self.selectedButton];
        };
    }
    
    return _cameraVC;
}

- (void)setupViewModel {
    [[RACObserve(self, viewModel.getProvincesErrorMessage) ignore:nil] subscribeNext:^(NSString *errorMessage) {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
    RAC(self, viewModel.productTitle) = self.productTitleTextField.rac_textSignal;
    RAC(self, viewModel.productDescription) = self.productDescriptionTextView.rac_textSignal;
    RAC(self, viewModel.productPrice) = self.productPriceTextField.rac_textSignal;
    RAC(self, viewModel.productTransactionTypeSelectedIndex) = RACObserve(self, productTransactionTypePickButton.tag);
    RAC(self, viewModel.productQualitySelectedIndex) = RACObserve(self, productQualityButton.tag);
    RAC(self, viewModel.provinceSelectedIndex) = RACObserve(self, cityPickButton.tag);
    RAC(self, productTitleValidationLabel.hidden) = [self.productTitleTextField.rac_textSignal map:^id(NSString *text) {
        return @(text.length);
    }];
    @weakify(self);
    [RACObserve(self, viewModel.selectedCategories) subscribeNext:^(NSArray *selectedCategories) {
        @strongify(self);
        [self.tagCollectionView reloadData];
    }];
}

- (void)setupCollectionViewHeightChangingSignal
{
    RACSignal *collectionViewHeightChangingSignal = [[RACObserve(self, tagCollectionView.contentSize) map:^id(NSValue *collectionViewContentSizeValue) {
        return @(collectionViewContentSizeValue.CGSizeValue.height);
    }] ignore:nil];
    RAC(self, tagCollectionViewHeightConstraint.constant) = collectionViewHeightChangingSignal;
    @weakify(self);
    [collectionViewHeightChangingSignal subscribeNext:^(NSNumber *contentSizeHeight) {
        @strongify(self);
        [self.view layoutIfNeeded];
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
        vc.createProductViewModel = self.viewModel;
        [self.navigationController pushViewController:vc animated:YES];
        return [RACSignal empty];
    }];
    self.productQualityButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        @weakify(self);
        [self showPickerViewControllerWithTitle:@"Chọn trạng thái sản phẩm" pickerType:PickerViewTypeQuality selectButtonAction:^(RMPickerViewController *controller, NSArray *rows) {
            @strongify(self);
            NSInteger selectedRow = [rows.lastObject integerValue];
            NSArray *allKeys = [self.viewModel.productQualityDictionary allKeys];
            NSString *selectedKey = [allKeys reverse][selectedRow];
            [sender setTitle:selectedKey forState:UIControlStateNormal];
            sender.tag = selectedRow;
            self.selectedProductQuality = @{selectedKey : @(selectedRow)};
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
            self.selectedProvince = selectedProvince;
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
            NSArray *allKeys = [self.viewModel.productTransactionTypeDictionary allKeys];
            NSString *selectedKey = allKeys[selectedRow];
            [sender setTitle:selectedKey forState:UIControlStateNormal];
            sender.tag = selectedRow;
            self.selectedProductTransactionType = @{selectedKey : @(selectedRow)};
        } sender:sender];

        return [RACSignal empty];
    }];
    
    [self.productImagePickButtons enumerateObjectsUsingBlock:^(TMEPhotoButton *button, NSUInteger idx, BOOL *stop) {
        
        //Will reuse some commands here
        button.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }];
}

- (void)deleteImageOfButton:(UIButton *)button {
//    UIImage *oldImage = button.imageView.image;
    [button setBackgroundImage:[UIImage imageNamed:@"add-thumbnail"] forState:UIControlStateNormal];
    [self.productImages removeObjectAtIndex:[self.productImagePickButtons indexOfObject:button]];
}

- (IBAction)onBtnClickPickImage:(id)button {
    
    self.selectedButton = button;
    
    if (IS_IOS8_OR_ABOVE) {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        @weakify(self);
        UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:@"Chọn hình hoặc chụp hình" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self);
            [self.navigationController presentViewController:self.cameraVC animated:YES completion:nil];
        }];
            
        UIAlertAction *deletePhoto = [UIAlertAction actionWithTitle:@"Xoá tấm hình này" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            @strongify(self);
            [self deleteImageOfButton:button];
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Huỷ" style:UIAlertActionStyleCancel handler:nil];
                                     
                                    
        [actionSheet addAction:takePhoto];
        [actionSheet addAction:deletePhoto];
        [actionSheet addAction:cancel];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Huỷ" destructiveButtonTitle:nil otherButtonTitles:@"Chọn hình hoặc chụp hình", @"Xoá tấm hình này", nil];
        [actionSheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    // choose image or take it
    if (buttonIndex == 0) {
        [self.navigationController presentViewController:self.cameraVC animated:YES completion:nil];
    } else {
        [self deleteImageOfButton:self.selectedButton];
    }
}

- (void)showEditorVCWithImage:(UIImage *)image button:(UIButton *)button
{
    TMECropImageVC *cropVC = [[TMECropImageVC alloc] init];
    cropVC.inputImage = image;
    
    TMECameraVC *cameraVC = [self.cameraVC.viewControllers firstObject];
    
    @weakify(self);
    cropVC.completionHandler = ^(IMGLYEditorViewControllerResult result, UIImage *outputImage, IMGLYProcessingJob *job) {
        @strongify(self);
        if (result == IMGLYEditorViewControllerResultCancelled) {
            [cameraVC restartCamera];
            [cameraVC.navigationController popViewControllerAnimated:YES];
        } else {
            [self handleTakenImage:outputImage button:button];
            [self.cameraVC dismissViewControllerAnimated:YES completion:nil];
            [self.productImages replaceObjectAtIndex:[self.productImagePickButtons indexOfObject:button] withObject:outputImage];
    }
    };
    
    [self.cameraVC pushViewController:cropVC animated:YES];
}

#pragma mark - Helpers
- (void)handleTakenImage:(UIImage *)image button:(UIButton *)button
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    [button setBackgroundImage:[image imgly_rotateImageToMatchOrientation] forState:UIControlStateNormal];
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
        return [self.viewModel.productQualityDictionary allKeysForObject:@(row)].lastObject;
    } else {
        return [self.viewModel.productTransactionTypeDictionary allKeysForObject:@(row)].lastObject;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MBNTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[MBNTagCell kind] forIndexPath:indexPath];
    [cell configWithString:[self.viewModel.selectedCategories[indexPath.item] name]];
    cell.tagButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        NSMutableArray *selectedCategories = [self.viewModel mutableArrayValueForKey:@"selectedCategories"];
        [selectedCategories removeObjectAtIndex:indexPath.item];
        return [RACSignal empty];
    }];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.selectedCategories.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [MBNTagCell getCellSizeWithString:[self.viewModel.selectedCategories[indexPath.item] name]];
}

- (IBAction)onBtnCreateProduct:(id)sender {
    
    dispatch_group_t group = dispatch_group_create();
    
    __block NSMutableArray *arrOperations = [NSMutableArray array];
    NSArray *productImages = [self.productImages copy];
    __block NSMutableArray *uploadedURLs = [[[productImages select:^BOOL(id object) {
        return ![object isEqual:[NSNull null]];
    }] map:^id(id object) {
        return @"";
    }] mutableCopy];
    
    if (self.viewModel.selectedCategories.count == 0) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chưa chọn danh mục"];
        return;
    }
    
    if ([self.productTitleTextField.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chưa nhập tên sản phẩm"];
        return;
    }
    
    if ([self.productQualityButton.titleLabel.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chưa chọn tình trạng sản phẩm"];
        return;
    }
    
    if ([self.cityPickButton.titleLabel.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chưa chọn tỉnh thành"];
        return;
    }
    
    if ([self.productTransactionTypePickButton.titleLabel.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"Bạn chưa chọn loại sản phẩm"];
        return;
    }
    
    self.productImages = [[self.productImages select:^BOOL(id object) {
        return ![object isEqual:[NSNull null]];
    }] mutableCopy];
    
    [SVProgressHUD showWithStatus:@"Đang đăng sản phẩm" maskType:SVProgressHUDMaskTypeGradient];
    
    @weakify(self);
    
    NSOperation *operation3 = [NSBlockOperation blockOperationWithBlock:^{
        @strongify(self);
        
        NSArray *arr = [uploadedURLs map:^id(id url) {
            NSDictionary *uploadUrl = @{
                                        @"image_url": [url isKindOfClass:[NSString class]] ? url : [url absoluteString],
                                        @"caption": [self.arrCaptions[[uploadedURLs indexOfObject:url]] text]
                                        };
            return uploadUrl;
        }];
        
        NSArray *dumpArr = [self.viewModel.selectedCategories map:^id(MBNCategory *category) {
            return category.ID;
        }];
        
        NSDictionary *info = @{
                               @"name": self.productTitleTextField.text,
                               @"category": dumpArr,
                               @"is_sale": @([self.productTransactionTypePickButton.titleLabel.text isEqualToString:@"Cần bán/ Dịch vụ"]),
                               @"province_id": self.selectedProvince.ID,
                               @"conditions": [[self.selectedProductQuality allValues] firstObject],
                               @"is_shown": @(true),
                               @"price": @([self.productPriceTextField.text integerValue]),
                               @"description": @{
                                       @"user": self.productDescriptionTextView.text
                                       },
                               @"gallery": arr
                               };
        
        AFHTTPRequestOperation *createProductRequest;
        if (self.editingProduct) {
            createProductRequest = [[MBNUploadImageManager sharedProvider] updateProductWithProductID:self.editingProduct.ID withDictionary:info withCompletionBlock:^(id reponseObject, NSError *error) {
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([reponseObject[@"status"] integerValue] != 200) {
                    [SVProgressHUD showErrorWithStatus:reponseObject[@"message"]];
                    return;
                }
                
                [SVProgressHUD showSuccessWithStatus: self.editingProduct ? @"Cập nhật sản phẩm thành công" : @"Đăng sản phẩm thành công"];
            }];
        } else {
            createProductRequest = [[MBNUploadImageManager sharedProvider] createProductWithDictionary:info withCompletionBlock:^(id reponseObject, NSError *error) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                if ([reponseObject[@"status"] integerValue] != 200) {
                    [SVProgressHUD showErrorWithStatus:reponseObject[@"message"]];
                    return;
                }
                
                [SVProgressHUD showSuccessWithStatus: self.editingProduct ? @"Cập nhật sản phẩm thành công" : @"Đăng sản phẩm thành công"];
            }];
        }
        
        createProductRequest.responseSerializer = [AFHTTPRequestOperationManager mbn_manager].responseSerializer;
        
        [createProductRequest start];
    }];
    
    
    [self.productImages enumerateObjectsUsingBlock:^(id image, NSUInteger idx, BOOL *stop) {
        
        dispatch_group_enter(group);
        
        NSOperation *operation;
        
        if ([image isEqual:[NSNull null]]) {
            return;
        }
        
        if ([image isKindOfClass:[MBNImage class]]) {
            operation = [NSBlockOperation blockOperationWithBlock:^{
                MBNImage *mbnProduct = (id)image;
                [uploadedURLs replaceObjectAtIndex:idx withObject:mbnProduct.imageURL];
                dispatch_group_leave(group);
            }];
        } else {
            AFHTTPRequestOperation *uploadOperation = (AFHTTPRequestOperation *) [[MBNUploadImageManager sharedProvider] uploadProductImage:image withCompletionBlock:^(AFHTTPRequestOperation *operation, id reponseObject, NSError *error) {
                
                
                [uploadedURLs replaceObjectAtIndex:[arrOperations indexOfObject:operation] withObject:reponseObject[@"result"][@"image_url"]];
                dispatch_group_leave(group);
            }];
            
            operation = uploadOperation;
        }
        
        [operation start];
        
        
        [arrOperations addObject:operation];
    }];
    
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
        [operation3 start];
    });
    
}

- (IBAction)onBtnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma marks - Keyboard

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentInset = contentInsets;
        self.scrollView.scrollIndicatorInsets = contentInsets;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (IBAction)tapOutsideToDismissKeyboard:(id)sender {
    self.activeField = nil;
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.activeField = (UITextField *)textView;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.activeField = nil;
}

@end
