//
//  AppCore.h
//  PhotoWall
//
//  Created by Andy Wang on 2/4/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

//  This Singleton Object has two purpose:
//  1. setup some app configurations.
//  2. control navigations of the app.

@interface AppCore : NSObject

@property (nonatomic) UITabBarController *rootVC;           // app's main tabbar controller
@property (nonatomic) UINavigationController *clusterNav;   // a child of tabbar controller

+ (instancetype)sharedInstance;

@end
