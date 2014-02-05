//
//  ModalTransitionAnimator.h
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModalTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic) BOOL isPresenting;    // YES if we are presenting a view controller, NO if dismissing.
@property (nonatomic) CGRect startFrame;    // calculate "in-place" starting frame

@end
