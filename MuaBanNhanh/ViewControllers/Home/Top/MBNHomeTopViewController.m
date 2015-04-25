//
//  MBNHomeTopViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNHomeTopViewController.h"
#import "MBNHomeTopCollectionViewCell.h"
#import "AppDelegate.h"
#import "MBNSubcategoryViewController.h"

#define PRODUCT_COLLECTION_CELL_HEIGHT [UIScreen mainScreen].bounds.size.width / 2.0 / (140.0f / 210.f)

static CGFloat const COLLECTION_PADDING_BOTTOM = 20;

@interface MBNHomeTopViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewCategories;
@property (strong, nonatomic) NSArray *arrayCategories;

@end

@implementation MBNHomeTopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[MBNCategoryManager sharedProvider] getCategories:^(NSArray *arrCategories) {
        
        [self updateCollectionView:arrCategories];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Handle logic loading

- (void)updateCollectionView:(NSArray *)arrayCategories {
    self.arrayCategories = arrayCategories;
    [self.collectionViewCategories reloadData];
    [self.view.superview mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat height = (int) (PRODUCT_COLLECTION_CELL_HEIGHT + 10) * (int)((self.arrayCategories.count+1)/2) + (COLLECTION_PADDING_BOTTOM * 2) + 1;
        make.height.equalTo(@(height));
    }];
    [UIView animateWithDuration:0
                     animations:^{
                         [self.view.superview layoutIfNeeded];
                     }];
}

#pragma mark - UICollectionView delegate 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.arrayCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNHomeTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNHomeTopCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithData:self.arrayCategories[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.0;
    CGFloat height = PRODUCT_COLLECTION_CELL_HEIGHT;
    
    CGSize size = CGSizeMake(width, height);
    
    return size;
    
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
