//
//  bbarnard_SyncPageViewController.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 11/3/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bbarnard_NotesService.h"

@interface bbarnard_SyncPageViewController : UIViewController
//@property (strong, nonatomic) bbarnard_NotesService *notesSrv;
- (IBAction)syncBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *lastSyncOutlet;

@end
