//
//  ClusterCollectionCell.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ClusterCollectionCell.h"
#import "PhotoCollectionCell.h"

static const CGFloat kMinInterLineSpacing = 5.0;
static const CGFloat kMinInterItemSpacing = 1.0;    // ignore

@interface ClusterCollectionCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
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
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _collectionView.frame = self.bounds;
}

- (void)buildCellUIWithCluster:(NSArray *)cluster
{
    _cluster = cluster;
    [_collectionView reloadData];
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

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = [PhotoCollectionCell preferredSizeInCluster];
    return CGSizeMake(size, size);
}

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
