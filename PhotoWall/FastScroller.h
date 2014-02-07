//
//  FastScroller.h
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FastScroller : UIControl
@property (nonatomic) UIScrollView *scrollPeer;
@property (nonatomic, assign) CGFloat scrollOffsetRatio;

- (void)adjustScrollView;

@end
