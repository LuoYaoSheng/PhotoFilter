//
//  CoreDateHelper.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/9/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "CoreDateHelper.h"

@implementation CoreDateHelper

+ (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication]delegate];
    
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext]; 
    }
    
    return context; 
}

@end
