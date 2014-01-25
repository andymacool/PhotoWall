//
//  FastScroller.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "FastScroller.h"

@interface FastScroller ()
@property (nonatomic, assign) CGPoint scrollOffset;
@property (nonatomic, assign) CGRect contentBounds;
@end

@implementation FastScroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization code
        self.backgroundColor = [UIColor greenColor];
        self.contentBounds = self.bounds;
    }
    return self;
}

- (CGFloat)transformedHeightForScrollView:(UIScrollView *)scrollView
{
    if( self.scrollPeer )
    {
        CGFloat denom = self.scrollPeer.transform.d;
        if( denom == 0 )
            denom = 1;
        
        return floor(self.scrollPeer.frame.size.height / denom); // "d" is sy, or the y-scale transform, in the matrix
    }
    else
    {
        return 0;
    }
}

- (CGFloat)scrollOffsetRatio
{
    // contentBounds = scroller height = full screen height
    
    return self.scrollOffset.y / self.contentBounds.size.height;
}


- (CGFloat)scrollableHeightForScrollView:(UIScrollView *)scrollView {
    return self.scrollPeer.contentSize.height - 568 * 4 - [self transformedHeightForScrollView:scrollView];
}


- (void)adjustScrollView {
    CGFloat scrollableY = [self scrollableHeightForScrollView:self.scrollPeer];
    CGFloat offsetY = (scrollableY * self.scrollOffsetRatio);
    CGFloat maxOffsetY = MAX(offsetY, 0);
    offsetY = MIN(offsetY, maxOffsetY);
    [self.scrollPeer setContentOffset:CGPointMake(0, offsetY) animated:NO];
}

- (void)trackTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    self.scrollOffset = [touch locationInView:self];
    [self adjustScrollView];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];

    NSLog(@"Started Tracking ... \n");

    // upon tapping on the scroller, zoom out the entire collection view
    //
    self.scrollPeer.center = CGPointMake(0, 0);

    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                            CGAffineTransform t = CGAffineTransformMakeScale(0.2, 0.2);
                            self.scrollPeer.layer.anchorPoint = CGPointMake(0, 0);
                            self.scrollPeer.transform = t;
                        } completion:^(BOOL finished) {
                            
                        }];
    
    [self trackTouch:touch withEvent:event];

    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"Continue Tracking ... \n");

    [super continueTrackingWithTouch:touch withEvent:event];
    [self trackTouch:touch withEvent:event];
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"End Tracking ... \n");

    [super endTrackingWithTouch:touch withEvent:event];
    // restore
    //
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollPeer.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         
                     }];
}

@end
