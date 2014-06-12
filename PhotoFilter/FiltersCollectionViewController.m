//
//  FiltersCollectionViewController.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/11/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "FiltersCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"

@interface FiltersCollectionViewController ()

@property (strong ,nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;


@end

@implementation FiltersCollectionViewController

//Lazy Instantiation
- (CIContext *)context
{
    if (!_context) {
        _context = [CIContext contextWithOptions:nil];
    }
    return _context;
}

- (NSMutableArray *)filters
{
    if (!_filters) {
        _filters = [NSMutableArray new];
    }
    return _filters;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.filters = [[[self class]photoFilters]mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICollection View DataSource 

//UIimages with the filters applied

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    //Create PhotoCollectionViewCell Object
    
    PhotoCollectionViewCell *photoViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    photoViewCell.backgroundColor = [UIColor whiteColor];
    
    photoViewCell.imageView.image = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
    
    return photoViewCell;
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.filters.count;
}

#pragma mark - UICollectionView Delegate

//Save image with filter

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCollectionViewCell *selectedCell = (PhotoCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    self.photo.image = selectedCell.imageView.image;
    
    if (self.photo.image) {
        NSError *error = nil;
        
        if (![[self.photo managedObjectContext]save:&error]) {
            //Handle Error
            
            NSLog(@"%@", error);
            
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark - Helpers


+ (NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
    
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues: nil];
    
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues: nil];
    
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues: nil];
    
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues: nil];
    
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues: nil];
    
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues: nil];
    
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues: nil];
    
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome];
    
    return allFilters;
}


// Method returns a UIImage with a filter applied
-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    /* Create a CIImage using the property on UIImage, CGImage. */
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    /* Set the filter with the unfiltered CIImage for key kCIInputImageKey */
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    /* Get the filtered image back calling the method outputImage */
    CIImage *filteredImage = [filter outputImage];
    
    /* Get the size of the image using the method extent */
    CGRect extent = [filteredImage extent];
    
    /* Create a CGImageRef using the method createCGImage with the size extent. */
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    
    /* Create a UIImage from our cgImage. */
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];

    
    return finalImage;
}



















@end
