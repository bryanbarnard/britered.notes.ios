//
//  bbarnard_NotesTableViewController.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/4/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bbarnard_NoteDetailViewController.h"
#import "bbarnard_NoteCollecton.h"

@interface bbarnard_NotesTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *notesArray;
@property (nonatomic, retain) bbarnard_NoteDetailViewController *detailController;

@end
