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

@property (weak, nonatomic) IBOutlet UITextField *titleOutlet;
@property (weak, nonatomic) IBOutlet UITextView *contentOutlet;
@property (weak, nonatomic) IBOutlet UIButton *saveBtnOutlet;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtnOutlet;




@property (weak, nonatomic) bbarnard_NoteData *noteData;


-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndNoteObject:(bbarnard_NoteData *)noteDataObject;

@end
