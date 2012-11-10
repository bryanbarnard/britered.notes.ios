//
//  bbarnard_NoteData.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bbarnard_NoteData : NSObject {
    NSString *content;
    NSString *title;
    NSString *created_on;
    NSString *updated_on;
    NSString *author;
    NSString *altId;
    NSInteger noteId;
    BOOL    isDirty;
}

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *created_on;
@property (nonatomic, copy) NSString *updated_on;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, assign) NSInteger noteId;
@property (nonatomic, copy) NSString *altId;
@property (nonatomic, readwrite) BOOL isDirty;
@end
