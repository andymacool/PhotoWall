//
//  PhotoClustersViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "PhotoClustersViewController.h"
#import "ClusterCollectionCell.h"
#import "PhotoCollectionCell.h"
#import "PhotoFetcher.h"
#import "FastScroller.h"

static const CGFloat kMinInterLineSpacing = 5.0;
static const CGFloat kMinInterItemSpacing = 5.0;    // ignore

@interface PhotoClustersViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (nonatomic) UICollectionView *collectionView;
@end

@implementation PhotoClustersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Clusters" image:nil selectedImage:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // install the collection view
    //
    UICollectionViewLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

    CGRect f = self.view.bounds;
    f.size.width = 5 * f.size.width;
    f.size.height = 5 * f.size.height;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:f collectionViewLayout:flowLayout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView registerClass:[ClusterCollectionCell class] forCellWithReuseIdentifier:[ClusterCollectionCell reuseID]];
    [self.view addSubview:self.collectionView];
    
    // install the scroller
    //
    CGFloat x, y, w, h;
    w = 40.0;
    h = self.view.bounds.size.height;
    x = self.view.bounds.size.width - w;
    y = 0;
    
    FastScroller *scroller = [[FastScroller alloc] initWithFrame:CGRectMake(x, y, w, h)];
    scroller.scrollPeer = self.collectionView;
    [self.view addSubview:scroller];
    
    // start fetching
    //
    [[PhotoFetcher sharedInstance] fetchLibraryPhotosWithProgress:nil
                                                    andCompletion:^{
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [self.collectionView reloadData];
                                                        });
                                                    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"MEMORY WARNING !!!!!!!\n");
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [PhotoFetcher sharedInstance].clusters.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClusterCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[ClusterCollectionCell reuseID] forIndexPath:indexPath];
    
    NSArray *cluster = [[PhotoFetcher sharedInstance].clusters objectAtIndex:indexPath.item];
    
    // hand off the data to lower level
    [cell buildCellUIWithCluster:cluster];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout
                                   referenceSizeForFooterInSection:(NSInteger)section
{
    CGRect f = self.view.bounds;
    f.size.height = 4 * f.size.height;
    return f.size;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height, width;
    height = [PhotoCollectionCell preferredSizeInCluster];
    width  = self.collectionView.bounds.size.width;
    return CGSizeMake(width, height);
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
