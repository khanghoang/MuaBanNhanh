//
//  MBNSideMenuViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 3/31/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNSideMenuViewController.h"
#import "MBNSideMenuCollectionViewCell.h"

@interface MBNSideMenuViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (weak, nonatomic) IBOutlet UICollectionView *menuCollectionView;

@end

@implementation MBNSideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.menuCollectionView registerNib:[MBNSideMenuCollectionViewCell nib]
                forCellWithReuseIdentifier:NSStringFromClass([MBNSideMenuCollectionViewCell class])];
}

#pragma mark - UICollectionView delegate 

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNSideMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNSideMenuCollectionViewCell class]) forIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(320, 50);
    
}


@end
