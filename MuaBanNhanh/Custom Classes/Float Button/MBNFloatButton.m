//
//  MBNFloatButton.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 5/2/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNFloatButton.h"

@interface MBNFloatButton()

@property (weak, nonatomic) IBOutlet UIButton *btnFloat;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end

@implementation MBNFloatButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubView];
    }
    
    return self;;
}

- (void)initSubView {
    UIView *view = [[[NSBundle mainBundle]
             loadNibNamed:NSStringFromClass([self class])
             owner:self
             options:nil] objectAtIndex:0];
    [self addSubview:view];
    
    [self.btnFloat mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height).multipliedBy(5.0/8.0);
        make.width.equalTo(self.mas_width).multipliedBy(5.0/8.0);
        make.centerY.equalTo(self.mas_centerY).with.offset(-3);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.backgroundImage mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.mas_height).multipliedBy(1.0/1.0);
        make.width.equalTo(self.mas_width).multipliedBy(1.0/1.0);
        make.centerY.equalTo(self.mas_centerY).with.offset(2);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openPopup:)];
    [self.btnFloat addGestureRecognizer:gesture];
    
    UIImage *plusImage = [self.btnFloat.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.btnFloat setImage:plusImage forState:UIControlStateNormal];
    [self.btnFloat.imageView setTintColor:[UIColor whiteColor]];
    
    [self updateConstraintsIfNeeded];
    [self layoutIfNeeded];
}

- (IBAction)openPopup:(id)sender {
//    TODO: Testing create product VC
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate displayPopupWindow];
}


@end
