//
//  bbarnard_NoteData.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface bbarnard_NoteData : NSObject
@property (weak, nonatomic) NSString *content;
@property (weak, nonatomic) NSString *title;
@property (weak, nonatomic) NSString *created_on;
@property (weak, nonatomic) NSString *updated_on;
@property (weak, nonatomic) NSString *authorId;

@end
