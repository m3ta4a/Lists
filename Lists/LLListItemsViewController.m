//
//  LLMainViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/18/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListItemsViewController.h"

@interface LLListItemsViewController ()
{

}
@end

@implementation LLListItemsViewController

@synthesize currentList = m_currentList;
-(NSString*)sortKey
{
    return @"itemID";
}
- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    return self;
}
-(void)viewDidLoad
{
    self.tableView = [[LLTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.contentInset = DEFAULT_TABLE_INSETS;
    [self.view addSubview:self.tableView];

    [super viewDidLoad];

    NSString *addRowImgFile = @"AddRow.png";
    NSString *listsIconImgFile = @"lists_icon.png";

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *butImage = [[UIImage imageNamed:listsIconImgFile] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [button setBackgroundImage:butImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addImage = [[UIImage imageNamed:addRowImgFile] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [addButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(insertNewListItem) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addButtonItem;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSArray* relationship = [self.fetchedResultsController fetchedObjects];
    if ([relationship count] == 0)
    {
        [self insertNewListItem];
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(!editing) {
        int i = 0;
        NSArray *data =[self.fetchedResultsController fetchedObjects];
        for(ListItem *item in data) {
            item.itemID = [NSNumber numberWithInt:i++];
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
}

- (void) insertNewListItem
{
    [self insertNewListItemNamed:@""];
}
// Add a ListItem to the data store and to the tableview
-(void)insertNewListItemNamed:(NSString *)name
{
    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"ListItem"
                         inManagedObjectContext:self.managedObjectContext];
    newItem.text= name;
    NSArray* relationship = [self.fetchedResultsController fetchedObjects];
        
    int maxID = 0;
    for (ListItem* item in relationship)
        maxID = maxID > [item.itemID intValue] ? maxID : [item.itemID intValue];
        
    // if maxID is set to zero, we don't want to increment, it's the first item so ID should be 0.
    newItem.itemID = [NSNumber numberWithInt:maxID+1];
    
    [m_currentList addItemsObject:newItem];
    
    [self saveContext];

    // give the new tableview cell textfield firstresponder status
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    LLTableViewCell *cell = (LLTableViewCell*)[self.tableView cellForRowAtIndexPath:path];
    [cell.textView becomeFirstResponder];
}
-(void)gotoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark ---------
#pragma mark Reordering Table View delegate methods
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow
//{
//    _fromIndex = dragRow;
//}
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//    [self tableView:dragTableViewController.tableView moveRowAtIndexPath:_fromIndex toIndexPath:destinationIndexPath];
//}
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//
//}
//- (BOOL)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//    return YES;
//}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    [super configureCell:cell atIndexPath:indexPath];

    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textView.text = [NSString stringWithFormat:@"%@", item.text];
    cell.textView.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];
    cell.textView.font = TEXT_INPUT_FONT;
    cell.textView.textColor = [UIColor blackColor];
    [cell.textView setUserInteractionEnabled:YES];

    // don't use textView's frame for the width...
    // adjustTextInputHeightForText sets that frame.
    // view controller should dictate width of cells textview
    [cell adjustTextInputHeightForText:item.text andWidth:[self widthOfTextViewAtIndexPath:indexPath]];

    cell.textView.delegate = self;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTableViewCell *cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);
    
    NSString *identifier = @"ListItemCell";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

#pragma mark -------
#pragma mark TableView Delegate Methods
// used by parent class in heightForRowAtIndexPath:
- (void)setText:(NSString*)text forIndexPath:(NSIndexPath*)indexPath{
    ListItem *listitem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    listitem.text = text;
}
- (NSString*)textForIndexPath:(NSIndexPath*)indexPath{
    ListItem *listitem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return listitem.text;
}
- (NSInteger)widthOfTextViewAtIndexPath:(NSIndexPath*)indexPath{
    return self.tableView.frame.size.width;
}

#pragma mark ----------
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    int listID = [m_currentList.listID integerValue];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"list.listID = %d",listID];
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        return nil;
    }
    
    return _fetchedResultsController;
}

@end
