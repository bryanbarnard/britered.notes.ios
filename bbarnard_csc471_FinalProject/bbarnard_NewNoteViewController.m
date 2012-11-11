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
#import "bbarnardAppDelegate.h"

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
    [self setTitle:@"Add Note"];
    self.navigationItem.leftBarButtonItem  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClicked:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnClicked:)];
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

- (IBAction)cancelBtnClicked:(id)sender {
    //clear all fields and dismiss keyboard
    [titleOutlet resignFirstResponder];
    [contentOutlet resignFirstResponder];
    [titleOutlet setText:nil];
    [contentOutlet setText:nil];
    [self.navigationController dismissModalViewControllerAnimated:YES];
}

- (IBAction)saveBtnClicked:(id)sender {
    if ([titleOutlet.text isEqualToString:@""] || [contentOutlet.text isEqualToString:@""]) {
                 
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Note Title and Content must be populated to crate a new note" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }


    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    bbarnard_NoteData *newNote = [[bbarnard_NoteData alloc] init];
    
    [newNote setTitle: titleOutlet.text];
    [newNote setContent: contentOutlet.text];
    [appDelegate addNote:newNote];

    /*
    // push to db
    if ([bbarnard_NoteCollecton createNote:newNote]) {
        //alert note created;
    } else {
        //alert error
    }
      */





    // on successful save we want to return to the tableView
    [self.navigationController dismissModalViewControllerAnimated:YES];
}
@end
