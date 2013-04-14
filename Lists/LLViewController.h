//
//  LLViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "LLReorderingTableViewController.h"
#import "LLTableViewKeyboardDismisser.h"
#import "List.h"
#import "ListItem.h"
#import "LLTableViewCell.h"
#import "LLTableView.h"

#define TABLE_BOTTOM_INSET 21
#define DEFAULT_TABLE_INSETS UIEdgeInsetsMake(0.0, 0.0, TABLE_BOTTOM_INSET, 0.0);

@interface LLViewController : LLReorderingTableViewController <UIScrollViewDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate>
{
    BOOL _userDrivenDataModelChange;
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;

    // these values are used in reestablishing cursor location in the textview after a table refresh (after an edit causes a table refresh)
    NSRange _last_range;
    bool _was_delete;

    UITextView *_activeTextView;

    NSIndexPath *_fromIndex;
}

typedef enum{
    ListTypeConfig
} ConfigurationSection;
typedef enum{
    SimpleList,
    ToDoList,
    OutlineList
} ListType;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)init;

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)refreshData:(NSNotification *)notif;
- (void)saveContext;
- (NSIndexPath*)indexPathForTextView:(UITextView*)textView;
+ (bool)deviceHasRetinaDisplay;

// abstract, children must implement (unenforced)
- (NSString*)sortKey;
- (NSString*)entityName;
- (NSString*)textForIndexPath:(NSIndexPath*)indexPath;
- (void)setText:(NSString*)text forIndexPath:(NSIndexPath*)indexPath;
- (NSInteger)widthOfTextViewAtIndexPath:(NSIndexPath*)indexPath;

@end
