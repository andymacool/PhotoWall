//
//  ClusterCollectionCellHeaderView.h
//  PhotoWall
//
//  Created by Andy Wang on 1/27/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterCollectionCellHeaderView : UIView

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UILabel *countLabel;

+ (CGFloat)preferredHeight;

@end
