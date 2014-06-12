//
//  PhotoCollectionViewCell.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/10/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "PhotoCollectionViewCell.h"

#define IMAGEVIEW_BORDER_LENGTH 5

@implementation PhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup]; 
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    [self.contentView addSubview:self.imageView];
}

@end
