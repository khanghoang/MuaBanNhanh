//
//  MBNManageProductPageViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNManageProductPageViewController.h"
#import "MBNMangeProductListViewController.h"

@interface MBNManageProductPageViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource
>

@end

@implementation MBNManageProductPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    NSArray *arrVCs = @[self.viewModel.viewControllers[[self.viewModel.order firstObject]]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setViewControllers:arrVCs
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES completion:nil];
    });
    
    
    @weakify(self);
    [RACObserve(self.viewModel, currentIndex) subscribeNext:^(NSNumber *currentIndex) {
        @strongify(self);
        NSInteger lastIndex = [self.viewModel indexOfViewController:[self.viewControllers firstObject]];
        if (lastIndex == -1) {
            return;
        }
        
        UIPageViewControllerNavigationDirection direction;
        NSArray *arrVCs = @[self.viewModel.viewControllers[self.viewModel.order[[currentIndex integerValue]]]];
        
        if (lastIndex > [currentIndex integerValue]) {
            direction = UIPageViewControllerNavigationDirectionReverse;
        } else {
            direction = UIPageViewControllerNavigationDirectionForward;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setViewControllers:arrVCs
                           direction:direction
                            animated:YES completion:nil];
        });
    }];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(MBNMangeProductListViewController *)viewController {
    
    NSInteger currentIndex = [self.viewModel indexOfViewController:viewController];
    if (currentIndex <= 0) {
        return nil;
    }
    
    UIViewController *vc = self.viewModel.viewControllers[self.viewModel.order[currentIndex-1]];
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    if (completed) {
        NSInteger currentIndex = [self.viewModel indexOfViewController:[pageViewController.viewControllers firstObject]];
        self.viewModel.currentIndex = @(currentIndex);
    }
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSInteger currentIndex = [self.viewModel indexOfViewController:viewController];
    if (currentIndex < [self.viewModel.viewControllers allValues].count-1) {
        
        UIViewController *vc = self.viewModel.viewControllers[self.viewModel.order[currentIndex+1]];
        return vc;
    }
    
    return nil;
}

@end
