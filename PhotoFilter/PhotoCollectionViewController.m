//
//  PhotoCollectionViewController.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/9/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "PhotoCollectionViewController.h"
#import "PhotoCollectionViewCell.h"
#import "Photo.h"
#import "PictureDataTransformer.h"
#import "CoreDateHelper.h"
#import "PhotoDetailViewController.h"

@interface PhotoCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos; // of UIImages

@end

@implementation PhotoCollectionViewController

// Lazy Instantiation

- (NSMutableArray*)photos
{
    if (!_photos) {
        _photos = [NSMutableArray new];
    }
    return _photos;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //Photos are store in Core Data as NSSet..
    NSSet *unorderedPhotos = self.album.photos;
    
    //Organize by date
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    self.photos = [sortedPhotos mutableCopy];
    
    
    [self.collectionView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailsSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoDetailViewController class]]) {
            PhotoDetailViewController *targetViewController = segue.destinationViewController;
            
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems]lastObject];
            
            Photo *selectedPhoto = self.photos[indexPath.row];
            targetViewController.photo = selectedPhoto;
            
        }
    }
    
}

#pragma mark - IBAction

//Create UIImagePicjerController and present the available option on screen.
//Camera if using on phone... photo album is used on simulator

- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    [self presentViewController:picker animated:YES completion:nil];
    
    
    
}


#pragma mark - UIImagePickerController Delegate

//Fires when user picks an image

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    [self.photos addObject:[self photoFromImage:image]];
    
    [self.collectionView reloadData];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [self dismissViewControllerAnimated:YES completion:nil];
    
}




#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    PhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Photo *photo = self.photos[indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = photo.image;
    return cell;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}


#pragma mark - Helper Methods

- (Photo *)photoFromImage:(UIImage *)image
{
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[CoreDateHelper managedObjectContext]];
    
    photo.image = image;
    photo.date = [NSDate date];
    photo.albumBook = self.album;
    
    
    
    NSError *error = nil;
    if (![[photo managedObjectContext]save:&error]) {
        NSLog(@"Error in Saving, %@", error);
    }
    return photo;
    
}
















@end
