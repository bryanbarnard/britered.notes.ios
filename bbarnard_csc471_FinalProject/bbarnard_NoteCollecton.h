//
//  bbarnard_NoteCollecton.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface bbarnard_NoteCollecton : NSObject {
    sqlite3 *db;
}

-(NSMutableArray *)getNotes;




@end
