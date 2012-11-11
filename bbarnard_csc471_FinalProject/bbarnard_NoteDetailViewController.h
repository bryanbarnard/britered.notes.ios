//
//  bbarnard_NoteDetailViewController.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bbarnard_NoteData.h"

@interface bbarnard_NoteDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *titleOutlet;
@property (strong, nonatomic) IBOutlet UITextView *contentOutlet;
@property (strong, nonatomic) bbarnard_NoteData *noteData;



@end
