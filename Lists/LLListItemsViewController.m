//
//  LLMainViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/18/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListItemsViewController.h"

#define STACK_CTRL_HEIGHT 47

@interface LLListItemsViewController ()

typedef enum {
	AutoscrollStatusCellInBetween,
	AutoscrollStatusCellAtTop,
	AutoscrollStatusCellAtBottom
} AutoscrollStatus;

@end

@implementation LLListItemsViewController

@synthesize pullToInsertItemView = _pullToInsertItemView;
@synthesize currentList = m_currentList;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGRect frame = self.view.frame;
    
//    LLTabStackControl *tabStackControl = [[LLTabStackControl alloc]
//                                          initWithFrame:CGRectMake(0.0, 0.0, frame.size.width, STACK_CTRL_HEIGHT)
//                                               andDelegate:self];
//    [self.view addSubview:tabStackControl];

    
    _pullToInsertItemView = [[LLPullToInsertItemView alloc] initWithFrame: CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
																						 320.0f, self.view.bounds.size.height)];
	[self.tableView addSubview:self.pullToInsertItemView];
    
//    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(insertNewListItem)
                                                 name:@"LLTableViewHitOutsideCell"
                                               object:nil];
    
    
    // 0 is returned for no list
//    int listID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"];
    
    // Initialize the fetched results controllers with custom accessors
//    NSError *error;
//    if (![[self fetchedResultsController] performFetch:&error]) {
//        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        exit(-1);
//    }
//    
//    if (listID == 0) //first load
//    {
//        int currentList = 1;
//        
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//        NSEntityDescription *itemEntity = [[self.fetchedResultsController fetchRequest] entity];
//        ListItem *newItem= [NSEntityDescription insertNewObjectForEntityForName:[itemEntity name] inManagedObjectContext:context];
//        newItem.text = @"New Item";
//        newItem.itemID = [NSNumber numberWithInt: 0];
//        
////        m_currentList = newList;
//        
//        [[NSUserDefaults standardUserDefaults] setInteger:currentList forKey:@"currentListID"];
//        
//        NSError *error;
//        [self.managedObjectContext save:&error];
//    }
//    else{
//        // Load current List
//        m_currentList = [[self.fetchedResultsController fetchedObjects] objectAtIndex:listID - 1];
//    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *butImage = [[UIImage imageNamed:@"lists_icon.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [button setBackgroundImage:butImage forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoBack:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 48, 30);
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backButton;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

// Add a ListItem to the data store and to the tableview
-(void)insertNewListItem
{
    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"ListItem"
                         inManagedObjectContext:self.managedObjectContext];
    newItem.text= @"New Item";
    NSMutableArray* relationship = [[self.fetchedResultsController fetchedObjects] mutableCopy];
        
    int maxID = 0;
    for (ListItem* item in relationship)
        maxID = maxID > [item.itemID intValue] ? maxID : [item.itemID intValue];
        
    // if maxID is set to zero, we don't want to increment, it's the first item so ID should be 0.
    newItem.itemID = [NSNumber numberWithInt:maxID+1];
    
    [m_currentList addItemsObject:newItem];
    
    [self saveContext];
}
-(void)gotoBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	if ([self.pullToInsertItemView status] == kPullStatusLoading) return;
	checkForRefresh = YES;  //  only check offset when dragging
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if ([self.pullToInsertItemView status] == kPullStatusLoading) return;
	
	if (checkForRefresh) {
		if (scrollView.contentOffset.y > -kPullDownToReloadToggleHeight && scrollView.contentOffset.y < 0.0f) {
			[self.pullToInsertItemView setStatus:kPullStatusPullDownToReload animated:YES];
			
		} else if (scrollView.contentOffset.y < -kPullDownToReloadToggleHeight) {
			[self.pullToInsertItemView setStatus:kPullStatusReleaseToReload animated:YES];
		}
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([self.pullToInsertItemView status] == kPullStatusLoading) return;
	
	if ([self.pullToInsertItemView status]==kPullStatusReleaseToReload) {
//		[self.pullToInsertItemView startReloading:self.tableView animated:YES];
		[self pullDownToReloadAction];
	}
	checkForRefresh = NO;
}

#pragma mark actions

-(void) pullDownToReloadAction {
	NSLog(@"TODO: Overload this");
}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromIndex = sourceIndexPath.row;
    NSUInteger toIndex = destinationIndexPath.row;
    
    if (fromIndex == toIndex) return;
    
    NSUInteger count = [self.fetchedResultsController.fetchedObjects count];
    
    NSManagedObject *movingObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
    
    NSManagedObject *toObject  = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex];
    double toObjectDisplayOrder =  [[toObject valueForKey:@"itemID"] doubleValue];
    
    double newIndex;
    if ( fromIndex < toIndex ) {
        // moving up
        if (toIndex == count-1) {
            // toObject == last object
            newIndex = toObjectDisplayOrder + 1.0;
        } else  {
            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex+1];
            double objectDisplayOrder = [[object valueForKey:@"itemID"] doubleValue];
            
            newIndex = toObjectDisplayOrder + (objectDisplayOrder - toObjectDisplayOrder) / 2.0;
        }
        
    } else {
        // moving down
        
        if ( toIndex == 0) {
            // toObject == last object
            newIndex = toObjectDisplayOrder - 1.0;
            
        } else {
            
            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex-1];
            double objectDisplayOrder = [[object valueForKey:@"itemID"] doubleValue];
            
            newIndex = objectDisplayOrder + (toObjectDisplayOrder - objectDisplayOrder) / 2.0;
            
        }
    }
    
    [movingObject setValue:[NSNumber numberWithDouble:newIndex] forKey:@"itemID"];
    
    _userDrivenDataModelChange = YES;
    
    [self saveContext];
    
    _userDrivenDataModelChange = NO;
    
    // update with a short delay the moved cell
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(destinationIndexPath) afterDelay:0.2];
}


- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textField.text = [NSString stringWithFormat:@"%@", item.text];
    cell.textField.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];
 
    [cell resizeToFitTextExactly];
    
    [cell.textField addTarget:self action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    cell.textField.delegate = self;
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
    
    int listID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"];
    
    listID = listID == 0 ? 1 : listID; // if the list is zero, it is first load, will be 1 after init
    
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

#pragma mark -------
#pragma mark TableView Delegate Methods
// Display customization

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:.7
                                           green:.7
                                            blue:.7
                                           alpha:0.0];
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
#pragma mark -----------------
#pragma mark Textfield delegate
- (void)textFieldDidChange:(UITextField *)sender
{
    LLTableViewCell *field = (LLTableViewCell*)[sender superview];
    NSIndexPath *path = [self.tableView indexPathForCell:field];

    ListItem* item = [self.fetchedResultsController objectAtIndexPath:path];
    item.text = field.textField.text;
    
    [self saveContext];
    
    [sender setNeedsDisplay];
}
@end
