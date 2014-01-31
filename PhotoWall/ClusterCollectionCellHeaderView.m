//
//  ClusterCollectionCellHeaderView.m
//  PhotoWall
//
//  Created by Andy Wang on 1/27/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ClusterCollectionCellHeaderView.h"

@interface ClusterCollectionCellHeaderView ()
@property (nonatomic, readwrite) UILabel *titleLabel;
@end

@implementation ClusterCollectionCellHeaderView

+ (NSString *)reuseID
{
    return @"ClusterCollectionCellHeaderView";
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:50];
        
        [self addSubview:self.titleLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    CGFloat x, y, w, h;
//    CGFloat padding;
    
    self.titleLabel.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
