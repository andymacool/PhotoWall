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
@property (nonatomic) UITapGestureRecognizer *singleTapGesture;
@end

@implementation ZoomOutPhotoViewController

#pragma mark - Init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    self.singleTapGesture.numberOfTapsRequired = 1;
    
    [self.tableView addGestureRecognizer:self.singleTapGesture];
    [self.tableView registerClass:[ZoomOutPhotoTableViewCell class] forCellReuseIdentifier:ZoomOutPhotoTableViewCellID];
}

- (IBAction)dismiss:(UIGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
