//
//  bbarnard_NewNoteViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/8/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NewNoteViewController.h"
#import "bbarnard_NoteData.h"
#import "bbarnard_NoteCollecton.h"

@interface bbarnard_NewNoteViewController ()

@end

@implementation bbarnard_NewNoteViewController

@synthesize titleOutlet, contentOutlet, saveBtnOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    /* setup our default settings */
    [titleOutlet setText:@""];
    [contentOutlet setText:@""];
}

- (void)viewDidUnload {
    [self setTitleOutlet:nil];
    [self setContentOutlet:nil];
    [self setSaveBtnOutlet:nil];
    [super viewDidUnload];
}
- (IBAction)submitBtnClicked:(UIButton *)sender {

    if( titleOutlet.text == @"" || contentOutlet.text == @"") {
        //alert empty notes not allowed
        return;
    }
    
    
    /* init new note */
    bbarnard_NoteData *newNote = [[bbarnard_NoteData alloc] init];
    
    /* must get these values from the gui */
    [newNote setTitle: titleOutlet.text];
    [newNote setContent: contentOutlet.text];
    
    /* push to db */
    if ([bbarnard_NoteCollecton createNote:newNote]) {
        //alert note created;
    } else {
        //alert error
    }
    
    /* on successful save we want to return to the tableView */
}
@end
