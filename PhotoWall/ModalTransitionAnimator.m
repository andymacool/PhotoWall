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
    return 0.3f;
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
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromViewController.view.alpha = 0;
            fromViewController.view.transform = CGAffineTransformMakeScale(0.92, 0.92);
            
            toViewController.view.frame = endFrame;
                        
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        toViewController.view.transform = CGAffineTransformMakeScale(0.95, 0.95);

        endFrame = self.startFrame;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromViewController.view.frame = endFrame;
          
            toViewController.view.alpha = 1;
            toViewController.view.transform = CGAffineTransformIdentity;

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
