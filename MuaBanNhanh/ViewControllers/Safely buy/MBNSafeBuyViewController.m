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

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) CGPoint currentOffset;

@end

@implementation MBNSafeBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentOffset = self.scrollView.contentOffset;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)panGesture {
    
//    if (panGesture.state == UIGestureRecognizerStateBegan) {
//        self.currentOffset = self.scrollView.contentOffset;
//    }
//    
//    if (panGesture.state == UIGestureRecognizerStateEnded) {
//        
//    }
    CGPoint touchLocation = [panGesture translationInView:self.scrollView];
    NSLog(@"touch = %@, current = %@", NSStringFromCGPoint(touchLocation), NSStringFromCGPoint(self.currentOffset));
    NSLog(@"velocity = %@", NSStringFromCGPoint([panGesture velocityInView:self.view]));
    [self.scrollView setContentOffset:CGPointMake(self.currentOffset.x - touchLocation.x, 0) animated:NO];
    
    if (panGesture.state == UIGestureRecognizerStateEnded)
    {
//        CGPoint velocity = [panGesture velocityInView:self.view];
//        CGFloat magnitude = sqrt((velocity.x * velocity.x));
//        CGFloat slideMultiplier = magnitude / 2000;
//        
//        CGFloat normalX = self.currentOffset.x - touchLocation.x;
//        CGFloat finalX = MAX(0, MIN(normalX - (velocity.x * slideMultiplier), self.scrollView.contentSize.width));
//        CGPoint finalPoint = CGPointMake(finalX, 0);
        
        CGPoint velocity = [panGesture translationInView:self.view];
        CGFloat finalX = velocity.x > 0 ? self.currentOffset.x - 270 : self.currentOffset.x + 270;
        finalX = MAX(0, MIN(finalX, self.scrollView.contentSize.width - 320));
        CGPoint finalPoint = CGPointMake(finalX, 0);
        
        self.currentOffset = finalPoint;
        [self.scrollView setContentOffset:finalPoint animated:YES];
    }
}

@end
