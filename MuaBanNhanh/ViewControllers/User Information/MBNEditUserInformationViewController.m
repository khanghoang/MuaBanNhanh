//
//  MBNEditUserInformationViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNEditUserInformationViewController.h"
#import "TKDesignableView.h"

@interface MBNEditUserInformationViewController ()
<
UITextViewDelegate
>

@property (strong, nonatomic) MBNUser *user;
@property (strong, nonatomic) MBNUser *editingUser;

@property (assign, nonatomic) BOOL isEditing;

@property (weak, nonatomic) IBOutlet TKDesignableButton *btnAvatar;
@property (weak, nonatomic) IBOutlet TKDesignableButton *btnCover;

@property (strong, nonatomic) UIImage *avatarImage;
@property (strong, nonatomic) UIImage *coverImage;

// 1st section
@property (weak, nonatomic) IBOutlet UITextField *lblPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *lblName;
@property (weak, nonatomic) IBOutlet UITextField *lblPassword;

// 2nd section
@property (weak, nonatomic) IBOutlet UITextField *lblIdentity;
@property (weak, nonatomic) IBOutlet UITextField *lblBirthday;
@property (weak, nonatomic) IBOutlet UITextField *lblPersonalEmail;

// 3rd section
@property (weak, nonatomic) IBOutlet UITextField *lblTradeName;
@property (weak, nonatomic) IBOutlet UITextView *txtAddress;
@property (weak, nonatomic) IBOutlet UITextField *lblCity;
@property (weak, nonatomic) IBOutlet UITextField *lblProvinde;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessModel;
@property (weak, nonatomic) IBOutlet UITextField *lblLicense;
@property (weak, nonatomic) IBOutlet UITextField *lblBusinessEmail;
@property (weak, nonatomic) IBOutlet UITextField *lblCreateAt;

@property (nonatomic, strong) TMECameraVC *cameraVC;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttons;

@property (nonatomic, strong) NSMutableArray *images;

@property (weak, nonatomic) IBOutlet TKDesignableView *wrapperCancelButton;
@property (strong, nonatomic) FBKVOController *kvoController;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAddressHeight;

@end

@implementation MBNEditUserInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    
    self.kvoController = [FBKVOController controllerWithObserver:self];
    
    [self.kvoController observe:self keyPath:@"isEditing" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self);
        
        [@[self.lblPhoneNumber,
          self.lblName,
          self.lblPassword,
          self.lblIdentity,
          self.lblBirthday,
          self.lblPersonalEmail,
          self.lblTradeName,
          self.lblCity,
          self.lblProvinde,
          self.lblBusinessEmail,
          self.lblBusinessModel,
          self.lblLicense] enumerateObjectsUsingBlock:^(UITextField *text, NSUInteger idx, BOOL *stop) {
              text.enabled = self.editing;
          }];
        
        self.txtAddress.editable = self.editing;
        self.wrapperCancelButton.hidden = !self.isEditing;
    }];
    
    [self observerTheImages];
    
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
    if(!self.editing) {
        self.isEditing = !self.isEditing;
    }
}

- (IBAction)onBtnCancel:(id)sender {
    self.editing = NO;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)updateContentWithUser:(MBNUser *)user {
    
    // 1st section
    self.lblPhoneNumber.text = user.phone;
    self.lblName.text = user.name;
    
    // 2nd section
    self.lblIdentity.text = user.identity;
    self.lblPersonalEmail.text = user.email;
    
    
    // 3rd section
    self.lblTradeName.text = user.name;
    self.txtAddress.text = user.address;
    self.lblBusinessEmail.text = user.email;
    
    NSDateFormatter *dateFormatter = [MBNUser sharedDateFormatter];
    self.lblCreateAt.text = [dateFormatter stringFromDate:user.createAt];
}

- (IBAction)onBtnLogout:(id)sender {
    [[MBNUserManager sharedProvider] logout];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Thông báo"
                                                        message:@"Bạn đã đăng xuất khỏi thiết bị"
                                                       delegate:nil
                                              cancelButtonTitle:@"Đồng ý" otherButtonTitles:nil];
    [alertView show];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma marks - Section 1

- (IBAction)onBtnBirthday:(id)sender {
    RMDateSelectionViewController *dateSelectionVC = [RMDateSelectionViewController dateSelectionController];
    
    dateSelectionVC.datePicker.datePickerMode = UIDatePickerModeDate;
    
    //Set select and (optional) cancel blocks
    [dateSelectionVC setSelectButtonAction:^(RMDateSelectionViewController *controller, NSDate *date) {
        NSLog(@"Successfully selected date: %@", date);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"dd/MM/yyyy";
        self.lblBirthday.text = [dateFormatter stringFromDate:date];
    }];
    
    [dateSelectionVC setCancelButtonAction:^(RMDateSelectionViewController *controller) {
        NSLog(@"Date selection was canceled");
    }];
    
    //Now just present the date selection controller using the standard iOS presentation method
    [self presentViewController:dateSelectionVC animated:YES completion:nil];
}

#pragma marks - Section 2

#pragma marks - Section 3

- (void)textViewDidChange:(UITextView *)textView {
    self.constraintAddressHeight.constant = textView.contentSize.height;
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

@end
