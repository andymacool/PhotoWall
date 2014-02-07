//
//  FakeScroller.m
//  PhotoWall
//
//  Created by Andy Wang on 2/6/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "AppCore.h"
#import "FakeScroller.h"
#import "ZoomScrollingInteractor.h"
#import "ZoomOutPhotoViewController.h"

@interface FakeScroller ()

@end

@implementation FakeScroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    }
    return self;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];
    
    NSLog(@"Started Zooming ... \n");
    
    ZoomOutPhotoViewController *zoomOutVC = [[ZoomOutPhotoViewController alloc] init];
    ZoomScrollingInteractor *interactor = [[ZoomScrollingInteractor alloc] init];
    zoomOutVC.transitioningDelegate = interactor;
    [AppCore sharedInstance].clusterNav.delegate = interactor;
#if 0
    // present modally
    zoomOutVC.modalPresentationStyle = UIModalPresentationCustom;
    [[AppCore sharedInstance].rootVC presentViewController:zoomOutVC animated:YES completion:nil];
#else
    // present as-if a push
    [[AppCore sharedInstance].clusterNav pushViewController:zoomOutVC animated:YES];
#endif
    
    return YES;
}

//- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
//{
//    [super continueTrackingWithTouch:touch withEvent:event];
//
//    return YES;
//}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super endTrackingWithTouch:touch withEvent:event];
}

@end
