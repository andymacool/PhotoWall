//
//  FastScrollerThumb.m
//  PhotoWall
//
//  Created by Andy Wang on 1/27/14.
//  Copyright (c) 2014 Andy Wang. All rights reserved.
//

#import "FastScrollerThumb.h"

@implementation FastScrollerThumb

+ (CGFloat)preferredHeight
{
    return 100.0;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return self;
}

@end
