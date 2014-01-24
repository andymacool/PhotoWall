//
//  PhotoCollectionCell.m
//  PhotoWall
//
//  Created by Andy Wang on 7/9/13.
//  Copyright (c) 2013 Andy Wang. All rights reserved.
//

#import "PhotoCollectionCell.h"

@implementation PhotoCollectionCell

+ (CGFloat)preferredSizeInGrid
{
    return 40;
}

+ (CGFloat)preferredSizeInCluster
{
    return 150;
}

+ (NSString *)reuseID
{
    return @"PhotoCollectionCellID";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    [self.contentView addSubview:_imageView];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    _imageView.image = nil;
}

@end
