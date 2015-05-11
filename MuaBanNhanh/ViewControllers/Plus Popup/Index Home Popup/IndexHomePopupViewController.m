//
//  IndexHomePopupViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/5/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "IndexHomePopupViewController.h"
#import "MBNRegisterHomePopupViewController.h"
#import "UIUnregisterHomePopup.h"
#import "MBNProductDetailsViewController.h"

@interface IndexHomePopupViewController ()

@property (strong, nonatomic) UIViewController<MBNFloatButtonPopup> *popup;
@property (weak, nonatomic) IBOutlet UIView *containView;

@end

@implementation IndexHomePopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIViewController<MBNFloatButtonPopup> *popup;
    AppDelegate *appDelegate = APP_DELEGATE;
    
    if ([[MBNUserManager sharedProvider] getLoginUser]) {
        if([appDelegate.rootNavigationController.topViewController isKindOfClass:[MBNProductDetailsViewController class]]) {
            popup = [(id) [UIStoryboard storyboardWithName:@"PlusPopups" bundle:nil] instantiateViewControllerWithIdentifier:@"MBNRegisterDetailsPopupViewController"];
        } else {
            popup = (id) [MBNRegisterHomePopupViewController tme_instantiateFromStoryboardNamed:@"PlusPopups"];
        }
    } else {
        popup = (id) [UIUnregisterHomePopup tme_instantiateFromStoryboardNamed:@"PlusPopups"];
    }
    
    self.popup = popup;
    [self addChildViewController:self.popup];
    [self.containView addSubview:self.popup.view];
    
    [self.popup.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.containView);
        make.leading.equalTo(self.containView);
        make.bottom.equalTo(self.containView);
        make.height.equalTo(@([self.popup getViewHeight]));
    }];
}



@end
