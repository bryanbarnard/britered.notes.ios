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
@synthesize requestType;

static int httpResponseCode;

- (void)fetchNotes {

    self.responseData = [NSMutableData data];
    self.requestType = @"GETNOTES";
    
    NSURL *briteredNotes = [NSURL URLWithString:@"http://britrednotes.azurewebsites.net/api/notes?pageIndex=1&pageSize=10"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:briteredNotes];
    
    /* add custom header */
    [request addValue:@"0ca532cc-1918-475e-ae30-a4a3ac25625c" forHTTPHeaderField:@"AuthorId"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)addNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Add Note Called");
    
    self.responseData = [NSMutableData data];
    self.requestType = @"ADDNOTE";
    
    NSString *unencodedRequestString = [NSString stringWithFormat: @"Title=%@&Content=%@", [noteObject title], [noteObject content]];

    //NSString *requestString = encodedString; //TESTING
    NSString *requestString = unencodedRequestString;
    NSURL *briteredNotes = [NSURL URLWithString:@"http://britrednotes.azurewebsites.net/api/notes"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:briteredNotes];
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length ]];
    
    /* customize request */
    [request addValue:@"0ca532cc-1918-475e-ae30-a4a3ac25625c" forHTTPHeaderField:@"AuthorId"];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData ];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}


- (void)deleteNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Delete Note Called");
    
    self.responseData = [NSMutableData data];
    self.requestType = @"DELETENOTE";

    NSLog(@"Attempting to delete note with altId:%@", [noteObject altId]);
    NSString *urlBase = @"http://britrednotes.azurewebsites.net/api/notes";
    NSString *urlParams = [NSString stringWithFormat: @"?sysId=%@", [noteObject altId]];
    NSString *fullUrl = [NSString stringWithFormat:@"%@%@", urlBase, urlParams];
    
    NSURL *briteredNotes = [NSURL URLWithString: fullUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:briteredNotes];
    
    
    /* customize the request */
    [request addValue:@"0ca532cc-1918-475e-ae30-a4a3ac25625c" forHTTPHeaderField:@"AuthorId"];
    [request setHTTPMethod:@"DELETE"];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)updateNoteRemoteCollection:(bbarnard_NoteData *)noteObject {
    
    NSLog(@"NoteService Update Note Called");
    
    self.responseData = [NSMutableData data];
    self.requestType = @"UPDATENOTE";

    NSString *unencodedRequestString = [NSString stringWithFormat: @"Title=%@&Content=%@&SysId=%@", [noteObject title], [noteObject content], [noteObject altId]];
    NSString *requestString = unencodedRequestString;
    NSURL *briteredNotes = [NSURL URLWithString:@"http://britrednotes.azurewebsites.net/api/notes"];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:briteredNotes];
    NSData *requestData = [NSData dataWithBytes: [requestString UTF8String] length: [requestString length ]];

    /* customize request */
    [request addValue:@"0ca532cc-1918-475e-ae30-a4a3ac25625c" forHTTPHeaderField:@"AuthorId"];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody: requestData ];

    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //NSLog(@"didReceiveResponse");
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    httpResponseCode = [httpResponse statusCode];

    NSLog(@"HTTP Response Status Code: %d", httpResponseCode);
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", [NSString stringWithFormat:@"Connection failed: %@", [error description]]);

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Error" message:@"Unable to connect to web service." delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
    [alert show];
}

/* if success process results */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSInteger noteCount = 0;
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [responseData length]);
    NSString *t = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];

    //nothing to do with results if this is a delete, just expect 204 response
    if  ([self.requestType isEqualToString:@"DELETENOTE"]) {
        assert(httpResponseCode == 204);
        return;
    }


    // serialize
    NSError *myError = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&myError];

    if (!jsonArray) {
        NSLog(@"jsonCheck: %@", t);
        NSLog(@"error parsing json response");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Error" message:@"Error retreiving notes from web service" delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        
        /* maybe this should be a switch ... ? :), next refactor. short on time now... */
        if ([self.requestType isEqualToString:@"GETNOTES"]) {
        
            assert(httpResponseCode == 200);
            
            
            for(NSDictionary *item in jsonArray) {
                //NSLog(@"Title: %@ ", [item objectForKey:@"Title"]);
                //NSLog(@"Content: %@ ", [item objectForKey:@"Content"]);
                //NSLog(@"SysId: %@", [item objectForKey:@"SysId"]);
                //NSLog(@"AuthorID: %@", [item objectForKey:@"AuthorId"]);
                
                [self createAndAddLocalNote:item];
                noteCount++;
            }
            
            NSString *result = [NSString stringWithFormat:@" %d notes retreived from web service", noteCount];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Complete" message:result delegate:self cancelButtonTitle:@"Return" otherButtonTitles:nil, nil];
            [alert show];
        }
        
        if ([self.requestType isEqualToString:@"ADDNOTE"]) {
            assert(httpResponseCode == 201);
        }

        if ([self.requestType isEqualToString:@"UPDATENOTE"]) {
            assert(httpResponseCode == 200);
        }
    }
}


- (void)createAndAddLocalNote:(NSDictionary *)noteDTO {
    bbarnard_NoteData *noteObj = [[bbarnard_NoteData alloc] init];
    [noteObj setTitle: [noteDTO objectForKey:@"Title"]];
    [noteObj setContent: [noteDTO objectForKey:@"Content"]];
    [noteObj setAltId: [noteDTO objectForKey:@"SysId"]];
    [noteObj setAuthor: [noteDTO objectForKey:@"AuthorId"]];
    
    //NSLog(@"Note Object Created from noteDTO title: %@", [noteObj title]);
    
    bbarnardAppDelegate *appDelegate = (bbarnardAppDelegate *)[[UIApplication sharedApplication] delegate];

    //add to app collection
    [appDelegate.noteArray addObject:noteObj];
    
    //add to database
    [bbarnard_NoteCollecton createNote:noteObj];
}

@end		
