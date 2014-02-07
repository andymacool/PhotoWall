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
#import "FastScroller.h"

static NSString * const ZoomOutPhotoTableViewCellID = @"ZoomOutPhotoTableViewCellID";

@interface ZoomOutPhotoViewController () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic) UITapGestureRecognizer *singleTapGesture;
@property (nonatomic) UITableView *tableView;
@end

@implementation ZoomOutPhotoViewController

#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"Clusters";
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.singleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    self.singleTapGesture.numberOfTapsRequired = 1;
    
    [self.tableView addGestureRecognizer:self.singleTapGesture];
    [self.tableView registerClass:[ZoomOutPhotoTableViewCell class] forCellReuseIdentifier:ZoomOutPhotoTableViewCellID];

    [self.tableView reloadData];
    
    // install the scroller
    
//    CGFloat x, y, w, h;
//    w = 20.0;
//    h = self.view.bounds.size.height - 40;
//    x = self.view.bounds.size.width - w;
//    y = 64;
//
//    FastScroller *scroller = [[FastScroller alloc] initWithFrame:CGRectMake(x, y, w, h)];
//    scroller.scrollPeer = self.tableView;
//    [self.view addSubview:scroller];
    
    self.scroller.scrollPeer = self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // adjust the table view's scroll offset
    [self.scroller adjustScrollView];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    // adjust the table view's scroll offset
//    [self.scroller adjustScrollView];
//}

- (IBAction)dismiss:(UIGestureRecognizer *)recognizer
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
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
