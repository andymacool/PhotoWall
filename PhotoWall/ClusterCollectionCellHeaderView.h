//
//  ClusterCollectionCellHeaderView.h
//  PhotoWall
//
//  Created by Andy Wang on 1/27/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClusterCollectionCellHeaderView : UICollectionReusableView

+ (NSString *)reuseID;

@property (nonatomic, readonly) UILabel *titleLabel;

@end
