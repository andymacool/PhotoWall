//
//  ModalTransitionAnimator.m
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ModalTransitionAnimator.h"
#import "SinglePhotoViewController.h"

@implementation ModalTransitionAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    // Set our ending frame. We'll modify this later if we have to
    CGRect endFrame = fromViewController.view.bounds;
    
    if (self.isPresenting) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:fromViewController.view];
        [transitionContext.containerView addSubview:toViewController.view];
        
        CGRect startFrame = self.startFrame;
        
        toViewController.view.frame = startFrame;

        if ([toViewController isKindOfClass:[SinglePhotoViewController class]]) {
            SinglePhotoViewController *toVC = (SinglePhotoViewController *)toViewController;
            toVC.imageView.frame = toVC.view.bounds;
        }
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromViewController.view.alpha = 0;
            
            toViewController.view.bounds = endFrame;
            toViewController.view.frame = endFrame;
            
            if ([toViewController isKindOfClass:[SinglePhotoViewController class]]) {
                SinglePhotoViewController *toVC = (SinglePhotoViewController *)toViewController;
                toVC.imageView.frame = toVC.view.bounds;
            }
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        endFrame = self.startFrame;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromViewController.view.frame = endFrame;
            toViewController.view.alpha = 1;
            
            if ([fromViewController isKindOfClass:[SinglePhotoViewController class]]) {
                SinglePhotoViewController *fromVC = (SinglePhotoViewController *)fromViewController;
                fromVC.imageView.frame = fromVC.view.bounds;
            }
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
