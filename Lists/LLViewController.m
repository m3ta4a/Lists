    //
//  LLViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLViewController.h"

@interface LLViewController ()


@end

@implementation LLViewController

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

    NSError *error;
    if (![[self listFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }
    if (![[self itemFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);
    }

    // listID's are 1 indexed then, since 0 is returned for no list
    int listID = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"];
    
    if (listID == 0) //first load
    {
        NSManagedObjectContext *context = [_itemFetchedResultsController managedObjectContext];
        NSEntityDescription *entity = [[_itemFetchedResultsController fetchRequest] entity];
        ListItem *newItem= [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];

        NSEntityDescription *listentity = [[_listFetchedResultsController fetchRequest] entity];
        List *newList = [NSEntityDescription insertNewObjectForEntityForName:[listentity name] inManagedObjectContext:context];

        newItem.text = @"New Item";
        newItem.row = 0;

        NSMutableSet *listitems = [NSMutableSet setWithObjects:newItem, nil];
        newList.items = listitems;
        newList.listID = 11;

        [super viewDidLoad];

        return;
    }



    [super viewDidLoad];
}
- (void)viewDidUnload {
    self.listFetchedResultsController = nil;
    self.itemFetchedResultsController = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    NSString *name = [[[_itemFetchedResultsController sections] objectAtIndex:section] name];
    return name;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    NSUInteger count = [[_itemFetchedResultsController sections] count];
    return count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfObjects = [[[_itemFetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return numberOfObjects + 1;
}

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    int addButtonRow = [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
    if (indexPath.row >= addButtonRow) //add button
        return;

    ListItem *item = [_itemFetchedResultsController objectAtIndexPath:indexPath];
    cell.textField.tag = indexPath.row;
    cell.textField.text = item.text;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused(tv)
#pragma unused(indexPath)
    LLTableViewCell *cell;

    assert(tv == self.tableView);
    assert(indexPath != nil);

    int addButtonRow = [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
    
    NSString *identifier = @"Cell";
    if (indexPath.row == addButtonRow)
        identifier = @"AddRow";

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
        self.header = [[LLTableViewHeaderControl alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 44.0)
                                                          andDelegate:self];

    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

// callback for header textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [[[_itemFetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects])
        cell.backgroundColor = [UIColor colorWithRed:0.0
                                           green:0.0
                                            blue:0.0
                                           alpha:1.0];
    else
        cell.backgroundColor = [UIColor colorWithRed:0.888
                                               green:0.888
                                                blue:0.888
                                               alpha:1.0];
    
}
-(IBAction)addRow:(id)sender
{
//    NSManagedObjectContext *itemcontext = [_itemFetchedResultsController managedObjectContext];
    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Item"
                         inManagedObjectContext:_managedObjectContext];
    newItem.text= @"New Item";
    newItem.row = _itemFetchedResultsController.fetchedObjects.count;

//    NSManagedObjectContext *listcontext = [_listFetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:_managedObjectContext];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"listID = %d", 11];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray* lists = [_managedObjectContext executeFetchRequest:request error:&error];
    List* list = [lists objectAtIndex:0];
    //[list addItem:newItem toRow:newItem.row];
    NSMutableSet *listitems = [[list.items setByAddingObject:newItem] mutableCopy];
    
    list.items = listitems;
    
    [_managedObjectContext save:&error];
    
//    [self.tableView reloadData];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int row = textField.tag;
    ListItem* item = (ListItem*)[_itemFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];

    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    item.text = newStr;
    
    return true;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    int row = textField.tag;
    ListItem* item = (ListItem*)[_itemFetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    
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
//    NSLog(@"current = %@, main = %@", [NSThread currentThread], [NSThread mainThread]);
    NSEntityDescription *entity = [[controller fetchRequest] entity];
    //NSLog(@"Changed object %@", entity);
    
    if ([entity.name isEqualToString:@"List" ])
    {
        return;
    }

    UITableView *tableView = self.tableView;
    LLTableViewCell *cell;
    switch(type) {
            
        case NSFetchedResultsChangeInsert:            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            cell = (LLTableViewCell *) [tableView cellForRowAtIndexPath:indexPath];
            [self configureCell:cell atIndexPath:indexPath];
            break;
        }
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray
                                               arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray
                                               arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"Changed section");
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
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

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:[self managedObjectContext]];
    [fetchRequest setEntity:entity];

    NSPredicate* pred = [NSPredicate predicateWithFormat:@"lists.listID = %d",11]; //][currentListID integerValue]];
    [fetchRequest setPredicate:pred];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"row" ascending:NO];
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
  //  [NSFetchedResultsController deleteCacheWithName:@"ItemResults"];
    
    NSNumber *currentListID = [NSNumber numberWithInteger:[[NSUserDefaults standardUserDefaults] integerForKey:@"currentListID"]];
    NSPredicate* pred = [NSPredicate predicateWithFormat:@"lists.listID = %d", 11];//][currentListID integerValue]];
    [_itemFetchedResultsController.fetchRequest setPredicate:pred];
    NSError *error = nil;
    if (![[self itemFetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}
- (void) refreshData:(NSNotification *)notif {    
    [[[self itemFetchedResultsController] managedObjectContext] mergeChangesFromContextDidSaveNotification:notif];
}

@end
