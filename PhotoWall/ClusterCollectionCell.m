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
#import "ClusterCollectionCellManager.h"


@interface ClusterCollectionCell ()
@property (nonatomic) CGSize  cellSize; // inner
@property (nonatomic) NSArray *cluster;
@property (nonatomic) ClusterCollectionCellManager *cellManager;
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

        _cellManager = [[ClusterCollectionCellManager alloc] init];

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
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
    
    _cellManager.cluster = cluster;
    
    _collectionView.dataSource = _cellManager;
    _collectionView.delegate = _cellManager;

    [_collectionView reloadData];
}

- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
}


@end
