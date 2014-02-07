//
//  SinglePhotoViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "SinglePhotoViewController.h"

@interface SinglePhotoViewController ()
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@property (nonatomic) UIView *header;
@property (nonatomic) UIView *footer;
@end

@implementation SinglePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
#if 0
        self.view.layer.borderColor = [UIColor greenColor].CGColor;
        self.view.layer.borderWidth = 2.0;
#endif
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;

    self.imageView.frame = self.view.bounds;

    [self.view addSubview:self.imageView];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    _tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];

    CGFloat x, y, w, h;
    x = 0;
    y = 0;
    w = 320;
    h = 44;
    self.header = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.header.backgroundColor = [UIColor greenColor];
    self.header.alpha = 0.0;
    [self.view addSubview:self.header];

    h = 70;
    y = self.view.bounds.size.height - h;
    
    self.footer = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
    self.footer.backgroundColor = [UIColor greenColor];
    self.footer.alpha = 0.0;
    [self.view addSubview:self.footer];
}

- (void)showHeaderAndFooterAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.header.alpha = 1.0;
                             self.footer.alpha = 1.0;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)hideHeaderAndFooterAnimated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0.1 options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.header.alpha = 0.0;
                             self.footer.alpha = 0.0;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (IBAction)handlePan:(UIPanGestureRecognizer *)recognizer
{
    NSLog(@"Panning\n");
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

- (void)dismissViewController
{
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         self.header.alpha = 0.0;
                         self.footer.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [self dismissViewControllerAnimated:YES completion:nil];
                     }];
}

@end
