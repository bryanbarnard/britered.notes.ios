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
    NSInteger noteId;
}

@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *title;
@property (retain, nonatomic) NSString *created_on;
@property (retain, nonatomic) NSString *updated_on;
@property (retain, nonatomic) NSString *author;
@property (nonatomic, assign) NSInteger noteId;

@end
