//
//  PhotoDetailViewController.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/11/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "PhotoDetailViewController.h"
#import "Photo.h"
#import "FiltersCollectionViewController.h"

@interface PhotoDetailViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation PhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.imageView.image = self.photo.image;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation 

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"FilterSegue"]) {
        if ([segue.destinationViewController isKindOfClass:[FiltersCollectionViewController class]]) {
            
            FiltersCollectionViewController *targetViewController = segue.destinationViewController;
            
            targetViewController.photo = self.photo; 
        }
    }
}



#pragma mark - IBAction

- (IBAction)addFilterButtonPressed:(UIButton *)sender
{
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender
{
    [[self.photo managedObjectContext]deleteObject:self.photo];
    
    NSError *error = nil;
    
    [[self.photo managedObjectContext]save:&error];
    
    if (error) {
        NSLog(@"%@", error); 
    }
    
    [self.navigationController popViewControllerAnimated:YES]; 
}

















@end
