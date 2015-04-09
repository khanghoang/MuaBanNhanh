//
//  MBNProductCellFactory.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/9/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNProductCellFactory.h"
#import <KHTableViewController/KHContentLoadingSectionViewModel.h>
#import <KHTableViewController/KHCollectionContentLoadingCellFactory.h>
#import <KHTableViewController/KHNormalDataProvider.h>
#import "MBNProductCollectionViewCell.h"

@implementation MBNProductCellFactory

- (UICollectionViewCell <KHCellProtocol> *)collectionView:(UICollectionView *)collection cellAtIndexPath:(NSIndexPath *)indexPath withModel:(id <KHTableViewModel> )model {
    if ([[model sectionAtIndex:indexPath.section] isKindOfClass:[KHContentLoadingSectionViewModel class]]) {
        return [[[KHCollectionContentLoadingCellFactory alloc] init] collectionView:collection cellAtIndexPath:indexPath withModel:model];
    }
    
    KHNormalDataProvider *dataProvider = (KHNormalDataProvider *)[model sectionAtIndex:indexPath.section];
    UICollectionViewCell <KHCellProtocol> *cell = [self _getReusableCellWithClass:[MBNProductCollectionViewCell class] collectionView:collection atIndexPath:indexPath];
    [cell configWithData:[dataProvider objectAtIndex:indexPath.item]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath model:(id <KHTableViewModel> )model {
    if ([[model sectionAtIndex:indexPath.section] isKindOfClass:[KHContentLoadingSectionViewModel class]]) {
        return collectionView.size;
    }
    
    return CGSizeMake(collectionView.width, 157);
}

@end
