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


#define BORDER_WIDTH 0

@interface LLViewController : LLReorderingTableViewController <UIScrollViewDelegate, UITextViewDelegate, NSFetchedResultsControllerDelegate>
{
    BOOL _userDrivenDataModelChange;
    NSManagedObjectContext *_managedObjectContext;
    NSFetchedResultsController *_fetchedResultsController;
    NSRange _last_range;
    //    LLTableView *_tableView;
}

typedef enum{
    ListTypeConfig
} ConfigurationSection;
typedef enum{
    SimpleList,
    ToDoList,
    OutlineList
} ListType;

//@property (nonatomic, strong) LLTableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (id)init;
- (NSString*)sortKey;
- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)refreshData:(NSNotification *)notif;
- (void)saveContext;

+ (bool)deviceHasRetinaDisplay;

@end
