//
//  bbarnard_NoteCollecton.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteCollecton.h"
#import "bbarnard_NoteData.h"


@implementation bbarnard_NoteCollecton

/**
 * get notes from SQLLITE DB
 */
-(NSMutableArray *) getNotes {
    //get notes from database    
    NSMutableArray *noteArray = [[NSMutableArray alloc] init];
    
    @try
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"bbarnard_notesdb.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        
        if(!success)
            {
            NSLog(@"Cannot locate database file '%@', ", dbPath);
            }
        
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
            {
            NSLog(@"An error has occured.");
            }
        
        const char *sql = "SELECT noteId, title, content FROM notes";
        sqlite3_stmt *sqlStatement;
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
            {
            NSLog(@"Problem with prepare statement");
            }
        
        while (sqlite3_step(sqlStatement) == SQLITE_ROW) {
            bbarnard_NoteData *MyNote = [[bbarnard_NoteData alloc]init];
            
            MyNote.noteId = sqlite3_column_int(sqlStatement, 0);
            
            MyNote.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
            
            MyNote.content = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 2)];
            
            [noteArray addObject:MyNote];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"An exception occured: %@", [exception reason]);
    }
    @finally
    {
        return noteArray;
    }
}
@end