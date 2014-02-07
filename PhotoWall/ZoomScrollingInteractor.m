//
//  ZoomScrollingInteractor.m
//  PhotoWall
//
//  Created by Andy Wang on 2/4/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ZoomScrollingInteractor.h"

@implementation ZoomScrollingInteractor

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (operation == UINavigationControllerOperationPush) {
        self.isPushing = YES;
        return self;
    }
    if (operation == UINavigationControllerOperationPop) {
        self.isPushing = NO;
        return self;
    }
    
    return nil;
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    self.isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresenting = NO;
    return self;
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    if (self.isPresenting || self.isPushing) {
        fromViewController.view.userInteractionEnabled = NO;
        
        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            
            fromViewController.view.alpha = 0;
            fromViewController.view.transform = CGAffineTransformMakeScale(0.7, 0.7);
            
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:YES];
        }];
    }
    else {
        toViewController.view.userInteractionEnabled = YES;

        [transitionContext.containerView addSubview:toViewController.view];
        [transitionContext.containerView addSubview:fromViewController.view];

        toViewController.view.alpha = 1;

        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{

            fromViewController.view.transform = CGAffineTransformMakeScale(3.0, 3.0);
            fromViewController.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            fromViewController.view.transform = CGAffineTransformIdentity;
            [transitionContext completeTransition:YES];
        }];
    }
}


@end
