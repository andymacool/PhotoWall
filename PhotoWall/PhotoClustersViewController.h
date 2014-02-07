//
//  PhotoClustersViewController.h
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FastScroller;

@interface PhotoClustersViewController : UIViewController

@property (nonatomic) BOOL isViewZoomed; // for the collection view

@property (nonatomic) FastScroller *scroller;

@end
