//
//  TMECameraVC.m
//  ThreeMin
//
//  Created by Khoa Pham on 11/19/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMECameraVC.h"

#import "IMGLYCameraController.h"
#import "IMGLYDefines.h"
#import "IMGLYShutterView.h"

#import "UIImage+IMGLYKitAdditions.h"

#import "UIBarButtonItem+Custom.h"
#import "TMECameraFilterSelectorVC.h"


@interface TMECameraVC () <UIGestureRecognizerDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
TMECameraFilterSelectorVCDelegate>

@property (nonatomic, strong) IMGLYCameraController *cameraController;
@property (nonatomic, strong) IMGLYShutterView *shutterView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@property (weak, nonatomic) IBOutlet UIView *filterContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *filterContainerViewBottomConstraint;

@property (nonatomic, strong) TMECameraFilterSelectorVC *filterSelectorVC;

@end

#pragma mark -

@implementation TMECameraVC

#pragma mark - Life Cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];

    [self setupNavigationItems];

    [self configureCameraController];
    [self configureGestureRecognizers];

    [self setupFilterSelectorVC];

    [self configureShutterView];
}

- (void)viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    [self.cameraController startCameraCapture];
    [[self shutterView] openShutter];
}

#pragma mark - Setup
- (void)setupNavigationItems
{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem cancelItemWithTarget:self action:@selector(cancelTouched:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage originalImageNamed:@"icn_rotate_camera"] style:UIBarButtonItemStylePlain target:self action:@selector(switchFrontBackCameraTouched:)];
}

- (void)setupFilterSelectorVC
{
    self.filterContainerViewBottomConstraint.constant = -200;
    
    self.filterSelectorVC = [TMECameraFilterSelectorVC tme_instantiateFromStoryboardNamed:@"CameraFilterSelector"];
    self.filterSelectorVC.delegate = self;
    [self addChildVC:self.filterSelectorVC containerView:self.filterContainerView];
}

- (void)configureCameraController {
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    self.cameraController = [[IMGLYCameraController alloc] initWithRect:screenBounds];
    [self.view insertSubview:self.cameraController.view atIndex:0];
}

// Add a single tap gesture to focus on the point tapped, then lock focus
- (void)configureGestureRecognizers {
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(tapToAutoFocus:)];
    singleTapGestureRecognizer.delegate = self;
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.cameraController addGestureRecogizerToStreamPreview:singleTapGestureRecognizer];

    // Add a double tap gesture to reset the focus mode to continuous auto focus
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                          initWithTarget:self
                                                          action:@selector(tapToContinuouslyAutoFocus:)];
    doubleTapGestureRecognizer.delegate = self;
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    [self.cameraController addGestureRecogizerToStreamPreview:doubleTapGestureRecognizer];
}

- (void)configureShutterView {
    _shutterView = [[IMGLYShutterView alloc] initWithFrame:self.view.bounds];

    [self.view addSubview:_shutterView];
}

#pragma mark - Action
- (void)cancelTouched:(id)sender
{
    [self shutdownCamera];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)switchFrontBackCameraTouched:(id)sender
{
    [self.cameraController removeCameraObservers];
    [self.cameraController removeNotifications];

    [self.filterSelectorVC reset];

    [UIView animateWithDuration:0.2 animations:^{
        [self.cameraController setPreviewAlpha:0.0];
    } completion:^(BOOL finished) {
        [self.cameraController flipCamera];
        [self.cameraController hideIndicator];

        [UIView animateWithDuration:0.2 animations:^{
            [self.cameraController setPreviewAlpha:1.0];
        }];
    }];
}

- (IBAction)takePhotoTouched:(id)sender {
    [self takePhoto];
}

- (IBAction)albumTouched:(id)sender {
    [self openImageFromCameraAndProcessIt];
}

- (IBAction)filterTouched:(id)sender {
    [self showFilterView];
}

- (IBAction)filterViewDownTouched:(id)sender {
    [self hideFilterView];
}

#pragma mark - Filter View
- (void)showFilterView
{
    [self toggleFilterViewVisibility:YES];
}

- (void)hideFilterView
{
    [self toggleFilterViewVisibility:NO];
}

- (void)toggleFilterViewVisibility:(BOOL)visible
{
    [UIView animateWithDuration:0.25 animations:^{
        self.filterContainerViewBottomConstraint.constant = visible ? 0 : -200;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {

    }];
}

#pragma mark - TMEFilterSelectorVCDelegate
- (void)filterSelectorVCDidSelectFilterType:(IMGLYFilterType)filterType
{
    [self.cameraController selectFilterType:filterType];
}

#pragma mark - notification handling
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {

}


#pragma mark - focus handling
- (void)tapToAutoFocus:(UIGestureRecognizer *)gestureRecognizer {
    [self.cameraController onSingleTapFromGestureRecognizer:gestureRecognizer
                                    forInterfaceOrientation:self.interfaceOrientation];
}

- (void)tapToContinuouslyAutoFocus:(UIGestureRecognizer *)gestureRecognizer {
    [self.cameraController onDoubleTapFromGestureRecognizer:gestureRecognizer
                                    forInterfaceOrientation:self.interfaceOrientation];
}

#pragma mark - button tap handling
- (UIImage *)cropImage:(UIImage *)image  width:(CGFloat)width height:(CGFloat)height {
    CGRect bounds = CGRectMake(0,
                               0,
                               width,
                               height);

    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}


- (void)takePhoto {
    [self preparePhotoTaking];
    [self.cameraController pauseCameraCapture];

    __weak TMECameraVC *weakSelf = self;
    [self.cameraController takePhotoWithCompletionHandler:^(UIImage *processedImage, NSError *error) {
        TMECameraVC *strongSelf = weakSelf;
        if (error) {
            DLog(@"%@", error.description);
        }
        else {
            [strongSelf finishPhotoTakingWithImage:processedImage];
        }
    }];
}

- (void)preparePhotoTaking {
    [self.shutterView closeShutter];

    NSInteger timeUntilOpen = 500;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeUntilOpen * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [self.shutterView openShutter];
    });
}

- (void)finishPhotoTakingWithImage:(UIImage *)image {
    [self shutdownCamera];

    [SVProgressHUD dismiss];

    [self completeWithResult:TMECameraVCResultDone
                       image:image
                  filterType:self.cameraController.filterType];
}


- (void)completeWithResult:(TMECameraVCResult)result
                     image:(UIImage *)image
                filterType:(IMGLYFilterType)filterType {

    if (self.completionHandler)
        self.completionHandler(result, image, filterType);
}

#pragma mark - image picker handling
- (void)openImageFromCameraAndProcessIt {
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.delegate = self;
    [self.cameraController stopCameraCapture];
    [self presentViewController:pickerLibrary animated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self.cameraController startCameraCapture];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo {

    [self dismissViewControllerAnimated:NO completion:NULL];
    [self finishPhotoTakingWithImage:image];
}

#pragma mark - layout
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.shutterView.frame = self.view.bounds;
}


#pragma mark - accept / camera mode switching

-(void)shutdownCamera {
    [self.cameraController stopCameraCapture];
    [self.cameraController hideStreamPreview];
    [self.cameraController removeCameraObservers];
    [self.cameraController removeNotifications];
}

-(void)restartCamera {
    [self.cameraController resumeCameraCapture];
    [self.cameraController showStreamPreview];
    [self.cameraController addCameraObservers];
    [self.cameraController addNotifications];
    [self.filterSelectorVC reset];

    sleep(1); // avoid waitin fence error on ios 5
    [self.cameraController startCameraCapture];

    // we need to delay this due synconisation issues with OpenGL

    __weak TMECameraVC *weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC), dispatch_get_main_queue(), ^{
        [weakSelf.cameraController selectFilterType:IMGLYFilterTypeNone];
    });
}



@end
