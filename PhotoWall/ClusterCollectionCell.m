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
        [self addSubview:_collectionView];
        
        _snapshotImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_snapshotImageView];
        
        _headerView = [[ClusterCollectionCellHeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:_headerView];
        
        _collectionView.backgroundColor = [UIColor whiteColor];
        
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
    
    CGFloat x, y, w, h;
    x = 0;
    y = 0;
    w = self.bounds.size.width;
    h = [ClusterCollectionCellHeaderView preferredHeight];
    _headerView.frame = CGRectMake(x, y, w, h);
    
    y = CGRectGetMaxY(_headerView.frame);
    h = self.bounds.size.height - h;
    
    _collectionView.frame = CGRectMake(x, y, w, h);
    _snapshotImageView.frame = CGRectMake(x, y, w, h);
}

- (void)buildCellUIWithCluster:(NSArray *)cluster
{
    _cluster = cluster;
    
    _cellManager.cluster = cluster;
    
    _collectionView.dataSource = _cellManager;
    _collectionView.delegate = _cellManager;

    _headerView.titleLabel.text = @"My Photos";
    _headerView.countLabel.text = [NSString stringWithFormat:@"%d Photos", [cluster count]];
    
    [_collectionView reloadData];
}

- (void)setCellSize:(CGSize)cellSize
{
    _cellSize = cellSize;
}


@end
