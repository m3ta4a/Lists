//
//  LLListsViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListsViewController.h"

@interface LLListsViewController ()
{
 
}

@end

@implementation LLListsViewController

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Lists";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// Add a ListItem to the data store and to the tableview
-(void)insertNewList
{
    List *newList = [NSEntityDescription
                         insertNewObjectForEntityForName:@"List"
                         inManagedObjectContext:self.managedObjectContext];
    newList.text= @"New List";
    newList.listID = [NSNumber numberWithInt:0];
    
    NSMutableArray* relationship = [[self.fetchedResultsController fetchedObjects] mutableCopy];
    
    if (!relationship)
    {
        newList.listID = [NSNumber numberWithInt:0];
        [self saveContext];
        return;
    }
    
    int maxID = 0;
    for (List* item in relationship)
        maxID = maxID > [item.listID intValue] ? maxID : [item.listID intValue];
    
    // if maxID is set to zero, we don't want to increment, it's the first item so ID should be 0.
    newList.listID = [NSNumber numberWithInt:maxID+1];    
    
    [self saveContext];
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromIndex = sourceIndexPath.row;
    NSUInteger toIndex = destinationIndexPath.row;
    
    if (fromIndex == toIndex) return;
    
    NSUInteger count = [self.fetchedResultsController.fetchedObjects count];
    
    NSManagedObject *movingObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
    
    NSManagedObject *toObject  = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex];
    double toObjectDisplayOrder =  [[toObject valueForKey:@"listID"] doubleValue];
    
    double newIndex;
    if ( fromIndex < toIndex ) {
        // moving up
        if (toIndex == count-1) {
            // toObject == last object
            newIndex = toObjectDisplayOrder + 1.0;
        } else  {
            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex+1];
            double objectDisplayOrder = [[object valueForKey:@"listID"] doubleValue];
            
            newIndex = toObjectDisplayOrder + (objectDisplayOrder - toObjectDisplayOrder) / 2.0;
        }
        
    } else {
        // moving down
        
        if ( toIndex == 0) {
            // toObject == last object
            newIndex = toObjectDisplayOrder - 1.0;
            
        } else {
            
            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex-1];
            double objectDisplayOrder = [[object valueForKey:@"listID"] doubleValue];
            
            newIndex = objectDisplayOrder + (toObjectDisplayOrder - objectDisplayOrder) / 2.0;
            
        }
    }
    
    [movingObject setValue:[NSNumber numberWithDouble:newIndex] forKey:@"listID"];
    
    _userDrivenDataModelChange = YES;
    
    [self saveContext];
    
    _userDrivenDataModelChange = NO;
    
    // update with a short delay the moved cell
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(destinationIndexPath) afterDelay:0.2];
}


- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textField.text = [NSString stringWithFormat:@"%@", list.text];
    
    [cell resizeToFitTextExactly];
    
    cell.textField.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];

    [cell.textField addTarget:self action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    cell.textField.delegate = self;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTableViewCell *cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);
    
    NSString *identifier = @"ListCell";
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);
    
    // Set up the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
    if(!editing) {
        int i = 0;
        NSArray *data =[self.fetchedResultsController fetchedObjects];
        for(List *item in data) {
            item.listID = [NSNumber numberWithInt:i++];
        }
        NSError *error = nil;
        [self.managedObjectContext save:&error];
    }
}

#pragma mark ----------
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List"
                                                        inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"listID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                  managedObjectContext:self.managedObjectContext
                                                                                                    sectionNameKeyPath:nil
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
    LLListItemsViewController *vc = [[LLListItemsViewController alloc] init];
    vc.managedObjectContext = self.managedObjectContext;
    
    List* list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    vc.currentList = list;
    vc.title = list.text;
    
    [vc insertNewListItem];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    
    List* list = [self.fetchedResultsController objectAtIndexPath:path];
    list.text = field.textField.text;
    
    [self saveContext];
    
    [field resizeToFitTextExactly];
    
    [sender setNeedsDisplay];
}
@end
