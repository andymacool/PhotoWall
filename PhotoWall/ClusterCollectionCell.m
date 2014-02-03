//
//  ClusterCollectionCell.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ClusterCollectionCell.h"
#import "PhotoCollectionCell.h"
#import "PhotoFetcher.h"
#import "ClusterCollectionCellHeaderView.h"

static const CGFloat kMinInterLineSpacing = 5.0;
static const CGFloat kMinInterItemSpacing = 1.0;    // ignore

@interface ClusterCollectionCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) CGSize  cellSize; // inner
@property (nonatomic) NSArray *cluster;
@end

@implementation ClusterCollectionCell

+ (NSString *)reuseID
{
    return @"ClusterCollectionCellID";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];

        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        
        [_collectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:[PhotoCollectionCell reuseID]];
        [_collectionView registerClass:[ClusterCollectionCellHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:[ClusterCollectionCellHeaderView reuseID]];
        [self addSubview:_collectionView];
        
        _snapshotImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_snapshotImageView];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.snapshotImageView.image = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
    _snapshotImageView.frame = self.bounds;
}

- (void)buildCellUIWithCluster:(NSArray *)cluster
{
    _cluster = cluster;
    [_collectionView reloadData];
}

- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cluster.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionCell reuseID] forIndexPath:indexPath];
    
    UIImage *image = [_cluster objectAtIndex:indexPath.item];
    
    cell.imageView.image = image;
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGRect f = self.bounds;
//    f.size.width = 4 * 320;
//    return f.size;
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//        
//        ClusterCollectionCellHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                       withReuseIdentifier:[ClusterCollectionCellHeaderView reuseID]
//                                                       forIndexPath:indexPath];
//        
//        NSUInteger rank = [[PhotoFetcher sharedInstance].clusters indexOfObject:self.cluster];
//        headerView.titleLabel.text = [NSString stringWithFormat:@"      %d", rank];
//        reusableview = headerView;
//    }
//    return reusableview;
//}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = [PhotoCollectionCell preferredSizeInCluster];
    return CGSizeMake(size, size);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section
//{
//    CGFloat size = [PhotoCollectionCell preferredSizeInCluster];
//    return CGSizeMake(size, size);
//}

// for the entire section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

// minimum line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinInterLineSpacing;
}

// minimum inter-item spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinInterItemSpacing;
}

@end
