//
//  bbarnard_NotesService.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/13/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bbarnard_NotesService : NSObject {
    NSURLConnection *connection;
}

@property (nonatomic, strong) NSMutableData *responseData;

- (void)fetchNotes;

@end
