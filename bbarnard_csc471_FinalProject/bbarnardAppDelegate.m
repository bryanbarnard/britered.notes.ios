//
//  bbarnardAppDelegate.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnardAppDelegate.h"
#import "bbarnard_NoteData.h"
#import "bbarnard_NoteCollecton.h"


@implementation bbarnardAppDelegate

@synthesize window = _window;
@synthesize rootController;
@synthesize noteArray;

#pragma mark -
#pragma mark Application Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    /* copy database to the user's phone if needed */
	[self copyDatabaseIfNeeded];

    /* init note array */
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.noteArray = tempArray;

    /* load notes array from db */
    [bbarnard_NoteCollecton getNotes:[self getDBPath]];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [[NSBundle mainBundle] loadNibNamed:@"bbarnard_TabBarController" owner:self options:nil]; [self.window addSubview:rootController.view];
    self.window.backgroundColor = [UIColor redColor];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void) copyDatabaseIfNeeded {
	
	//Using NSFileManager we can perform many file system operations.
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSString *dbPath = [self getDBPath];
	BOOL success = [fileManager fileExistsAtPath:dbPath];
	
	if(!success) {
		
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
		
		if (!success)
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
	}
}

- (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

- (void) removeNote:(bbarnard_NoteData *)noteObj {

    //Delete it from the database.
    [bbarnard_NoteCollecton deleteNote:noteObj];

    //Remove it from the array.
    [noteArray removeObject:noteObj];
}

- (void) addNote:(bbarnard_NoteData *)noteObj {

    //Add it to the database.
    [bbarnard_NoteCollecton createNote:noteObj];

    //Add it to the coffee array.
    [noteArray addObject:noteObj];
}


@end
