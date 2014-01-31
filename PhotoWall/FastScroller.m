//
//  FastScroller.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "FastScroller.h"
#import "FastScrollerThumb.h"

//#define DO_CGTransform
#define DO_ChangeLayout

@interface FastScroller ()
@property (nonatomic, assign) CGPoint scrollOffset;
@property (nonatomic, assign) CGRect contentBounds;
@property (nonatomic) FastScrollerThumb *scrollThumb;

@end

@implementation FastScroller

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // initialization code
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
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
#ifdef  DO_ChangeLayout
    return self.scrollPeer.contentSize.height - [self transformedHeightForScrollView:scrollView];
#endif
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
    [self adjustScrollThumb];
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    [super beginTrackingWithTouch:touch withEvent:event];

    NSLog(@"Started Tracking ... \n");
    
#if 0
    // TESTING Layer and Anchor Point
    NSLog(@"%@ \n %f, %f\n", self.scrollPeer, self.scrollPeer.layer.position.x, self.scrollPeer.layer.position.y);
    self.scrollPeer.layer.anchorPoint = CGPointMake(0, 0);
    NSLog(@"%@ \n %f, %f\n", self.scrollPeer, self.scrollPeer.layer.position.x, self.scrollPeer.layer.position.y);
    
    CGRect f = self.scrollPeer.layer.frame;
    f.origin.x -= 1;
    self.scrollPeer.layer.frame = f;
    NSLog(@"%@ \n %f, %f\n", self.scrollPeer, self.scrollPeer.layer.position.x, self.scrollPeer.layer.position.y);
#endif
    
#ifdef  DO_CGTransform
    // NOTE: the order is very important
    // change the anchor point will change the frame as well
    self.scrollPeer.center = CGPointMake(0, 0);
    self.scrollPeer.layer.anchorPoint = CGPointMake(0, 0);
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                            CGAffineTransform t = CGAffineTransformMakeScale(0.2, 0.2);
                            self.scrollPeer.transform = t;
                        } completion:^(BOOL finished) {
                            
                        }];
    
    [self installScrollThumb];
    [self trackTouch:touch withEvent:event];
#endif

#ifdef  DO_ChangeLayout

    if ([self.scrollPeer isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollPeer;
        collectionView.tag = 99;
        
//        [collectionView.collectionViewLayout invalidateLayout];
        
        UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
        
        __weak UICollectionView *weakCollectionView = collectionView;

        [collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
            [weakCollectionView reloadData];
        }];
    }
    
    [self installScrollThumb];
    [self trackTouch:touch withEvent:event];

#endif
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    //NSLog(@"Continue Tracking ... \n");

    [super continueTrackingWithTouch:touch withEvent:event];
    [self trackTouch:touch withEvent:event];
    
    return [super continueTrackingWithTouch:touch withEvent:event];
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    NSLog(@"End Tracking ... \n");
    [super endTrackingWithTouch:touch withEvent:event];
    [self stopTracking];
    
#ifdef  DO_ChangeLayout
    
    if ([self.scrollPeer isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self.scrollPeer;
        collectionView.tag = 0;
        UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
        
        __weak UICollectionView *weakCollectionView = collectionView;
        
        [collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
           
            // because in the zoom-out mode, more cells are loaded
            // then when we quit zoom mode, we need a force reload
            // the cells that will be on screen.
            [weakCollectionView reloadData];
        }];
    }

#endif
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"Layout Subviews ...\n");

    [self adjustScrollThumb];
}

- (void)stopTracking
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.scrollPeer.transform = CGAffineTransformIdentity;
                     } completion:^(BOOL finished) {
                         [self setNeedsLayout];
                     }];
}

#pragma mark - Scroll Thumb Shadow

- (void)installScrollThumb {
    if (!_scrollThumb) {
        CGFloat x, y, w, h;
        x = 0;
        y = 0;
        w = 320;
        h = [FastScrollerThumb preferredHeight];
        FastScrollerThumb *thumb = [[FastScrollerThumb alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.scrollThumb = thumb;
        self.scrollThumb.layer.zPosition = 99;
        [self addSubview:thumb];
    }
}

- (void)adjustScrollThumb
{
    if (self.tracking == NO) {
        [_scrollThumb removeFromSuperview];
        _scrollThumb = nil;
    } else {
        [self installScrollThumb];
        CGRect thumbRect = self.scrollThumb.frame;
        thumbRect.origin.x = (0 - thumbRect.size.width);
        CGFloat centeredY = floor(self.scrollOffset.y - (thumbRect.size.height / 2));
        thumbRect.origin.y = MIN(MAX(centeredY, 0), (self.bounds.size.height - thumbRect.size.height));
        self.scrollThumb.frame = thumbRect;
    }
}


@end
