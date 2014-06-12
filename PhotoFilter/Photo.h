//
//  Photo.h
//  PhotoFilter
//
//  Created by JUSTIN on 6/10/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album;

@interface Photo : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Album *albumBook;

@end
