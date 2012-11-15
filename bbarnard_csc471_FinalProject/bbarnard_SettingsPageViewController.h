//
//  bbarnard_SettingsPageViewController.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/3/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bbarnard_SettingsPageViewController : UIViewController
- (IBAction)switched_SyncNoteAdd:(UISwitch *)sender;
- (IBAction)switched_SyncNoteDelete:(UISwitch *)sender;
- (IBAction)switched_SyncNoteOverwriteLocal:(UISwitch *)sender;
- (IBAction)switched_SyncNoteUpdate:(UISwitch *)sender;
- (IBAction)textFieldDoneEditing:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *syncNoteAddOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *syncNoteDeleteOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *syncNoteOverwriteLocalOutlet;
@property (weak, nonatomic) IBOutlet UISwitch *syncNoteUpdateOutlet;
@property (weak, nonatomic) IBOutlet UITextField *urlTextFieldOutlet;




@end
