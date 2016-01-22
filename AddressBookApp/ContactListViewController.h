//
//  ContactListViewController.h
//  AddressBookApp
//
//  Created by Anushree Kala on 2016-01-17.
//  Copyright © 2016 Kinectic_Cafe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListViewController : UITableViewController<UISearchBarDelegate,UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText; 

@end
