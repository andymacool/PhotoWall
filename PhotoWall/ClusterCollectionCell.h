//
//  ClusterCollectionCell.h
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterCollectionCell : UICollectionViewCell

@property (nonatomic) UIImageView   *snapshotImageView;
@property (nonatomic) UICollectionView *collectionView;

+ (NSString *)reuseID;

- (void)buildCellUIWithCluster:(NSArray *)cluster;

@end
