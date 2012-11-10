//
//  bbarnard_NoteDetailViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteDetailViewController.h"
#import "bbarnard_NoteData.h"

@interface bbarnard_NoteDetailViewController ()

@end

@implementation bbarnard_NoteDetailViewController

@synthesize titleOutlet;
@synthesize contentOutlet;
@synthesize noteData;
@synthesize saveBtnOutlet;

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTitleOutlet:nil];
    [self setContentOutlet:nil];
    [self setSaveBtnOutlet:nil];
    [self setDeleteBtnOutlet:nil];
    [super viewDidUnload];
}

-(void)viewWillAppear:(BOOL)animated {

    [self setTitle: self.noteData.title];
    [self.titleOutlet setText: self.noteData.title];
    [self.contentOutlet setText: self.noteData.content];
    [self.saveBtnOutlet setEnabled:NO];
}

@end
