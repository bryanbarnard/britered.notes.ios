//
//  bbarnard_SettingsPageViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/3/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_SettingsPageViewController.h"
#import "bbarnardAppDelegate.h"

@interface bbarnard_SettingsPageViewController ()

@end

@implementation bbarnard_SettingsPageViewController
@synthesize syncNoteAddOutlet, syncNoteDeleteOutlet, syncNoteOverwriteLocalOutlet, urlTextFieldOutlet, syncNoteUpdateOutlet;

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
    [syncNoteAddOutlet setOn:YES];
    [syncNoteDeleteOutlet setOn:YES];
    [syncNoteUpdateOutlet setOn:YES];
    [syncNoteOverwriteLocalOutlet setOn:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switched_SyncNoteAdd:(UISwitch *)sender {
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setSyncAdd:sender.on];
}

- (IBAction)switched_SyncNoteDelete:(UISwitch *)sender {
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setSyncDelete:sender.on];

}

- (IBAction)switched_SyncNoteOverwriteLocal:(UISwitch *)sender {
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setSyncNoteOverwriteLocal:sender.on];

}

- (IBAction)switched_SyncNoteUpdate:(UISwitch *)sender {
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate setSyncUpdate:sender.on];
}


- (IBAction)textFieldDoneEditing:(id)sender {
    [sender resignFirstResponder];
}

- (IBAction)backgroundTap:(id)sender {
    [urlTextFieldOutlet resignFirstResponder];
}

- (void)viewDidUnload {
    [self setSyncNoteAddOutlet:nil];
    [self setSyncNoteDeleteOutlet:nil];
    [self setSyncNoteOverwriteLocalOutlet:nil];
    [self setUrlTextFieldOutlet:nil];
    [self setSyncNoteUpdateOutlet:nil];
    [super viewDidUnload];
}
@end
