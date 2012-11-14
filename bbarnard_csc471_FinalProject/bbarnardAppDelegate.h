//
//  bbarnardAppDelegate.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class bbarnard_NotesNavViewController;
@class bbarnard_NoteData;

@interface bbarnardAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) IBOutlet UITabBarController *rootController;
@property (strong, nonatomic) NSMutableArray *noteArray;

- (void) copyDatabaseIfNeeded;
- (NSString *) getDBPath;
- (void) removeNote:(bbarnard_NoteData *)noteObj;
- (void) addNote:(bbarnard_NoteData *)noteObj;
- (void) updateNote:(bbarnard_NoteData *)noteObj;

@end
