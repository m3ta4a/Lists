//
//  LLViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewKeyboardDismisser.h"
#import "LLTableViewCell.h"
#import "LLTableViewHeaderControl.h"
#import "List.h"
#import "ListItem.h"
#import "Settings.h"

@interface LLViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) LLTableViewHeaderControl *header;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *listFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *itemFetchedResultsController;

-(IBAction)dismissKeyboard;
-(IBAction)addRow:(id)sender;

@end

