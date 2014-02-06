//
//  SinglePhotoViewController.h
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePhotoViewController : UIViewController

@property (nonatomic) UIImageView *imageView;

- (void)showHeaderAndFooterAnimated:(BOOL)animated;
- (void)hideHeaderAndFooterAnimated:(BOOL)animated;

@end
