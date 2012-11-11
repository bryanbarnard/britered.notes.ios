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
    NSAssert(noteObject != nil, @"Invalid Argument Passed to createNote, noteObject Nil.");
    bbarnard_NoteData *note = noteObject;
    
    NSTimeInterval nowEpoch = [[NSDate date] timeIntervalSince1970];
    NSString *nowEpochString = [NSString stringWithFormat:@"%f", nowEpoch];
    BOOL insertSuccess;

    /* set any note object values that are not yet set*/
    [note setCreated_on: nowEpochString];
    [note setUpdated_on: nowEpochString];
    [note setAuthor: @"1"];
    [note setAltId: @"1"];

    if(![bbarnard_NoteCollecton checkDbExists]) {
        return NO;
    }

        sqlite3_stmt *sqlStatement;
        const char *sql = "insert into Notes(created_on, updated_on, content, title, altId, author) Values(?, ?, ?, ?, ?, ?)";
        
        //open
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];

        if(SQLITE_OK == sqlite3_open([dbPath UTF8String], &db)) {
            NSLog(@"db open ok");
        }

        NSLog(@"Preparing Statement");
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
        
        NSLog(@"Statement Prepared.");

    @try {
        if (SQLITE_DONE != sqlite3_step(sqlStatement)) {
            NSAssert1(0, @"Error while inserting data. '%s'", sqlite3_errmsg(db));
            insertSuccess = NO;
        } else {
            [note setNoteId: sqlite3_last_insert_rowid(db)];
            insertSuccess = YES;
            NSLog(@"New Note Successfully Created. ID: %d", note.noteId);
        }
    

        //TODO: update object in array        
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

+(NSMutableString*) sqlite3StmtToString:(sqlite3_stmt*) statement
{
    NSMutableString *s = [NSMutableString new];
    [s appendString:@"{\"statement\":["];
    for (int c = 0; c < sqlite3_column_count(statement); c++){
        [s appendFormat:@"{\"column\":\"%@\",\"value\":\"%@\"}",[NSString stringWithUTF8String:(char*)sqlite3_column_name(statement, c)],[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, c)]];
        if (c < sqlite3_column_count(statement) - 1)
            [s appendString:@","];
    }
    [s appendString:@"]}"];
    return s;
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