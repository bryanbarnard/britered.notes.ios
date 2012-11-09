//
//  bbarnard_NoteDetailViewController.h
//  bbarnard_csc471_FinalProject
//
//  Created by Bryan Barnard on 10/31/12.
//  Copyright (c) 2012 Bryan Barnard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bbarnard_NoteDetailViewController : UIViewController

@property (weak, nonatomic) NSString *noteContent;
@property (weak, nonatomic) IBOutlet UITextField *titleLabelOutlet;


@end
