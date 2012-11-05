//
//  bbarnardAppDelegate.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>
@class bbarnard_NotesNavViewController;

@interface bbarnardAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
