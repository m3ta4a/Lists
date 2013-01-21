//
//  LLViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLReorderingTableViewController.h"
#import "LLTableViewKeyboardDismisser.h"
#import "List.h"
#import "ListItem.h"
#import "LLTableView.h"
#import "LLTableViewCell.h"

@interface LLViewController : LLReorderingTableViewController <UIScrollViewDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>
{
    BOOL _userDrivenDataModelChange;
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;
}

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)init;
- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)refreshData:(NSNotification *)notif;
- (void)saveContext;

@end
