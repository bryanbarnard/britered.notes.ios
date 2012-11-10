//
//  bbarnard_NoteCollecton.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "bbarnard_NoteData.h"

@interface bbarnard_NoteCollecton : NSObject

-(NSMutableArray *)getNotes;
-(BOOL)createNote:(bbarnard_NoteData *)noteDataObject;
-(BOOL)updateNote:(bbarnard_NoteData *)noteDataObject;
-(BOOL)deleteNote:(bbarnard_NoteData *)noteDataObject;
@end
