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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setViewControllers:@[[MBNMangeProductListViewController tme_instantiateFromStoryboardNamed:@"ManageProduct"]]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES completion:nil];
    });
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    MBNMangeProductListViewController *listProduct = [MBNMangeProductListViewController tme_instantiateFromStoryboardNamed:@"ManageProduct"];
    return listProduct;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    MBNMangeProductListViewController *listProduct = [MBNMangeProductListViewController tme_instantiateFromStoryboardNamed:@"ManageProduct"];
    return listProduct;
}

@end
