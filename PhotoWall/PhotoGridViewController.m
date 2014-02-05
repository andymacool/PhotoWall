//
//  PhotoGridViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 7/8/13.
//  Copyright (c) 2013 Andy Wang. All rights reserved.
//

#import "PhotoGridViewController.h"
#import "PhotoCollectionCell.h"
#import "PhotoFetcher.h"

static const CGFloat kScaleBoundLower = 0.5;
static const CGFloat kScaleBoundUpper = 2.0;
static const CGFloat kMinInterLineSpacing = 5.0;
static const CGFloat kMinInterItemSpacing = 5.0;

@interface PhotoGridViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) PhotoFetcher *photoFetcher;
@property (nonatomic) UICollectionView *collectionView;
@property (nonatomic) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, assign) CGFloat scale;
@property (nonatomic, assign) BOOL fitCells;
@property (nonatomic, assign) BOOL animatedZooming;
@end

@implementation PhotoGridViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Pinch GridView";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[PhotoCollectionCell class] forCellWithReuseIdentifier:[PhotoCollectionCell reuseID]];
    [self.view addSubview:self.collectionView];
    
    // add the pinch to zoom gesture
    self.fitCells = YES;
    self.animatedZooming = YES;
    self.scale = (kScaleBoundUpper + kScaleBoundLower)/2.0;

    self.pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(didReceivePinchGesture:)];
    [self.collectionView addGestureRecognizer:self.pinchGesture];
    
    // put a spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = self.view.center;
    spinner.hidesWhenStopped = YES;
    [self.view addSubview:spinner];
    [spinner startAnimating];

    self.photoFetcher = [PhotoFetcher sharedInstance];
    
    [self.photoFetcher fetchLibraryPhotosWithProgress:^(double progress) {
                                            // update the progress
                                        }
                                        andCompletion:^{
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [spinner stopAnimating];
                                                [self.collectionView reloadData];
                                            });
                                        }];
    
}

#pragma mark - Pinch Handling

- (void)setScale:(CGFloat)scale
{
    // make sure it doesn't go out of bounds
    if (scale < kScaleBoundLower)
    {
        _scale = kScaleBoundLower;
    }
    else if (scale > kScaleBoundUpper)
    {
        _scale = kScaleBoundUpper;
    }
    else
    {
        _scale = scale;
    }
}

- (void)didReceivePinchGesture:(UIPinchGestureRecognizer *)gesture
{
    static CGFloat scaleStart;
    
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        // take an snapshot of the initial scale
        scaleStart = self.scale;
        return;
    }
    if (gesture.state == UIGestureRecognizerStateChanged)
    {
        // apply the scale of the gesture to get the new scale
        self.scale = scaleStart * gesture.scale;
        
        if (self.animatedZooming)
        {
            __weak typeof(self) weakSelf = self;
            // animated zooming (remove and re-add the gesture recognizer to prevent updates during the animation)
            [self.collectionView removeGestureRecognizer:self.pinchGesture];

            UICollectionViewFlowLayout *newLayout = [[UICollectionViewFlowLayout alloc] init];
            [self.collectionView setCollectionViewLayout:newLayout animated:YES completion:^(BOOL finished) {
                [weakSelf.collectionView addGestureRecognizer:weakSelf.pinchGesture];
            }];
        }
        else
        {
            // Invalidate layout
            [self.collectionView.collectionViewLayout invalidateLayout];
        }
    }
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.photoFetcher.thumbnails count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionCell reuseID] forIndexPath:indexPath];
    cell.imageView.image = self.photoFetcher.thumbnails[indexPath.item];
    
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // main use of the scale property
    CGFloat scaledWidth = [PhotoCollectionCell preferredSizeInGrid] * self.scale;
    
    if (self.fitCells)
    {
        NSInteger cols = floor(self.view.bounds.size.width / scaledWidth);
        CGFloat totalSpacingSize = kMinInterItemSpacing * (cols - 1);
        CGFloat fittedWidth = (self.view.bounds.size.width - totalSpacingSize) / cols;
        return CGSizeMake(fittedWidth, fittedWidth);
    }
    else
    {
        return CGSizeMake(scaledWidth, scaledWidth);
    }
}

// for the entire section
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

// minimum line spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinInterLineSpacing;
}

// minimum inter-item spacing
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                           minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return kMinInterItemSpacing;
}

@end
