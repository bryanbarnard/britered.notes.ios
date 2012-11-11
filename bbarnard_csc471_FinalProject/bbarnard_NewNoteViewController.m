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

@synthesize titleOutlet, contentOutlet;

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
    [super viewDidUnload];
}

- (IBAction)cancelBtnClicked:(UIBarButtonItem *)sender {
    //clear all fields and dismiss keyboard
    //dismiss keyboard
    
}

- (IBAction)submitBtnClicked:(UIBarButtonItem *)sender {
    if( titleOutlet.text == @"" || contentOutlet.text == @"") {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Note Title and Content must be populated to crate a new note" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    bbarnard_NoteData *newNote = [[bbarnard_NoteData alloc] init];
    
    [newNote setTitle: titleOutlet.text];
    [newNote setContent: contentOutlet.text];
    
    // push to db
    if ([bbarnard_NoteCollecton createNote:newNote]) {
        //alert note created;
    } else {
        //alert error
    }
    
    // on successful save we want to return to the tableView
}
@end
