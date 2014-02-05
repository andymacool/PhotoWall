//
//  PhotoFetcher.m
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "PhotoFetcher.h"
#import <AssetsLibrary/AssetsLibrary.h>

const NSUInteger kNumOfTotalClusters   = 20;
const NSUInteger kNumOfPhotosInCluster = 20;

@interface PhotoFetcher ()
@property (nonatomic) ALAssetsLibrary *assetsLibrary;
@property (nonatomic) NSMutableArray  *mThumbnails; // of UIImage of thumbnails
@property (nonatomic) NSMutableArray  *mAssets;     // of ALAssets
@property (nonatomic) NSMutableArray  *mClusters;   // of NSArray of thumbnails
@property (nonatomic) NSMutableArray  *mClusterSnapshots;
@end

@implementation PhotoFetcher

+ (instancetype)sharedInstance
{
    static PhotoFetcher *gInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[PhotoFetcher alloc] init];
    });
    return gInstance;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        _mAssets = [NSMutableArray new];
        _mClusters = [NSMutableArray new];
        _mThumbnails = [NSMutableArray new];
        _mClusterSnapshots = [NSMutableArray new];
    }
    return self;
}

#pragma mark -

- (NSArray *)assets
{
    return [_mAssets copy];
}

- (NSArray *)thumbnails
{
    return [_mThumbnails copy];
}

- (NSArray *)clusters
{
    return [_mClusters copy];
}

- (NSArray *)clusterSnapshots
{
    return [_mClusterSnapshots copy];
}

- (ALAssetsLibrary *)assetsLibrary
{
    if (!_assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark -

- (void)countLibraryPhotosWithCompletion:(void (^)(int))completion
{
    __block int count = 0;
    
    void (^assetCountBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            completion(count);
        } else {
            [group enumerateAssetsWithOptions:NSEnumerationReverse
                                   usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                       if(asset != nil) count ++;
                                   }];
        }
    };
    
    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                      usingBlock:assetCountBlock
                                    failureBlock:^(NSError *error) {
                                        NSLog(@"ERROR in counting ALAssetLibrary.");
                                    }];
}

- (void)fetchLibraryPhotosWithProgress:(PhotoFetcherProgressBlock)progress
                         andCompletion:(PhotoFetcherCompletionBlock)completion
{
    __block void (^assetGroupEnumBlock)(ALAsset *, NSUInteger, BOOL *);

    // define shared Library Enum Block
    void (^assetLibraryEnumBlock)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
    {
        if (group == nil) {
            NSLog(@"Done enumerating all ALAsset groups with total %d photos.\n", _mAssets.count);
            [self buildClusters];
            completion();
        } else {
            if (assetGroupEnumBlock) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse
                                       usingBlock:assetGroupEnumBlock];
            }
        }
    };
    
    if (!progress)
    {
        assetGroupEnumBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
        {
            if (asset == nil) {
                NSLog(@"Done enumerating ALAssets in group.\n");
            }
            
            if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto) {
                [_mAssets addObject:asset];
                [_mThumbnails addObject:[UIImage imageWithCGImage:asset.thumbnail]];
            }
        };
        
        // start enumeration
        if (assetLibraryEnumBlock)
        {
            [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                              usingBlock:assetLibraryEnumBlock
                                            failureBlock:^(NSError *error) {
                                                NSLog(@"ERROR in enumerating ALAssetGroup: %@.\n", error);
                                            }];
        }
    
    }
    else
    {
        [self countLibraryPhotosWithCompletion:^(int totalCount) {
            
            // define a enum block again
            __block NSUInteger fetched = 0;
            
            assetGroupEnumBlock = ^(ALAsset *asset, NSUInteger index, BOOL *stop)
            {
                if (asset == nil) {
                    NSLog(@"Done enumerating ALAssets in group.\n");
                }
                
                if ([asset valueForProperty:ALAssetPropertyType] == ALAssetTypePhoto) {
                    [_mAssets addObject:asset];
                    [_mThumbnails addObject:[UIImage imageWithCGImage:asset.thumbnail]];
                    
                    fetched ++;
                    
                    if (progress) {
                        progress((double)fetched / totalCount);
                    }
                }
            };
            
            // start enumeration
            if (assetLibraryEnumBlock)
            {
                [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                                  usingBlock:assetLibraryEnumBlock
                                                failureBlock:^(NSError *error) {
                                                    NSLog(@"ERROR in enumerating ALAssetGroup: %@.\n", error);
                                                }];
            }
        }];
    }
}

// cluster builder
// call after fetch

- (void)buildClusters
{
    if (!_mClusters) {
        _mClusters = [NSMutableArray new];
    }

    if (_mThumbnails.count > kNumOfPhotosInCluster * kNumOfTotalClusters)
    {
        for (int i = 0; i < kNumOfTotalClusters; i++)
        {
            NSRange range = NSMakeRange(kNumOfPhotosInCluster*i, kNumOfPhotosInCluster);
            NSArray *cluster = [_mThumbnails subarrayWithRange:range];
            [_mClusters addObject:cluster];
            [self buildSnapshotFromCluster:cluster];
        }
    }
}

- (void)buildSnapshotFromCluster:(NSArray *)cluster
{
    // pick first 10 images from a cluster
    // and compose them into a bigger image.
    
    NSAssert(kNumOfPhotosInCluster > 10, @"ERROR, Cannot compose a big snapshot !\n");
    
    CGSize size = CGSizeMake(320, 40);

    UIGraphicsBeginImageContext(size);
    
    for (int i = 0; i < 8; i++)
    {
        UIImage *img = [cluster objectAtIndex:i];
        
        UIImage *smallImg = [self imageWithImage:img scaledToSize:CGSizeMake(40, 40)];
        
        [smallImg drawInRect:CGRectMake(i*smallImg.size.width, 0, smallImg.size.width, smallImg.size.height)];
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [_mClusterSnapshots addObject:finalImage];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
