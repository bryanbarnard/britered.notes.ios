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

- (void)viewDidUnload
{

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//TODO
/* add a new note modal window */
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
    static NSString *CellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    NSUInteger row = [indexPath row];
    bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
    
    cell.textLabel.text = note.title;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /* get selected row */
    NSUInteger row = [indexPath row];
    
    /* get value at row and create object */
    bbarnard_NoteData *note = [appDelegate.noteArray objectAtIndex:row];
    
    //bbarnard_NoteData *noteData = [[bbarnard_NoteData alloc] init];
    //noteData.title = rowValue;

    [self.detailController setTitle: note.title];
    self.detailController.noteData = note;
    [self.navigationController pushViewController:self.detailController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
