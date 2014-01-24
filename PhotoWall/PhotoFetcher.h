//
//  PhotoFetcher.h
//  PhotoWall
//
//  Created by Andy Wang on 1/23/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PhotoFetcherProgressBlock) (double progress);
typedef void (^PhotoFetcherCompletionBlock) (void);

//  the Model object
@interface PhotoFetcher : NSObject

@property (nonatomic, readonly) NSArray *assets;     // of ALAssets
@property (nonatomic, readonly) NSArray *clusters;   // pre-built 20 clusters
@property (nonatomic, readonly) NSArray *thumbnails; // of UIImage of thumbnails


+ (instancetype) sharedInstance;

- (void) fetchLibraryPhotosWithProgress:(PhotoFetcherProgressBlock)progress
                          andCompletion:(PhotoFetcherCompletionBlock)completion;


@end
