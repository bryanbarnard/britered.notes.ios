//
//  bbarnard_NotesService.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/13/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class bbarnard_NoteData;
@interface bbarnard_NotesService : NSObject {
    NSURLConnection *connection;
}

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSString *requestType;

- (void)fetchNotes;
- (void)addNoteRemoteCollection:(bbarnard_NoteData *)noteObject;
- (void)deleteNoteRemoteCollection:(bbarnard_NoteData *)noteObject;
- (void)updateNoteRemoteCollection:(bbarnard_NoteData *)noteObject;
@end
