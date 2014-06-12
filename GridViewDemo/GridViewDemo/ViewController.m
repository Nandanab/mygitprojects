//
//  ViewController.m
//  GridViewDemo
//
//  Created by Nandana Behera on 11/06/14.
//  Copyright (c) 2014 Nandana Behera. All rights reserved.
//

#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DetailsViewController.h"

@interface Viewcontroller ()

@end

@implementation Viewcontroller
@synthesize ImageArray;

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	

    ImageArray = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    
    ALAssetsLibrary *assetsLibrary = [Viewcontroller defaultAssetsLibrary];
 
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                
                [tmpAssets addObject:result];
            }
        }];
        
      
        self.ImageArray = tmpAssets;
        
        
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"Your photos";
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationItem.title = @"";
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ImageArray.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"Cell";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ALAsset *asset = self.ImageArray[indexPath.row];
    
    
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
    recipeImageView.image = [UIImage imageWithCGImage:[asset thumbnail]];
    
   
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self performSegueWithIdentifier:@"displayDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"displayDetail"])
    {
          NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
        
        DetailsViewController *imageDetailViewController = (DetailsViewController *)segue.destinationViewController;
        
        ALAsset *asset = self.ImageArray[indexPath.row];
        imageDetailViewController.Image = [UIImage imageWithCGImage:[asset thumbnail]];
        
       
    }
}


@end
