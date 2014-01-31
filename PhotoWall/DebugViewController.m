//
//  DebugViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 1/30/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "DebugViewController.h"
#import "PhotoFetcher.h"

@interface DebugViewController ()

@end

@implementation DebugViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 40)];
    [self.view addSubview:self.imageView];
    
    self.imageView.image = [[PhotoFetcher sharedInstance].clusterSnapshots objectAtIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
