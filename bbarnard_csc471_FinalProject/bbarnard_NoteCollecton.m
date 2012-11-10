//
//  bbarnard_NoteCollecton.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteCollecton.h"
#import "bbarnard_NoteData.h"

static sqlite3 *db = nil;

/**
 * Implement CRUD Operations over local SQLite DB
 */
@implementation bbarnard_NoteCollecton

/**
 * get notes from SQLLITE DB
 */
+(NSMutableArray *) getNotes {

    //get notes from database
    NSMutableArray *noteArray = [[NSMutableArray alloc] init];
    
    //short circuit if the db file does not exist
    if(![self checkDbExists]) {
        return noteArray;
    }

    @try
    {
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];

        if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        
            const char *sql = "SELECT noteId, title, content FROM notes";
            sqlite3_stmt *sqlStatement;
        
            if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
        
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    bbarnard_NoteData *MyNote = [[bbarnard_NoteData alloc]init];
            
                    MyNote.noteId = sqlite3_column_int(sqlStatement, 0);
            
                    MyNote.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            
                    MyNote.content = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            
                    [noteArray addObject:MyNote];

                }
            
            } else {
                NSLog(@"Problem with prepare statement");
            }
        } else {
                NSLog(@"Problem opening database statement");
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error selecting notes from SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally
    {
        return noteArray;
        sqlite3_close(db);
    }
}


+(BOOL)checkDbExists {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];
    BOOL success = [fileMgr fileExistsAtPath:dbPath];
    
    if(!success)
        {
            NSLog(@"Cannot locate database file '%@', ", dbPath);
            return NO;
            sqlite3_close(db);
        }
    
    if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured.");
            sqlite3_close(db);
            return NO;
        }
    
    sqlite3_close(db);
    return YES;
}

/**
 * create a new note and insert in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) createNote:(bbarnard_NoteData *)noteObject {
    
    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }

    
    @try {
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error creating note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        return NO;
    }
}

/**
 * update an existing note in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) updateNote:(bbarnard_NoteData *)noteObject {
    
    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }
        
    @try {
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error updating note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];

    }
    @finally {
        return NO;
    }
}

/**
 * delete an existing note in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) deleteNote:(bbarnard_NoteData *)noteObject {

    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }
    
    @try {
        
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error deleting note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];

    }
    @finally {
        return NO;
    }
}


@end