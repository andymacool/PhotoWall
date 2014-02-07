//
//  ClusterCollectionCellHeaderView.m
//  PhotoWall
//
//  Created by Andy Wang on 1/27/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ClusterCollectionCellHeaderView.h"

@interface ClusterCollectionCellHeaderView ()

@end

@implementation ClusterCollectionCellHeaderView

+ (CGFloat)preferredHeight
{
    return 30.0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:16];

        self.countLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.countLabel.font = [UIFont fontWithName:@"Helvetica" size:12];
        self.countLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.countLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat x, y, w, h;
    
    // bounds is about 320 x 30
    x = 10;
    y = 0;
    w = 190;
    h = [ClusterCollectionCellHeaderView preferredHeight];
    
    self.titleLabel.frame = CGRectMake(x, y, w, h);
    
    w = 100;
    x = 320 - 100 - 25;
    
    self.countLabel.frame = CGRectMake(x, y, w, h);
}

@end
