//
//  bbarnard_NoteDetailViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NoteDetailViewController.h"

@interface bbarnard_NoteDetailViewController ()

@end

@implementation bbarnard_NoteDetailViewController

@synthesize noteContent;
@synthesize titleLabelOutlet;

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
    
    
    titleLabelOutlet.text = self.noteContent;
    
    
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
