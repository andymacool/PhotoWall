//
//  PhotoCollectionCell.h
//  PhotoWall
//
//  Created by Andy Wang on 7/9/13.
//  Copyright (c) 2013 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoCollectionCell : UICollectionViewCell

@property (nonatomic) UIImageView *imageView;

// assume square shape
+ (CGFloat)preferredSizeInGrid;
+ (CGFloat)preferredSizeInCluster;

+ (NSString *)reuseID;

@end
