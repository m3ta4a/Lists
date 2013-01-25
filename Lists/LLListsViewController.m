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
    bool configToggle;
}

@end

@implementation LLListsViewController

- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    self.dragDelegate = self;

    configToggle = NO;
    
    return self;
}
- (void)viewDidLoad
{
    self.tableView = [[LLTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
//    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;

    // Table View must be loaded for reordering TVController
    [super viewDidLoad];

    self.title = @"Lists";

    NSString *addRowImgFile = @"AddRow.png";
    NSString *configIconImgFile = @"config_icon.png";
    NSString *configIconONImgFile = @"config_icon_on.png";

    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        addRowImgFile = @"AddRow@2x.png";
        configIconImgFile = @"config_icon@2x.png";
        configIconONImgFile = @"config_icon_on@2x.png";
    }

    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *addImage = [[UIImage imageNamed:addRowImgFile] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [addButton setBackgroundImage:addImage forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(insertNewList) forControlEvents:UIControlEventTouchUpInside];
    addButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *editImage = [[UIImage imageNamed:configIconImgFile] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    UIImage *editImageOn = [[UIImage imageNamed:configIconONImgFile] stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    [editButton setBackgroundImage:editImage forState:UIControlStateNormal];
    [editButton setBackgroundImage:editImageOn forState:UIControlStateSelected];
    [editButton addTarget:self action:@selector(enterConfigListMode:) forControlEvents:UIControlEventTouchUpInside];
    editButton.frame = CGRectMake(0, 0, 30, 30);
    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    self.navigationItem.leftBarButtonItem = editButtonItem;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView reloadData];

    NSArray* relationship = [self.fetchedResultsController fetchedObjects];
    if ([relationship count] == 0)
    {
        [self insertNewList];
    }
}

-(void)insertNewList
{
    [self insertNewListNamed:@""];
}
-(void)insertNewListNamed:(NSString*)name
{
    List *newList = [NSEntityDescription
                         insertNewObjectForEntityForName:@"List"
                         inManagedObjectContext:self.managedObjectContext];
    newList.text= name;
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

    // give the new tableview cell textfield firstresponder status
    NSIndexPath *path = [NSIndexPath indexPathForRow:0 inSection:0];
    LLTableViewCell *cell = (LLTableViewCell*)[self.tableView cellForRowAtIndexPath:path];
    [cell.textField becomeFirstResponder];
}
-(void)enterConfigListMode:(UIButton*)sender
{
    if([sender isSelected]){
        [sender setSelected:NO];
        configToggle = NO;
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [self.tableView setEditing:NO animated:YES];
    } else {
        [sender setSelected:YES];
        configToggle = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self.tableView setEditing:YES animated:YES];
    }
    [self.tableView reloadData];
}
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow
{
}
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath
{

}
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath
{

}
- (BOOL)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromIndex = sourceIndexPath.row;
    NSUInteger toIndex = destinationIndexPath.row;
    
    if (fromIndex == toIndex) return;
    
    //    NSUInteger count = [self.fetchedResultsController.fetchedObjects count];
    
    NSManagedObject *movingObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
    NSManagedObject *toObject  = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex];

    int toObjectDisplayOrder =  [[toObject valueForKey:@"listID"] integerValue];
    int fromObjectDisplayOrder =  [[movingObject valueForKey:@"listID"] integerValue];
    
//    double newIndex;
//
//    if ( fromIndex > toIndex ) { // Moving up
//        if ( toIndex == count - 1 ) {
//            newIndex = toObjectDisplayOrder + 1.0;
//        } else  {
//            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex+1];
//            double objectDisplayOrder = [[object valueForKey:@"listID"] doubleValue];
//            
//            newIndex = toObjectDisplayOrder + (objectDisplayOrder - toObjectDisplayOrder) / 2.0;
//        }
//        
//    } else {
//        // moving down
//        
//        if ( toIndex == 0) {
//            // toObject == last object
//            newIndex = toObjectDisplayOrder - 1.0;
//            
//        } else {
//            
//            NSManagedObject *object = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex-1];
//            double objectDisplayOrder = [[object valueForKey:@"listID"] doubleValue];
//            
//            newIndex = objectDisplayOrder + (toObjectDisplayOrder - objectDisplayOrder) / 2.0;
//            
//        }
//    }

    [movingObject setValue:[NSNumber numberWithInteger:toObjectDisplayOrder] forKey:@"listID"];
    [toObject setValue:[NSNumber numberWithInteger:fromObjectDisplayOrder] forKey:@"listID"];
    
    //    _userDrivenDataModelChange = YES;
    
    [self saveContext];
    
//    _userDrivenDataModelChange = NO;

    // update with a short delay the moved cell
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(sourceIndexPath) afterDelay:0.2];
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(destinationIndexPath) afterDelay:0.2];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfObjects = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];

    return numberOfObjects;
}

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    [super configureCell:cell atIndexPath:indexPath];
    
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textField.text = [NSString stringWithFormat:@"%@", list.text];
    
    [cell resizeToFitTextExactly];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (configToggle)
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textField.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];

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

    [self configureCell:cell atIndexPath:indexPath];

    
    return cell;
}
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(LLReorderingTableViewController *)dragTableViewController
{
    LLTableViewCell *cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textField.text = [NSString stringWithFormat:@"%@", list.text];

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
    if (!configToggle)
    {
        LLListItemsViewController *vc = [[LLListItemsViewController alloc] init];
        vc.managedObjectContext = self.managedObjectContext;
    
        List* list = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.currentList = list;
        vc.title = list.text;

        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        LLListConfigureViewController *vc = [[LLListConfigureViewController alloc] init];
        
        vc.managedObjectContext = self.managedObjectContext;
        
        List* list = [self.fetchedResultsController objectAtIndexPath:indexPath];
        vc.currentList = list;
        vc.title = list.text;
        
        [self.navigationController pushViewController:vc animated:YES];

    }
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
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath* path = [self.tableView indexPathForCell:(LLTableViewCell*) [textField superview]];
    List* list = (List*)[self.fetchedResultsController objectAtIndexPath:path];
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    list.text = newStr;
    
    return true;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    NSIndexPath* path = [self.tableView indexPathForCell:(LLTableViewCell*) [[textField superview] superview]];
    List* item = (List*)[self.fetchedResultsController objectAtIndexPath:path];
    
    item.text = @"";

    [self saveContext];

    return true;
}
@end
