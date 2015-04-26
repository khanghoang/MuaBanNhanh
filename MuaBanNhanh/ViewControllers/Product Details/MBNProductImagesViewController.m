//
//  MBNProductImagesViewController.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/25/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductImagesViewController.h"
#import "MBNProductImageCell.h"

@interface MBNProductImagesViewController ()
<
UICollectionViewDelegate,
UICollectionViewDataSource
>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation MBNProductImagesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    @weakify(self);
    [[RACObserve(self, viewModel) ignore:nil] subscribeNext:^(id x) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.product.gallery.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBNProductImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNProductImageCell class]) forIndexPath:indexPath];
    [cell configWithData:self.viewModel.product.gallery[indexPath.row]];
    return cell;
}

@end
