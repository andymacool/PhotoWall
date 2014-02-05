//
//  ZoomOutPhotoViewController.m
//  PhotoWall
//
//  Created by Andy Wang on 2/4/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "ZoomOutPhotoViewController.h"
#import "ZoomOutPhotoTableViewCell.h"
#import "PhotoFetcher.h"

static NSString * const ZoomOutPhotoTableViewCellID = @"ZoomOutPhotoTableViewCellID";

@interface ZoomOutPhotoViewController ()

@end

@implementation ZoomOutPhotoViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self.tableView registerClass:[ZoomOutPhotoTableViewCell class] forCellReuseIdentifier:ZoomOutPhotoTableViewCellID];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [PhotoFetcher sharedInstance].clusters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZoomOutPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZoomOutPhotoTableViewCellID
                                                                      forIndexPath:indexPath];
    
    UIImage *composedImage = [[PhotoFetcher sharedInstance].clusterSnapshots objectAtIndex:indexPath.row];
    
    cell.imageView.image = composedImage;

    return cell;
}

@end
