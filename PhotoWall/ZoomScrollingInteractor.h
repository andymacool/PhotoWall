//
//  ZoomScrollingInteractor.h
//  PhotoWall
//
//  Created by Andy Wang on 2/4/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Serve as both Transitioning Delegate and Animator

@interface ZoomScrollingInteractor : NSObject <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL isPresenting; // YES if presenting view controller, NO if dismissing view controller

@end
