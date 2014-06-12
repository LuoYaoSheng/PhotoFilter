//
//  AlbumTableViewController.m
//  PhotoFilter
//
//  Created by JUSTIN on 6/9/14.
//  Copyright (c) 2014 jstnheo. All rights reserved.
//

#import "AlbumTableViewController.h"
#import "Album.h"
#import "CoreDateHelper.h"
#import "PhotoCollectionViewController.h"


@interface AlbumTableViewController () <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *albums;

@end

@implementation AlbumTableViewController


//Lazy Instantiation
- (NSMutableArray*)albums
{
    if (!_albums) {
        _albums = [[NSMutableArray alloc]init];
    }
    return _albums;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}


//Each time the view appears, query core data for all saved Album objects

-(void)viewDidAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    NSError *error = nil;
    NSArray *fetchedAlbums = [[CoreDateHelper managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    
    self.albums = [fetchedAlbums mutableCopy];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AlbumChosen"]) {
        if ([segue.destinationViewController isKindOfClass:[PhotoCollectionViewController class]])
        {
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            
            PhotoCollectionViewController *targetViewController = segue.destinationViewController;
            targetViewController.album = self.albums[path.row];
        }
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.albums.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //configure the cell
    Album *selectedAlbum = self.albums[indexPath.row];
    cell.textLabel.text = selectedAlbum.name;
    
    return cell; 
}

#pragma mark - UIAlertView Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        [self.albums addObject:[self albumWithName:alertText]];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count] - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}


#pragma mark - IBAction 

- (IBAction)addAlbumBarButtonPressed:(UIBarButtonItem *)sender {
    
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [newAlbumAlertView show];
}

#pragma mark - Helper Methods

- (Album *)albumWithName:(NSString *)name
{
    //This helper method persists an Album object using Core Data
    
    NSManagedObjectContext *context = [CoreDateHelper managedObjectContext];
    
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    
    album.name = name;
    album.date = [NSDate date];
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        //we have an error;
    }
    
    return album;
    
}















@end
