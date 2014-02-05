//
//  AppDelegate.m
//  PhotoWall
//
//  Created by Andy Wang on 7/8/13.
//  Copyright (c) 2013 Andy Wang. All rights reserved.
//

#import "AppDelegate.h"
#import "AppCore.h"
#import "PhotoGridViewController.h"
#import "PhotoClustersViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    PhotoClustersViewController *clusterController = [[PhotoClustersViewController alloc] init];
    UINavigationController *clusterControllerNav = [[UINavigationController alloc] initWithRootViewController:clusterController];

    PhotoGridViewController *gridController = [[PhotoGridViewController alloc] init];
    UINavigationController *gridControllerNav = [[UINavigationController alloc] initWithRootViewController:gridController];
        
    UITabBarController *rootTab = [[UITabBarController alloc] init];
    [rootTab setViewControllers:@[clusterControllerNav, gridControllerNav]];

    [AppCore sharedInstance].rootVC = rootTab; // use for presenting controllers

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = rootTab;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
