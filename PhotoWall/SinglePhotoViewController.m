//
//  SinglePhotoViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "SinglePhotoViewController.h"

@interface SinglePhotoViewController ()
@property (nonatomic) UIImageView *imageView;
@property (nonatomic) UIPanGestureRecognizer *panGesture;
@property (nonatomic) UITapGestureRecognizer *tapGesture;
@end

@implementation SinglePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.view.clipsToBounds = YES;
        [self.view addSubview:_imageView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewController)];
    _tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:_tapGesture];

}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
