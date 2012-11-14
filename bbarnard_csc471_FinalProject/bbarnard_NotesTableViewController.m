//
//  bbarnard_NotesTableViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/4/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//



#import "bbarnard_NotesTableViewController.h"

@class bbarnard_NoteData, bbarnard_NewNoteViewController;

@interface bbarnard_NotesTableViewController ()

@end

@implementation bbarnard_NotesTableViewController
@synthesize detailController;
@synthesize noteController;
@synthesize addNavigationController;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBtnClicked:)];
    self.detailController = [[bbarnard_NoteDetailViewController alloc] initWithNibName:@"bbarnard_NoteDetailViewController" bundle:nil];

    appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title = @"Note List";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidUnload {
       detailController = nil;
       noteController = nil;
       addNavigationController = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)addBtnClicked:(id)sender {
    NSLog(@"Add Note Button Clicked.");

    if(noteController == nil) {
        noteController = [[bbarnard_NewNoteViewController alloc] initWithNibName:@"bbarnard_NewNoteViewController" bundle:nil];
    }

    if(addNavigationController == nil) {
        addNavigationController = [[UINavigationController alloc] initWithRootViewController:noteController];
    }

    [self.navigationController presentModalViewController:addNavigationController animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"NotesArray Count %d", [appDelegate.noteArray count]);
    return [appDelegate.noteArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = [UIColor redColor];
    [tableView setBackgroundView:bview];

    [tableView setSeparatorColor:[UIColor grayColor]];

    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }

    NSUInteger row = [indexPath row];
    bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
    
    cell.textLabel.text = note.title;
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    if (note.content.length < 20) {
        cell.detailTextLabel.text = note.content;
    } else {
        NSString *subContent = [note.content substringToIndex:17];
        NSString *etcFill = @"...";
        NSString *contentTemp = [subContent stringByAppendingString:etcFill];
        cell.detailTextLabel.text = contentTemp;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        /* remove selected row from array and db */
        NSUInteger row = [indexPath row];
        bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
        [appDelegate removeNote:note];

        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* get selected row */
    NSUInteger row = [indexPath row];
    
    /* get value at row and create object */
    bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
    [note setAltId:[NSString stringWithFormat:@"%d", row]];
    [self.detailController setTitle: note.title];
    self.detailController.noteData = note;
    [self.navigationController pushViewController:self.detailController animated:YES];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    /* get selected row */
    NSUInteger row = [indexPath row];

    /* get value at row and create object */
    bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
    [note setAltId:[NSString stringWithFormat:@"%d", row]];
    [self.detailController setTitle: note.title];
    self.detailController.noteData = note;
    [self.navigationController pushViewController:self.detailController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
