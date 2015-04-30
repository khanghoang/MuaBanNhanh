//
//  MBNEditUserInformationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNEditUserInformationViewController.h"
#import "TKDesignableView.h"
#import "MBNManageProductViewController.h"

@interface MBNEditUserInformationViewController ()
<
UITextViewDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource
>

@property (strong, nonatomic) MBNUser *user;
@property (strong, nonatomic) MBNUser *editingUser;

@property (assign, nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet TKDesignableButton *btnAvatar;
@property (weak, nonatomic) IBOutlet TKDesignableButton *btnCover;

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) UIImage *coverImage;

@property (weak, nonatomic) UITextField *activeField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

// 1st section
@property (weak, nonatomic) IBOutlet UITextField *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *lblName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;

// 2nd section
@property (weak, nonatomic) IBOutlet UITextField *lblIdentity;
@property (weak, nonatomic) IBOutlet UITextField *lblBirthday;
@property (weak, nonatomic) IBOutlet UITextField *lblPersonalEmail;
@property (weak, nonatomic) IBOutlet UITextField *lblGender;
@property (weak, nonatomic) IBOutlet UIButton *btnGenderSelect;

// 3rd section
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *lblCity;
@property (weak, nonatomic) IBOutlet UITextField *lblProvinde;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessModel;
@property (weak, nonatomic) IBOutlet UITextField *lblLicense;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessEmail;
@property (weak, nonatomic) IBOutlet UITextField *lblCreateAt;

@property (strong, nonatomic) NSDictionary *genderArrayDatasource;

@property (nonatomic, strong) TMECameraVC *cameraVC;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, strong) NSMutableArray *images;

@property (weak, nonatomic) IBOutlet TKDesignableView *wrapperCancelButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddressHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;

@end

@implementation MBNEditUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self registerForKeyboardNotifications];
    
    [[MBNUserManager sharedProvider] getOwnInformation:^(MBNUser *user) {
        [self updateContentWithUser:user];
        self.user = user;
    } failure:^(NSString *errorString) {
        
    }];
    
    // button avatar
    @weakify(self);
    self.btnAvatar.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [[RACObserve(self, user.avatarImageUrl) ignore:nil] subscribeNext:^(NSURL *url) {
        @strongify(self);
        [self.btnAvatar setImageForState:UIControlStateNormal
                                 withURL:url];
    }];
    
    self.btnCover.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [[RACObserve(self, user.coverImageUrl) ignore:nil] subscribeNext:^(NSURL *url) {
        @strongify(self);
        [self.btnCover setImageForState:UIControlStateNormal
                                 withURL:url];
    }];
    
    [RACObserve(self, isEditing) subscribeNext:^(NSNumber *isEditing) {
        @strongify(self);
        
        [@[self.lblPhoneNumber,
          self.lblName,
          self.lblPassword,
          self.lblIdentity,
          self.lblBirthday,
          self.lblPersonalEmail,
          self.lblCity,
          self.lblProvinde,
          self.lblBusinessEmail,
          self.lblBusinessModel,
          self.lblLicense] enumerateObjectsUsingBlock:^(UITextField *text, NSUInteger idx, BOOL *stop) {
              text.enabled = self.isEditing;
          }];
        
        self.txtAddress.editable = self.isEditing;
        self.wrapperCancelButton.hidden = !self.isEditing;
        
        self.btnEdit.hidden = [isEditing boolValue];
        self.btnSave.hidden = ![isEditing boolValue];
        self.btnGenderSelect.enabled = [isEditing boolValue];
    }];
    
    [self observerTheImages];
    
}

- (NSDictionary *)genderArrayDatasource {
    if (!_genderArrayDatasource) {
        _genderArrayDatasource =
                            @{
                                @"UNDEFINED": @"Chọn giới tính",
                                @"MALE": @"Nam",
                                @"FEMALE": @"Nữ"
                                };
    }
    
    return _genderArrayDatasource;
}

- (void)observerTheImages {
    [[RACObserve(self, coverImage) ignore:nil] subscribeNext:^(UIImage *coverImage) {
        
        [SVProgressHUD showErrorWithStatus:@"Đang upload hình..." maskType:SVProgressHUDMaskTypeGradient];
        [[MBNUploadImageManager sharedProvider] uploadImage:coverImage
                                                       type:MBN_UPLOAD_USER_COVER
                                            withFinishBlock:^(NSDictionary *responseObject, NSError *error) {
                                                
                                                [SVProgressHUD dismiss];
                                                
                                                if ([responseObject[@"status"] integerValue] == 200) {
                                                    [SVProgressHUD showSuccessWithStatus:@"Upload thành công"];
                                                    MBNUser *user = [[[MBNUserManager sharedProvider] loggedUser] copy];
                                                    user.coverImageUrl = [NSURL URLWithString:responseObject[@"result"][@"cover_image_url"]];
                                                    [[MBNUserManager sharedProvider] setLoggedUser:user];
                                                    return;
                                                }
                                                
                                                [SVProgressHUD showErrorWithStatus:@"Có lỗi trong lúc upload hình, vui lòng thử lại" maskType:SVProgressHUDMaskTypeGradient];
                                            }];
    }];
    
    [[RACObserve(self, avatarImage) ignore:nil] subscribeNext:^(UIImage *avatarImage) {
        [SVProgressHUD showErrorWithStatus:@"Đang upload hình..." maskType:SVProgressHUDMaskTypeGradient];
        [[MBNUploadImageManager sharedProvider] uploadImage:avatarImage
                                                       type:MBN_UPLOAD_USER_AVATAR
                                            withFinishBlock:^(NSDictionary *responseObject, NSError *error) {
                                                
                                                [SVProgressHUD dismiss];
                                                
                                                if ([responseObject[@"status"] integerValue] == 200) {
                                                    [SVProgressHUD showSuccessWithStatus:@"Upload thành công"];
                                                    MBNUser *user = [[[MBNUserManager sharedProvider] loggedUser] copy];
                                                    user.avatarImageUrl = [NSURL URLWithString:responseObject[@"result"][@"avatar_image_url"]];
                                                    [[MBNUserManager sharedProvider] setLoggedUser:user];
                                                    return;
                                                }
                                                
                                                [SVProgressHUD showErrorWithStatus:@"Có lỗi trong lúc upload hình, vui lòng thử lại" maskType:SVProgressHUDMaskTypeGradient];
                                            }];
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if(SYSTEM_VERSION_GREATER_THAN(@"8.0")) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
    }
}

- (IBAction)onBtnEditInfor:(id)sender {
    if(!self.isEditing) {
        self.isEditing = !self.isEditing;
    }
}

- (IBAction)onBtnCancel:(id)sender {
    self.isEditing = NO;
    [self updateContentWithUser:self.user];
}

- (BOOL)shouldAutoRotate
{
    return NO;
}

- (void)updateContentWithUser:(MBNUser *)user {
    
    // 1st section
    self.lblPhoneNumber.text = user.phone;
    self.lblName.text = user.name;
    
    // 2nd section
    self.lblIdentity.text = user.identity;
    self.lblBirthday.text = user.birthday;
    self.lblPersonalEmail.text = user.email;
    
    
    // 3rd section
    self.txtAddress.text = user.address;
    self.lblBusinessEmail.text = user.email;
    self.lblGender.text = user.gender;
    
    NSDateFormatter *dateFormatter = [MBNUser sharedDateFormatter];
    self.lblCreateAt.text = [dateFormatter stringFromDate:user.createAt];
}

- (IBAction)onBtnLogout:(id)sender {
    [[MBNUserManager sharedProvider] logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [SVProgressHUD showSuccessWithStatus:@"Bạn đã đăng xuất khỏi thiết bị"];
}

#pragma marks - Section 1

- (IBAction)onBtnBirthday:(id)sender {
    if (!self.isEditing) {
        return;
    }
    
RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //Set select and (optional) cancel blocks
    [dateSelectionVC setSelectButtonAction:^(RMDateSelectionViewController *controller, NSDate *date) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        self.lblBirthday.text = [dateFormatter stringFromDate:date];
    }];
    
    [dateSelectionVC setCancelButtonAction:^(RMDateSelectionViewController *controller) {
    }];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionVC animated:YES completion:nil];
}

#pragma marks - Section 2

#pragma marks - Section 3

- (void)textViewDidChange:(UITextView *)textView {
    self.constraintAddressHeight.constant = [textView measureHeightOfUITextView];
    [textView updateConstraintsIfNeeded];
    [textView layoutIfNeeded];
}

#pragma mark - Action
- (IBAction)photoButtonTouched:(UIButton *)button
{
    self.cameraVC = [TMECameraVC tme_instantiateFromStoryboardNamed:@"Camera"];
    
    __weak typeof (self) weakSelf = self;
    self.cameraVC.completionHandler = ^(TMECameraVCResult result, UIImage *image, IMGLYFilterType filterType) {
        [weakSelf showEditorVCWithImage:image button:button];
    };
    
    [self.navigationController pushViewController:self.cameraVC animated:YES];
}

- (IBAction)onBtnManageProduct:(id)sender {
    MBNManageProductViewController *productsVC = [MBNManageProductViewController tme_instantiateFromStoryboardNamed:@"ManageProduct"];
    [self.navigationController pushViewController:productsVC animated:YES];
}

- (void)showEditorVCWithImage:(UIImage *)image button:(UIButton *)button
{
    TMECropImageVC *cropVC = [[TMECropImageVC alloc] init];
    cropVC.inputImage = image;
    
    __weak typeof(self) weakSelf = self;
    cropVC.completionHandler = ^(IMGLYEditorViewControllerResult result, UIImage *outputImage, IMGLYProcessingJob *job) {
        if (result == IMGLYEditorViewControllerResultCancelled) {
            [weakSelf.cameraVC restartCamera];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf handleTakenImage:outputImage button:button];
            weakSelf.cameraVC = nil;
            [weakSelf.navigationController popToViewController:weakSelf animated:YES];
        }
    };
    
    [self.navigationController pushViewController:cropVC animated:YES];
}

- (IBAction)onBtnSave:(id)sender {
    NSDictionary *infor = @{
        @"name": @"Khang Hoang",
        @"phone": self.lblPhoneNumber.text,
        @"birthday": self.lblBirthday.text,
        @"identity_number": self.lblIdentity.text,
        @"license": self.lblLicense.text,
        @"password": self.lblPassword.text,
        @"address": @{
                @"address": self.txtAddress.text,
                @"longitude": @"",
                @"latide": @""
        },
        @"email": self.lblPersonalEmail.text,
        @"gender": [self.genderArrayDatasource dictionaryBySwappingKeysAndValues][self.lblGender.text],
        @"about": @"",
        @"password": @""
    };
    
    [SVProgressHUD showWithStatus:@"Đang cập nhật" maskType:SVProgressHUDMaskTypeGradient];
    
    [[MBNUserManager sharedProvider] updateOwnInformationiWithDictionary:infor completeBlock:^(MBNUser *user, NSError *error) {
        [SVProgressHUD dismiss];
        MBNUser *oldUser = [[MBNUserManager sharedProvider] loggedUser];
        user.token = oldUser.token;
        [[MBNUserManager sharedProvider] setLoggedUser:user];
    }];
}

- (IBAction)onBtnSelectGender:(id)sender {
    RMPickerViewController *pickerGender = [RMPickerViewController pickerController];
    
    pickerGender.picker.delegate = self;
    pickerGender.picker.dataSource = self;
    
    [self presentViewController:pickerGender animated:YES completion:nil];
    
    [pickerGender setSelectButtonAction:^(RMPickerViewController *picker, NSArray *arr) {
        NSArray *datasource = [[self.genderArrayDatasource allValues] reverse];
        self.lblGender.text = datasource[[[arr firstObject] integerValue]];
    }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.genderArrayDatasource.allKeys.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSArray *datasource = [[self.genderArrayDatasource allValues] reverse];
    self.lblGender.text = datasource[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSArray *datasource = [[self.genderArrayDatasource allValues] reverse];
    return datasource[row];
}

#pragma mark - Helpers
- (void)handleTakenImage:(UIImage *)image button:(UIButton *)button
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, NULL);
    
    NSInteger index = [self.buttons indexOfObject:button];
    self.images[index] = image;
    [button setImage:[image imgly_rotateImageToMatchOrientation] forState:UIControlStateNormal];
    
    if ([button isEqual:self.btnCover]) {
        self.coverImage = image;
    }
    
    if ([button isEqual:self.btnAvatar]) {
        self.avatarImage = image;
    }
    
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

@end
