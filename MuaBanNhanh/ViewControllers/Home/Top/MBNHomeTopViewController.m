//
//  MBNHomeTopViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/1/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNHomeTopViewController.h"
#import "MBNHomeTopCollectionViewCell.h"

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
    
    [self.collectionViewCategories registerClass:[MBNHomeTopCollectionViewCell class]
     
                forCellWithReuseIdentifier:NSStringFromClass([MBNHomeTopCollectionViewCell class])];
    
    [[MBNCategoryManager sharedProvider] getCategories:^(NSArray *arrCategories) {
        self.arrayCategories = arrCategories;
        [self.collectionViewCategories reloadData];
        
    } failure:^(NSError *error) {
        [self.view.superview mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1600);
            make.width.equalTo(@320);
        }];
        [UIView animateWithDuration:2
                         animations:^{
                             [self.view.superview layoutIfNeeded];
                         }];
        
    }];
}

#pragma mark - UICollectionView delegate 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
//    return self.arrayCategories.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNHomeTopCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNHomeTopCollectionViewCell class]) forIndexPath:indexPath];
//    [cell configWithData:self.arrayCategories[indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width / 2;
    
    CGSize size = CGSizeMake(width, width);
    
    return size;
    
}

@end
