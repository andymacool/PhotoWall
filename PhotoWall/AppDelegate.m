//
//  AppDelegate.m
//  PhotoWall
//
//  Created by Andy Wang on 7/8/13.
//  Copyright (c) 2013 Andy Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "PhotoGridViewController.h"
#import "PhotoClustersViewController.h"
#import "DebugViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

#define SHOW_CLUSTERS_ONLY
#ifdef  SHOW_CLUSTERS_ONLY
    PhotoClustersViewController *photoClustersVC = [[PhotoClustersViewController alloc] init];
    DebugViewController *debugVC = [[DebugViewController alloc] init];
    
    UITabBarController *rootTab = [[UITabBarController alloc] init];
    [rootTab setViewControllers:@[photoClustersVC,debugVC]];
    self.window.rootViewController = rootTab;
#else
    PhotoGridViewController     *photoGridVC = [[PhotoGridViewController alloc] init];
    PhotoClustersViewController *photoClustersVC = [[PhotoClustersViewController alloc] init];
    
    UITabBarController *rootTab = [[UITabBarController alloc] init];
    [rootTab setViewControllers:@[photoGridVC, photoClustersVC]];
    self.window.rootViewController = rootTab;
#endif
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
