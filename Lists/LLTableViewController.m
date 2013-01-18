    //
//  LLViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewController.h"

@interface LLTableViewController ()


@end

@implementation LLTableViewController

@synthesize header = _header;
@synthesize listFetchedResultsController = _listFetchedResultsController;
@synthesize itemFetchedResultsController = _itemFetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:NSManagedObjectContextDidSaveNotification     
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(addRow:)
                                                 name:@"LLTableViewHitOutsideCell"
                                               object:nil];

    
    // 0 is returned for no list
    int listID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"];
    
    // Initialize the fetched results controllers with custom accessors
    NSError *error;
    if (![[self listFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    if (![[self itemFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }

    if (listID == 0) //first load
    {
        int currentList = 1;
        
        NSManagedObjectContext *context = [_itemFetchedResultsController managedObjectContext];
        NSEntityDescription *itemEntity = [[_itemFetchedResultsController fetchRequest] entity];
        ListItem *newItem= [NSEntityDescription insertNewObjectForEntityForName:[itemEntity name] inManagedObjectContext:context];
        newItem.text = @"New Item";
        newItem.itemID = [NSNumber numberWithInt: 0];
        
        NSEntityDescription *listEntity = [[_listFetchedResultsController fetchRequest] entity];
        List *newList = [NSEntityDescription insertNewObjectForEntityForName:[listEntity name] inManagedObjectContext:context];
        newList.listID = [NSNumber numberWithInt:currentList];
        newList.text = @"New List";
        [newList addItemsObject:newItem];
        
        m_currentList = newList;
        
        [[NSUserDefaults standardUserDefaults] setInteger:currentList forKey:@"currentListID"];
        
        NSError *error;
        [_managedObjectContext save:&error];

        [super viewDidLoad];

        return;
    }
    else{
        // Load current List
        m_currentList = [[_listFetchedResultsController fetchedObjects] objectAtIndex:listID - 1];
    }
    
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {    
    self.navigationItem.leftBarButtonItem = [self editButtonItem];
}
- (void)viewDidUnload {
    self.listFetchedResultsController = nil;
    self.itemFetchedResultsController = nil;
    
    [[NSUserDefaults standardUserDefaults] setInteger:[m_currentList.listID integerValue] forKey:@"currentListID"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(!editing) {
        int i = 0;
        NSArray *data =[_itemFetchedResultsController fetchedObjects];
        for(ListItem *item in data) {
            item.itemID = [NSNumber numberWithInt:i++];
        }
        NSError *error = nil;
        [_managedObjectContext save:&error];
    }
}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    //NSString *name = [[[_itemFetchedResultsController sections] objectAtIndex:section] name];
    return @"";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    NSUInteger count = [[_itemFetchedResultsController sections] count];
    return count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfObjects = [[[_itemFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return numberOfObjects;//+1
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects])
        return true;
    return false;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row <= [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects])
        return true;
    return false;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        ListItem *oldItem = [_itemFetchedResultsController objectAtIndexPath:indexPath];
        
        [_managedObjectContext deleteObject:oldItem];

        NSError *error = nil;
        [_managedObjectContext save:&error]; // this causes the fetchedResultsController to update the tableView
    }
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
// Don't update ItemID here because editing might not be complete. 
    NSMutableArray *data = [[_itemFetchedResultsController fetchedObjects] mutableCopy];
    ListItem * item = [data objectAtIndex:sourceIndexPath.row];
    [data removeObjectAtIndex:sourceIndexPath.row];
    [data insertObject:item atIndex:destinationIndexPath.row];
}


- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ListItem *item = [_itemFetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textField.text = [NSString stringWithFormat:@"%@, %@", item.text, item.itemID];
    cell.textField.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithTableView:self.tableView];
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused(tv)
#pragma unused(indexPath)
    LLTableViewCell *cell;

    assert(tv == self.tableView);
    assert(indexPath != nil);

    NSString *identifier = @"Cell";

    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);

    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (!self.header)
        self.header = [[LLTableViewHeaderControl alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 46.0)
                                                          andDelegate:self];

    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 46.0;
}


-(IBAction)addRow:(id)sender
{
    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"ListItem"
                         inManagedObjectContext:_managedObjectContext];
    newItem.text= @"New Item";

    [m_currentList addItemsObject:newItem];

    NSError *error = nil;
    [_managedObjectContext save:&error]; // this causes the fetchedResultsController to update the tableView
}
#pragma mark -----------------
#pragma mark Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidChange:(UITextField *)sender {
    CGFloat width;
    LLHeaderTag *field = (LLHeaderTag*)sender;
    width = [field getWidth];
    field.frame = CGRectMake((field.frame.size.width - width) / 2 - 5,
                              0, width + 2 * 5, 44);
    
    NSError *error;
    [_managedObjectContext save:&error];
    
    [sender setNeedsDisplay];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath* path = [self.tableView indexPathForCell:(LLTableViewCell*) [[textField superview] superview] ];
    ListItem* item = (ListItem*)[_itemFetchedResultsController objectAtIndexPath:path];
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    item.text = newStr;
    
    return true;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSIndexPath* path = [self.tableView indexPathForCell:(LLTableViewCell*) [[textField superview] superview] ];
    ListItem* item = (ListItem*)[_itemFetchedResultsController objectAtIndexPath:path];
    
    item.text = @"";
    
    return true;

}
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIInterfaceOrientation orientation = toInterfaceOrientation;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    
    if (UIDeviceOrientationIsPortrait(orientation))
    {
        screenWidth = screenRect.size.width;
    }
    else if (UIDeviceOrientationIsLandscape(orientation))
    {
        screenWidth = screenRect.size.height;
    }
    
    [self.header deviceOrientationDidChange:screenWidth];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {

    NSEntityDescription *entity = [[controller fetchRequest] entity];
    
    if ([entity.name isEqualToString:@"List" ])
    {
        return;
    }

    UITableView *tableView = self.tableView;
    LLTableViewCell *cell;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            cell = (LLTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"Changed section");
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationMiddle];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

- (NSFetchedResultsController *)listFetchedResultsController {

    if (_listFetchedResultsController != nil) {
        return _listFetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"listID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil
                                                                                                             cacheName:nil];//@"ListResults"];
    self.listFetchedResultsController = theFetchedResultsController;
    _listFetchedResultsController.delegate = self;

    return _listFetchedResultsController;
}
- (NSFetchedResultsController *)itemFetchedResultsController {

    if (_itemFetchedResultsController != nil) {
        return _itemFetchedResultsController;
    }

    int listID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"];
    
    listID = listID == 0 ? 1 : listID; // if the list is zero, it is first load, will be 1 after init
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ListItem" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSPredicate* pred = [NSPredicate predicateWithFormat:@"list.listID = %d",listID];
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"itemID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:[self managedObjectContext] sectionNameKeyPath:nil
                                                                                                             cacheName:nil];
    self.itemFetchedResultsController = theFetchedResultsController;
    _itemFetchedResultsController.delegate = self;

    return _itemFetchedResultsController;
}
-(void)updateItemFetchedResultsPredicate
{
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"list.listID = %d", [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"]];//][currentListID integerValue]];
    [_itemFetchedResultsController.fetchRequest setPredicate:pred];
    NSError *error = nil;
    if (![[self itemFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
//    [self.tableView reloadData];
}
- (void) refreshData:(NSNotification *)notif {    
    [[[self itemFetchedResultsController] managedObjectContext] mergeChangesFromContextDidSaveNotification:notif];
    [[[self listFetchedResultsController] managedObjectContext] mergeChangesFromContextDidSaveNotification:notif];
}


#pragma mark -------
#pragma mark TableView Delegate Methods
// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects])
        cell.backgroundColor = [UIColor colorWithRed:0.0
                                               green:0.0
                                                blue:0.0
                                               alpha:0.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:1.0
                                               green:1.0
                                                blue:1.0
                                               alpha:1.0];
    
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

@end
