//
//  PictureDataTransformer.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/10/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "PictureDataTransformer.h"

@implementation PictureDataTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES; 
}

//UIImage to NData
- (id)transformedValue:(id)value
{
    return UIImagePNGRepresentation(value);
}


//change NSData into UIImage
- (id)reverseTransformedValue:(id)value
{
    UIImage *image = [UIImage imageWithData:value];
    return image;
}

@end
