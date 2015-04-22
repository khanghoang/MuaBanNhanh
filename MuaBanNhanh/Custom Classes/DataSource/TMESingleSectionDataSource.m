//
//  TMESingleSectionDataSource.m
//  ThreeMin
//
//  Created by Khoa Pham on 9/2/14.
//  Copyright (c) 2014 3min. All rights reserved.
//

#import "TMESingleSectionDataSource.h"

@implementation TMESingleSectionDataSource

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionName;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = self.items[indexPath.row];

    if (!IS_IOS8_OR_ABOVE)
    {
        cell.contentView.frame = cell.bounds;
        cell.contentView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin |UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    }



    if (self.cellConfigureBlock) {
        self.cellConfigureBlock(cell, item);
    }

    if (self.detailCellConfigureBlock) {
        self.detailCellConfigureBlock(cell, item, indexPath);
    }
    
    return cell;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    id item = self.items[indexPath.row];

    if (self.cellConfigureBlock) {
        self.cellConfigureBlock(cell, item);
    }

    if (self.detailCellConfigureBlock) {
        self.detailCellConfigureBlock(cell, item, indexPath);
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    id item = self.items[indexPath.row];
    if (self.actionBlock) {
        self.actionBlock(item);
    }
}

@end
