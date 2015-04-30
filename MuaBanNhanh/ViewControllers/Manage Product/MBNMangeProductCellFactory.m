//
//  MBNMangeProductCellFactory.m
//  MuaBanNhanh
//
//  Created by Khang Hoang Trieu on 4/30/15.
//  Copyright (c) 2015 Khang Hoang Trieu. All rights reserved.
//

#import "MBNMangeProductCellFactory.h"
#import <KHTableViewController/KHContentLoadingSectionViewModel.h>
#import <KHTableViewController/KHCollectionContentLoadingCellFactory.h>
#import <KHTableViewController/KHNormalDataProvider.h>
#import "MBNManageProductCollectionViewCell.h"

@implementation MBNMangeProductCellFactory

- (UICollectionViewCell <KHCellProtocol> *)collectionView:(UICollectionView *)collection cellAtIndexPath:(NSIndexPath *)indexPath withModel:(id <KHTableViewModel> )model {
    if ([[model sectionAtIndex:indexPath.section] isKindOfClass:[KHContentLoadingSectionViewModel class]]) {
        return [[[KHCollectionContentLoadingCellFactory alloc] init] collectionView:collection cellAtIndexPath:indexPath withModel:model];
    }
    
    KHNormalDataProvider *dataProvider = (KHNormalDataProvider *)[model sectionAtIndex:indexPath.section];
    MBNManageProductCollectionViewCell <KHCellProtocol> *cell = [collection dequeueReusableCellWithReuseIdentifier:NSStringFromClass([MBNManageProductCollectionViewCell class]) forIndexPath:indexPath];
    [cell configWithData:[dataProvider objectAtIndex:indexPath.item]];
    @weakify(self);
    cell.menuButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIButton *sender) {
        @strongify(self);
        if (self.tapMenuButtonActionBlock) {
            self.tapMenuButtonActionBlock(indexPath, sender);
        }
        return [RACSignal empty];
    }];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView sizeForItemAtIndexPath:(NSIndexPath *)indexPath model:(id <KHTableViewModel> )model {
    if ([[model sectionAtIndex:indexPath.section] isKindOfClass:[KHContentLoadingSectionViewModel class]]) {
        return collectionView.size;
    }
    
    return CGSizeMake(collectionView.width, 90);
}

@end
