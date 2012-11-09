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

@synthesize titleLabelOutlet;
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
    
    
    titleLabelOutlet.text = self.noteData.title;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setTitleLabelOutlet:nil];
    [super viewDidUnload];
}
@end
