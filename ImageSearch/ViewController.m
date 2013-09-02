//
//  ViewController.m
//  ImageSearch
//
//  Created by Prasanth Sivanappan on 01/09/13.
//  Copyright (c) 2013 Prasanth Sivanappan. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@interface ViewController ()
@property (nonatomic, strong) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *imageResults;
@property (weak, atomic) NSMutableArray *names;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSMutableArray *firstSection = [[NSMutableArray alloc] init]; NSMutableArray *secondSection = [[NSMutableArray alloc] init];
    
    self.title = @"Image Search";
    self.imageResults = [NSMutableArray array];
    self.dataArray = [[NSArray alloc] initWithObjects:firstSection, secondSection, nil];
//    UINib *cellNib = [UINib nibWithNibName:@"ImageCell" bundle:nil];
//    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"cvCell"];
    
    [self.collectionView registerClass:[ImageCell class] forCellWithReuseIdentifier:@"imgCell"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imageResults count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"imgCell";
    
    ImageCell *cell = (ImageCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.imageView.image = NULL;
    [cell.imageView setImageWithURL:[NSURL URLWithString:[self.imageResults[indexPath.row] valueForKeyPath:@"url"]]];
    
    return cell;
    
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation) interfaceOrientation duration:(NSTimeInterval)duration{
    CGFloat width = CGRectGetWidth(self.view.bounds);
    self.searchBar.frame = CGRectMake(0, 0, width, 44);

}

#pragma mark - UISearchBar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.imageResults removeAllObjects];
    [self fetchAddImages:searchBar start:0];
    [self.collectionView reloadData];
    [self fetchAddImages:searchBar start:8];
    [self fetchAddImages:searchBar start:17];
 }

- (void)fetchAddImages : (UISearchBar *)searchBar start:(int) start{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&filter=0&q=%@&start=%d", [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],start]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        id results = [JSON valueForKeyPath:@"responseData.results"];
        if ([results isKindOfClass:[NSArray class]]) {
            [self.imageResults addObjectsFromArray:results];
            [self.collectionView reloadData];
        }
    } failure:nil];
    
    [operation start];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [searchBar setShowsCancelButton:YES animated:YES];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [searchBar resignFirstResponder];
    return YES;
}


@end
