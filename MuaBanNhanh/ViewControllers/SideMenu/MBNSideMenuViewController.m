//
//  MBNSideMenuViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 3/31/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSideMenuViewController.h"
#import "MBNSideMenuCollectionViewCell.h"
#import "MBNSubcategoryViewController.h"
#import "AppDelegate.h"

@interface MBNSideMenuViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;
@property (strong, nonatomic) NSArray *arrayCategories;

@end

@implementation MBNSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userLogin:)
                                                 name:NOTIFICATION_USER_LOGIN
                                               object:nil];
    
    [self.menuCollectionView registerNib:[MBNSideMenuCollectionViewCell nib]
                forCellWithReuseIdentifier:NSStringFromClass([MBNSideMenuCollectionViewCell class])];
    
    [[MBNCategoryManager sharedProvider] getCategories:^(NSArray *arrCategories) {
        self.arrayCategories = arrCategories;
        [self.menuCollectionView reloadData];
    } failure:^(NSError *error) {
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)userLogin:(NSNotification *)notification {
    // get nofitcation
    MBNUser *loginUser = notification.object;
}

#pragma mark - UICollectionView delegate 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNSideMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNSideMenuCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithData:self.arrayCategories[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 50);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    PKRevealController *revealController = appDelegate.revealController;
    [revealController showViewController:revealController.frontViewController];
    
    MBNSubcategoryViewController *viewController = [[UIStoryboard storyboardWithName:@"SubCategoryStoreyboard" bundle:nil] instantiateInitialViewController];
    viewController.view.backgroundColor = [UIColor whiteColor];
    viewController.arrSubcategories = [self.arrayCategories[indexPath.row] subCategories];
    
    [appDelegate.rootNavigationController pushViewController:viewController animated:YES];
}

@end
