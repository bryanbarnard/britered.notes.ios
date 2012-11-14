//
//  bbarnard_SyncPageViewController.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/3/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_SyncPageViewController.h"
#import "bbarnardAppDelegate.h"

@interface bbarnard_SyncPageViewController ()
@end

@implementation bbarnard_SyncPageViewController

//@synthesize notesSrv;
@synthesize lastSyncOutlet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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

- (IBAction)syncBtnClicked:(UIButton *)sender {

    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate fetchNotesFromService];
    
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/YY HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    NSLog(@"%@",dateString);
    lastSyncOutlet.text = dateString;
    
}
- (void)viewDidUnload {
    [self setLastSyncOutlet:nil];
    [super viewDidUnload];
}
@end
