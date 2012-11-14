//
//  bbarnard_NotesService.m
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/13/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import "bbarnard_NotesService.h"
#import "bbarnard_NoteData.h"
#import "bbarnardAppDelegate.h"
#import "bbarnard_NoteCollecton.h"

@implementation bbarnard_NotesService
@synthesize responseData;


- (void)fetchNotes {

    self.responseData = [NSMutableData data];
    
    NSURL *briteredNotes = [NSURL URLWithString:@"http://britrednotes.azurewebsites.net/api/notes?pageIndex=1&pageSize=10"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:briteredNotes];
    
    /* add custom header */
    [request addValue:@"0ca532cc-1918-475e-ae30-a4a3ac25625c" forHTTPHeaderField:@"AuthorId"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int code = [httpResponse statusCode];
    NSLog(@"HTTP Response Status Code: %d", code);
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}

/* this is the meat */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSInteger noteCount = 0;
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [responseData length]);
    NSString *t = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"jsonCheck: %@", t);

    /* get ref to app delegate */
    
    // serialize
    NSError *myError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&myError];
    
    if (!jsonArray) {
        NSLog(@"error parsing json response");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Error" message:@"Error retreiving notes from web service" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        for(NSDictionary *item in jsonArray) {
                NSLog(@"Title: %@ ", [item objectForKey:@"Title"]);
                NSLog(@"Content: %@ ", [item objectForKey:@"Content"]);
                NSLog(@"SysId: %@", [item objectForKey:@"SysId"]);
                NSLog(@"AuthorID: %@", [item objectForKey:@"AuthorId"]);
            
            [self createAndAddLocalNote:item];
            
            
            
                noteCount++;
        }
        
        NSString *result = [NSString stringWithFormat:@" %d notes retreived from web service", noteCount];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Complete" message:result delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    }
}


- (void)createAndAddLocalNote:(NSDictionary *)noteDTO {
    bbarnard_NoteData *noteObj = [[bbarnard_NoteData alloc] init];
    [noteObj setTitle: [noteDTO objectForKey:@"Title"]];
    [noteObj setContent: [noteDTO objectForKey:@"Content"]];
    [noteObj setAltId: [noteDTO objectForKey:@"SysId"]];
    [noteObj setAuthor: [noteDTO objectForKey:@"AuthorId"]];
    
    NSLog(@"Note Object Created from noteDTO title: %@", [noteObj title]);
    
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];

    //add to app collection
    [appDelegate.noteArray addObject:noteObj];
    
    //add to database
    [bbarnard_NoteCollecton createNote:noteObj];
}

- (void)addNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Add Note Called");
}


- (void)deleteNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Delete Note Called");
}

- (void)updateNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Update Note Called");
}

@end		
