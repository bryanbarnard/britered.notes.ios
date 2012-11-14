//
//  bbarnard_NoteDetailViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteDetailViewController.h"
#import "bbarnardAppDelegate.h"

@interface bbarnard_NoteDetailViewController ()

@end

@implementation bbarnard_NoteDetailViewController

@synthesize titleOutlet;
@synthesize contentOutlet;
@synthesize noteData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil AndNoteObject:(bbarnard_NoteData *)noteDataObject
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.noteData = noteDataObject;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveBtnClicked:)];
}

- (IBAction)saveBtnClicked:(id)sender {
    //validate input from gui
    if ([titleOutlet.text isEqualToString:@""] || [contentOutlet.text isEqualToString:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Note Title and Content must be populated to update a note" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    [titleOutlet resignFirstResponder];
    [contentOutlet resignFirstResponder];

    NSLog(@"SaveUpdates Clicked %@", self.noteData.title);

    //update note
    [self.noteData setTitle: titleOutlet.text];
    [self.noteData setContent: contentOutlet.text];
    [self.noteData setIsDirty:YES];

    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate updateNote:self.noteData];
}

- (IBAction)backgroundTap:(id)sender {
    [titleOutlet resignFirstResponder];
    [contentOutlet resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTitleOutlet:nil];
    [self setContentOutlet:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {
    [self setTitle: self.noteData.title];
    [self.titleOutlet setText: self.noteData.title];
    [self.contentOutlet setText: self.noteData.content];
}

@end
