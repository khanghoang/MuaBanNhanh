//
//  MBNCreateProductViewController.m
//  MuaBanNhanh
//
//  Created by iSlan on 4/28/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNCreateProductViewController.h"

@interface MBNCreateProductViewController ()

@property (weak, nonatomic) IBOutlet UITextField *productTitleTextField;
@property (weak, nonatomic) IBOutlet UILabel *productTitleValidationLabel;
@property (weak, nonatomic) IBOutlet TKDesignableButton *repickCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *sellingTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *buyingTypeButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *productQualityButton;
@property (weak, nonatomic) IBOutlet TKDesignableButton *cityPickButton;
@property (weak, nonatomic) IBOutlet UITextField *productPriceTextField;
@property (weak, nonatomic) IBOutlet UITextView *productDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *productImagePickButtons;
@property (strong, nonatomic) IBOutletCollection(UITextView) NSArray *productImageDescriptionTextViews;

@end

@implementation MBNCreateProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTextFieldBorderLine];
}

- (void)addBorderLineToView:(UIView *)view
{
    view.layer.borderWidth = 1.0f;
    view.layer.borderColor = [UIColor colorWithHexString:@"#CCCCCC"].CGColor;
}

- (void)setupCommandForButtons {
    self.repickCategoryButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //Will push VC here
        return [RACSignal empty];
    }];
    self.productQualityButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //Will open picker VC
        return [RACSignal empty];
    }];
    self.cityPickButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        //Will open picker VC
        return [RACSignal empty];
    }];
    
    self.sellingTypeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    self.buyingTypeButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal empty];
    }];
    
    [self.productImagePickButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
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

@end
