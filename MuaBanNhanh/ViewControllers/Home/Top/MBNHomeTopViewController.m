//
//  MBNHomeTopViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNHomeTopViewController.h"
#import "MBNHomeTopCollectionViewCell.h"

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
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
        make.height.equalTo(@(width * (int)((self.arrayCategories.count+1)/2) + COLLECTION_PADDING_BOTTOM));
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
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
    
    CGSize size = CGSizeMake(width, width);
    
    return size;
    
}

@end
