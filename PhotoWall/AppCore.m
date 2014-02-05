//
//  AppCore.m
//  PhotoWall
//
//  Created by Andy Wang on 2/4/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "AppCore.h"

@interface AppCore ()

@end

@implementation AppCore

+ (instancetype)sharedInstance
{
    static AppCore *gInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gInstance = [[AppCore alloc] init];
    });
    return gInstance;
}

- (UIViewController *)rootVC
{
    NSAssert(_rootVC, @"You must set the rootVC for AppCore !");
    return _rootVC;
}

@end
