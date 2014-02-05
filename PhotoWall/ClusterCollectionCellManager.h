//
//  ClusterCollectionCellManager.h
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//  Serve as ClusterCollectionCell's data source and delegate

@interface ClusterCollectionCellManager : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) NSArray *cluster;

@end
