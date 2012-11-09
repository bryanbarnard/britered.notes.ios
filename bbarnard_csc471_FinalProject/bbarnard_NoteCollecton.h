//
//  bbarnard_NoteCollecton.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "bbarnard_NoteData.h"

@interface bbarnard_NoteCollecton : NSObject

@property (weak, nonatomic) NSMutableArray *notes;
@property (weak, nonatomic) NSString *lastUpdated;

@end
