//
//  bbarnard_NoteCollecton.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteCollecton.h"
#import "bbarnard_NoteData.h"
#import "bbarnardAppDelegate.h"

static sqlite3 *db = nil;

/**
 * Implement CRUD Operations over local SQLite DB
 */
@implementation bbarnard_NoteCollecton


/**
 * get notes from SQLLITE DB and populate array in appDelegate
 */
+(void)getNotesDB:(NSString *)dbPath {

    NSLog(@"dbPath: %@ ", dbPath);
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];

    @try
    {
        if (sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK) {
        
            const char *sql = "SELECT noteId, title, content, altId, author FROM notes";
            sqlite3_stmt *sqlStatement;
        
            if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) == SQLITE_OK) {
                
                while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
                    bbarnard_NoteData *noteObj = [[bbarnard_NoteData alloc]init];
                    noteObj.noteId = sqlite3_column_int(sqlStatement, 0);
                    noteObj.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
                    noteObj.content = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
                    noteObj.altId = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
                    noteObj.author = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 4)];

                    [appDelegate.noteArray addObject:noteObj];
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
        sqlite3_close(db);
    }
}


+ (NSString *) getDBPath {
	
	//Search for standard documents using NSSearchPathForDirectoriesInDomains
	//First Param = Searching the documents directory
	//Second Param = Searching the Users directory and not the System
	//Expand any tildes and identify home directories.
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	NSString *documentsDir = [paths objectAtIndex:0];
	return [documentsDir stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];
}

+(BOOL)checkDbExists {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSString *dbPath = [bbarnard_NoteCollecton getDBPath];
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
    NSAssert(noteObject != nil, @"Invalid Argument Passed to createNote, noteObject Nil.");
    bbarnard_NoteData *note = noteObject;
    
    /* set time values */
    NSTimeInterval nowEpoch = [[NSDate date] timeIntervalSince1970];
    NSString *nowEpochString = [NSString stringWithFormat:@"%f", nowEpoch];
    BOOL insertSuccess;

    /* set any note object values that are not yet set*/
    [note setCreated_on: nowEpochString];
    [note setUpdated_on: nowEpochString];
    
    if ([noteObject.altId isEqualToString:@""] || noteObject.altId == nil) {
        [note setAltId: @"1"];
    }
    
    if ([noteObject.author isEqualToString:@""] || noteObject.author == nil) {
        [note setAuthor: @"1"];
    }
    
    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }

        sqlite3_stmt *sqlStatement = nil;
        const char *sql = "INSERT INTO Notes(created_on, updated_on, content, title, altId, author) Values(?, ?, ?, ?, ?, ?)";
        
        //open
        NSString *dbPath = [bbarnard_NoteCollecton getDBPath];

        if(SQLITE_OK == sqlite3_open([dbPath UTF8String], &db)) {
            NSLog(@"db open ok");
        }

        NSLog(@"Preparing Insert Statement");
        //prepare and catch error
        if (sqlite3_prepare_v2(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK) {
            NSAssert1(0, @"Error while creating insert statement. '%s'", sqlite3_errmsg(db));
        }

        /* set sql statement variables */
        sqlite3_bind_text(sqlStatement, 1, [[note created_on] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 2, [[note updated_on] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 3, [[note content] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 4, [[note title] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 5, [[note altId] UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(sqlStatement, 6, [[note author] UTF8String], -1, SQLITE_TRANSIENT);
        
        NSLog(@"Insert Statement Prepared.");

    @try {
        if (SQLITE_DONE != sqlite3_step(sqlStatement)) {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(db));
            insertSuccess = NO;
        } else {
            [note setNoteId: sqlite3_last_insert_rowid(db)];
            insertSuccess = YES;
            NSLog(@"New Note Successfully Created. ID: %d", note.noteId);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error creating note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        return insertSuccess;
    }
}


/**
 * update an existing note in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) updateNote:(bbarnard_NoteData *)noteObject {

    NSAssert(noteObject != nil, @"Invalid Argument Passed to updateNote, noteObject Nil.");

    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }

    bbarnard_NoteData *note = noteObject;

    /* set time values */
    NSTimeInterval nowEpoch = [[NSDate date] timeIntervalSince1970];
    NSString *nowEpochString = [NSString stringWithFormat:@"%f", nowEpoch];

    /* return value defined */
    BOOL updateSuccess;

    /* set any note object values that are not yet set*/
    if ([note.created_on isEqualToString:@""]) {
        [note setCreated_on: nowEpochString];
    }

    if ([note.author isEqualToString:@""]) {
        [note setAuthor: @"1"];
    }

    if ([note.altId isEqualToString:@""]) {
        [note setAltId:@"1"];
    }

    [note setUpdated_on: nowEpochString];

    sqlite3_stmt *sqlStatement = nil;
    const char *sql = "UPDATE notes SET updated_on = ?, content = ?, title = ? WHERE noteId = ?";

    /* open database */
    NSString *dbPath = [bbarnard_NoteCollecton getDBPath];
    if(SQLITE_OK == sqlite3_open([dbPath UTF8String], &db)) {
        NSLog(@"db open ok");
    }

    /* prepare statement */
    NSLog(@"Preparing Insert Statement");
    if (sqlite3_prepare_v2(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating update statement. '%s'", sqlite3_errmsg(db));
    }

    /* set sql statement variables */
    sqlite3_bind_text(sqlStatement, 1, [[note updated_on] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sqlStatement, 2, [[note content] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(sqlStatement, 3, [[note title] UTF8String], -1, SQLITE_TRANSIENT);
    sqlite3_bind_int(sqlStatement, 4, note.noteId);

    NSLog(@"Update Statement Prepared.");

    @try {
        if (SQLITE_DONE != sqlite3_step(sqlStatement)) {
            NSAssert1(0, @"Error while updating data. '%s'", sqlite3_errmsg(db));
            updateSuccess = NO;
        } else {
            updateSuccess = YES;
            NSLog(@"Note Successfully Updated. ID: %d", note.noteId);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error updating note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        return updateSuccess;
    }
}

/**
 * delete an existing note in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) deleteNote:(bbarnard_NoteData *)noteObject {

    NSAssert(noteObject != nil, @"Invalid Argument Passed to deleteNote, noteObject Nil.");

    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }

    bbarnard_NoteData *note = noteObject;

    /* return value defined */
    BOOL deleteSuccess;

    NSLog(@"NoteId for delete: %d", [note noteId]);
    /* validate we have a note id and log*/
    if (note.noteId == 0) {
        NSLog(@"Invalid noteId passed for delete");
        return deleteSuccess = NO;
    }

    sqlite3_stmt *sqlStatement = nil;
    const char *sql = "DELETE FROM notes WHERE noteId = ?";

    /* open database */
    NSString *dbPath = [bbarnard_NoteCollecton getDBPath];
    if(SQLITE_OK == sqlite3_open([dbPath UTF8String], &db)) {
        NSLog(@"db open ok");
    }

    /* prepare statement */
    NSLog(@"Preparing Delete Statement");
    if (sqlite3_prepare_v2(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating delete statement. '%s'", sqlite3_errmsg(db));
    }

    /* set sql statement variables */
    sqlite3_bind_int(sqlStatement, 1, note.noteId);

    NSLog(@"Delete Statement Prepared.");

    @try {
        if (SQLITE_DONE != sqlite3_step(sqlStatement)) {
            NSAssert1(0, @"Error while deleting data. '%s'", sqlite3_errmsg(db));
            deleteSuccess = NO;
        } else {
            deleteSuccess = YES;
            NSLog(@"Note Successfully Deleted. ID: %d", note.noteId);
        }
        //TODO: update object in collection array and refresh TableView
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error deleting note in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        return deleteSuccess;
    }
}

/**
 * delete an existing note in database
 * return Bool indicating success or fail
 * true success, false fail
 */
+(BOOL) deleteNotes
{
    
    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }
    
    /* return value defined */
    BOOL deleteSuccess;
    
    sqlite3_stmt *sqlStatement = nil;
    const char *sql = "DELETE FROM notes";
    
    /* open database */
    NSString *dbPath = [bbarnard_NoteCollecton getDBPath];
    if(SQLITE_OK == sqlite3_open([dbPath UTF8String], &db)) {
        NSLog(@"db open ok");
    }
    
    /* prepare statement */
    NSLog(@"Preparing Delete All Statement");
    if (sqlite3_prepare_v2(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK) {
        NSAssert1(0, @"Error while creating delete all statement. '%s'", sqlite3_errmsg(db));
    }
        
    NSLog(@"Delete All Statement Prepared.");
    
    @try {
        if (SQLITE_DONE != sqlite3_step(sqlStatement)) {
            NSAssert1(0, @"Error while deleting data. '%s'", sqlite3_errmsg(db));
            deleteSuccess = NO;
        } else {
            deleteSuccess = YES;
            NSLog(@"All Notes Successfully Deleted.");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Local Note Cache Cleared" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
            [alert show];

        }
    }
    @catch (NSException *exception) {
        NSLog(@"An exception occured: %@", [exception reason]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Error" message:@"Error deleting notes in SQLite Db" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        return deleteSuccess;
    }
}
@end

