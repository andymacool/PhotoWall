//
//  ClusterCollectionCellManager.m
//  PhotoWall
//
//  Created by Andy Wang on 2/3/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ClusterCollectionCellManager.h"
#import "SinglePhotoViewController.h"
#import "ModalTransitionAnimator.h"
#import "PhotoCollectionCell.h"
#import "AppDelegate.h"
#import "AppCore.h"

static const CGFloat kMinInterLineSpacing = 5.0;
static const CGFloat kMinInterItemSpacing = 1.0;    // ignore

@interface ClusterCollectionCellManager () <UIViewControllerTransitioningDelegate>
@property (nonatomic) CGRect selectedCellFrame;     // with respect to the view
@end

@implementation ClusterCollectionCellManager

- (id)initWithCluster:(NSArray *)cluster
{
    self = [super init];
    if (self) {
        _cluster = cluster;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _cluster.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[PhotoCollectionCell reuseID] forIndexPath:indexPath];
    
    UIImage *image = [_cluster objectAtIndex:indexPath.item];
    
    cell.imageView.image = image;
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForFooterInSection:(NSInteger)section
//{
//    CGRect f = self.bounds;
//    f.size.width = 4 * 320;
//    return f.size;
//}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
//           viewForSupplementaryElementOfKind:(NSString *)kind
//                                 atIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionReusableView *reusableview = nil;
//
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
//
//        ClusterCollectionCellHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind
//                                                       withReuseIdentifier:[ClusterCollectionCellHeaderView reuseID]
//                                                       forIndexPath:indexPath];
//
//        NSUInteger rank = [[PhotoFetcher sharedInstance].clusters indexOfObject:self.cluster];
//        headerView.titleLabel.text = [NSString stringWithFormat:@"      %d", rank];
//        reusableview = headerView;
//    }
//    return reusableview;
//}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage *image = [_cluster objectAtIndex:indexPath.item];

    // calcuate the selected cell's from with respect to the view
    PhotoCollectionCell *selectedCell = (PhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedCellFrame = [[selectedCell superview] convertRect:selectedCell.frame toView:[AppCore sharedInstance].rootVC.view];
    
    SinglePhotoViewController *spvc = [[SinglePhotoViewController alloc] init];
    // spvc.image = image;
    spvc.image = image;
    spvc.transitioningDelegate = self;
    spvc.modalPresentationStyle = UIModalPresentationCustom;
    
    [[AppCore sharedInstance].rootVC presentViewController:spvc animated:YES completion:nil];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = [PhotoCollectionCell preferredSizeInCluster];
    return CGSizeMake(size, size);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout *)collectionViewLayout
//referenceSizeForHeaderInSection:(NSInteger)section
//{
//    CGFloat size = [PhotoCollectionCell preferredSizeInCluster];
//    return CGSizeMake(size, size);
//}

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


#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
                                                                  presentingController:(UIViewController *)presenting
                                                                      sourceController:(UIViewController *)source
{
    ModalTransitionAnimator *animator = [[ModalTransitionAnimator alloc] init];
    animator.isPresenting = YES;
    animator.startFrame = self.selectedCellFrame;
    return animator;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    ModalTransitionAnimator *animator = [[ModalTransitionAnimator alloc] init];
    return animator;
}

@end
