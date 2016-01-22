//
//  ContactListViewController.m
//  AddressBookApp
//
//  Created by Anushree Kala on 2016-01-17.
//  Copyright © 2016 Kinectic_Cafe. All rights reserved.
//

#import "ContactListViewController.h"
#import "DetailViewController.h"
#import "Contacts.h"
#import "AppDelegate.h"
#import "ContactDisplayCell.h"


@interface ContactListViewController (){
    AppDelegate *_appDelegate;
    NSArray *searchResults;
    BOOL isFiltered;
    NSArray *searchedDataArray;
}

@end

@implementation ContactListViewController
static dispatch_once_t once;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    dispatch_once(&once, ^
                  {
                      _appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
                      
                  });
    
    // isFiltered is used for search result
    isFiltered = FALSE;
    
    self.navigationItem.title = @"Contact List";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:nil action:nil];
    [[self navigationItem] setBackBarButtonItem:backButton];
    
    // Assign our own backgroud for the view
    self.parentViewController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"common_bg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    // Add padding to the top of the table view
    UIEdgeInsets inset = UIEdgeInsetsMake(5, 0, 0, 0);
    self.tableView.contentInset = inset;
    
    
    //This array is initialized to get all user name.
    searchResults = [[NSMutableArray alloc]initWithArray:_appDelegate.userDataArray];
    
    //This array is used for storing search data
    searchedDataArray = searchResults;
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchedDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 71;
}


// method for setting background image on cell
- (UIImage *)cellBackgroundForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger rowCount = [self tableView:[self tableView] numberOfRowsInSection:0];
    NSInteger rowIndex = indexPath.row;
    UIImage *background = nil;
    
    if (rowIndex == 0) {
        background = [UIImage imageNamed:@"cell_top.png"];
    } else if (rowIndex == rowCount - 1) {
        background = [UIImage imageNamed:@"cell_bottom.png"];
    } else {
        background = [UIImage imageNamed:@"cell_middle.png"];
    }
    
    return background;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *CellIdentifier = @"Cell";
    
    ContactDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ContactDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Assign our own background image for the cell
    UIImage *background = [self cellBackgroundForRowAtIndexPath:indexPath];
    
    UIImageView *cellBackgroundView = [[UIImageView alloc] initWithImage:background];
    cellBackgroundView.image = background;
    cell.backgroundView = cellBackgroundView;
    
    NSString* user = [searchedDataArray objectAtIndex:indexPath.row];
    cell.contactName.text = user;
    
    NSData *imageData = [_appDelegate.userData objectForKey:user];
    //Get main queue to update UI
    dispatch_async(dispatch_get_main_queue(), ^{
        cell.imageView.image = [UIImage imageWithData:(NSData *)imageData];
    });
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //Push DetailViewController and pass selected data to display.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"detailView"];
    detailViewController.userInfo = (NSMutableDictionary*)[_appDelegate.allUsers objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text=@"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length>0) {
        isFiltered = TRUE;
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSPredicate *predicate =[NSPredicate predicateWithFormat: @"SELF CONTAINS[cd] %@", searchText];
        //        searchResults= [_appDelegate.allUsers filteredArrayUsingPredicate:predicate];
        //  searchedDataArray = [_appDelegate.userDataArray filteredArrayUsingPredicate:predicate];
        searchedDataArray = [searchResults filteredArrayUsingPredicate:predicate];
        
        [self.tableView reloadData];
        
        
        
    }
    else
    {
        // searchResults=_appDelegate.userDataArray;
        searchedDataArray=searchResults;
        
        [self.tableView reloadData];
        
    }
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    searchedDataArray=searchResults;
    
    [self.tableView reloadData];
}



#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    //FromContactListVC
//}


@end
