//
//  MBNSafeBuyViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/18/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSafeBuyViewController.h"

@interface MBNSafeBuyViewController ()
<
UIGestureRecognizerDelegate
>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPaddingLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintPaddingRight;
@property (weak, nonatomic) IBOutlet UIView *contentWrapper;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) CGPoint currentOffset;

@end

@implementation MBNSafeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentOffset = self.scrollView.contentOffset;
    
    CGFloat padding = ([UIScreen mainScreen].bounds.size.width - 240) / 2;
    
    self.constraintPaddingLeft.constant = padding;
    self.constraintPaddingRight.constant = padding;
    
    [self.contentWrapper updateConstraintsIfNeeded];
    [self.contentWrapper layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)panGesture {
    
    CGPoint touchLocation = [panGesture translationInView:self.scrollView];
    NSLog(@"touch = %@, current = %@", NSStringFromCGPoint(touchLocation), NSStringFromCGPoint(self.currentOffset));
    NSLog(@"velocity = %@", NSStringFromCGPoint([panGesture velocityInView:self.view]));
    [self.scrollView setContentOffset:CGPointMake(self.currentOffset.x - touchLocation.x, 0) animated:NO];
    
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint velocity = [panGesture translationInView:self.view];
        CGFloat finalX = velocity.x > 0 ? self.currentOffset.x - 270 : self.currentOffset.x + 270;
        finalX = MAX(0, MIN(finalX, self.scrollView.contentSize.width - [UIScreen mainScreen].bounds.size.width));
        CGPoint finalPoint = CGPointMake(finalX, 0);
        
        self.currentOffset = finalPoint;
        [self.scrollView setContentOffset:finalPoint animated:YES];
    }
}

- (IBAction)onBtnClose:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
