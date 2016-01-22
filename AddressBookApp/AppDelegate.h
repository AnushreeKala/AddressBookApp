//
//  AppDelegate.h
//  AddressBookApp
//
//  Created by Anushree Kala on 2016-01-17.
//  Copyright © 2016 Kinectic_Cafe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//Contains all data
@property (nonatomic,strong) NSArray *allUsers;

//contains image and name of the user
@property (nonatomic,strong) NSMutableDictionary *userData;

//contains only user name
@property (nonatomic,strong) NSMutableArray *userDataArray;



- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

