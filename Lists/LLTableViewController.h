//
//  LLViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewKeyboardDismisser.h"
#import "LLTableViewCell.h"
#import "LLTabStackControl.h"
#import "LLHeaderTag.h"
#import "List.h"
#import "ListItem.h"

@interface LLTableViewController : UITableViewController <UITableViewDelegate, NSFetchedResultsControllerDelegate, UITextFieldDelegate>
{
    List *m_currentList;
}

@property (nonatomic, strong) LLTabStackControl *header;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *listFetchedResultsController;
@property (nonatomic, retain) NSFetchedResultsController *itemFetchedResultsController;


@end



