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

    NSIndexPath *_fromIndex;
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
//    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    [super viewDidLoad];

//    _pullToInsertItemView = [[LLPullToInsertItemView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
//                                                                                      320.0f, self.view.bounds.size.height)];
//	[self.tableView addSubview:self.pullToInsertItemView];



//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(insertNewListItem)
//                                                 name:@"LLTableViewHitOutsideCell"
//                                               object:nil];


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

    [self.tableView reloadData];

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

#pragma mark ------------------
#pragma mark UITableView Data Source Methods
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow
{
    _fromIndex = dragRow;
}
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath
{
    [self tableView:dragTableViewController.tableView moveRowAtIndexPath:_fromIndex toIndexPath:destinationIndexPath];
}
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath
{

}
- (BOOL)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(LLReorderingTableViewController *)dragTableViewController
{
    LLTableViewCell *cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textView.text = [NSString stringWithFormat:@"%@", item.text];

    return cell;
}

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    [super configureCell:cell atIndexPath:indexPath];

    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textView.text = [NSString stringWithFormat:@"%@", item.text];
 
    [cell adjustTextInputHeightForText:item.text];
    
    cell.textView.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];
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

// Accessories (disclosures).
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    
}

// Selection

// -tableView:shouldHighlightRowAtIndexPath: is called when a touch comes down on a row.
// Returning NO to that message halts the selection process and does not cause the currently selected row to lose its selected look while the touch is down.
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// Called before the user changes the selection. Return a new indexPath, or nil, to change the proposed selection.
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath;
}
// Called after the user changes the selection.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

// Editing

// Allows customization of the editingStyle for a particular cell located at 'indexPath'. If not implemented, all editable cells will have UITableViewCellEditingStyleDelete set for them when the table has editing property set to YES.
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

// The willBegin/didEnd methods are called whenever the 'editing' property is automatically changed by the table (allowing insert/delete/move). This is done by a swipe activating a single row
- (void)tableView:(UITableView*)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

// Indentation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{ // return 'depth' of row for hierarchies
    return 0;
}

// Copy/Paste.  All three methods must be implemented by the delegate.

- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}
#pragma mark -------
#pragma mark TableView Delegate Methods
// Display customization
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    int width = tableView.frame.size.width*5/6;
    ListItem *listitem = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *text = listitem.text;
    CGSize stringSize = [LLTableViewCell textViewSize:text forWidth:width];
    return MAX(44,stringSize.height+12);
}

@end
