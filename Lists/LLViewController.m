//
//  LLViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLViewController.h"

@interface LLViewController (){

}

@end

@implementation LLViewController

//@synthesize tableView = _tableView;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;
    
    _userDrivenDataModelChange = NO;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshData:)
                                                 name:NSManagedObjectContextDidSaveNotification
                                               object:nil];
    
    return self;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView reloadData];

    [self.view addSubview:self.tableView];

    CATransition* transition = [CATransition animation];
    transition.duration = .21;
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;

    [self.view.layer
       addAnimation:transition forKey:kCATransition];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [self.tableView removeFromSuperview];
}
- (void)refreshData:(NSNotification *)notif {
    [[self.fetchedResultsController managedObjectContext] mergeChangesFromContextDidSaveNotification:notif];
}
- (void)saveContext
{
    // Save the context.
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        /*
         TODO: Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}
+(bool)deviceHasRetinaDisplay
{
    return ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
            ([UIScreen mainScreen].scale == 2.0));
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
    
    //    [self.header deviceOrientationDidChange:screenWidth];
}
#pragma mark -----------------
#pragma mark TextView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{

    CGPoint point = [textView.superview convertPoint:textView.frame.origin toView:self.tableView];
    self.tableView.contentInset =  UIEdgeInsetsMake(0, 0, point.y, 0);

    [self.tableView scrollToRowAtIndexPath:[self indexPathForTextView:textView]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:NO];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    return YES;
}
-(void)textViewDidEndEditing:(UITextView *)textView{

    self.tableView.contentInset = UIEdgeInsetsZero;
    _last_range = NSMakeRange(0, 0);

    [self saveContext];
}
- (NSIndexPath*)indexPathForTextView:(UITextView*)textView{
    return [self.tableView indexPathForCell:(LLTableViewCell*) [textView superview]];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    // Uncomment this and use the method enclosed to relinquish focus with return key
    //    // Just don't get to have new lines in titles
    //    if ([text isEqualToString:@"\n"])
    //    {
    //        [self performSelector:@selector(textViewEditDone:) withObject:textView afterDelay:.01];
    //        return NO;
    //    }
    //-(void)textViewEditDone:(id)sender
    //{
    //    UITextView*view = (UITextView*)sender;
    //    [view resignFirstResponder];
    //}

    _userDrivenDataModelChange = YES;

    NSString *newStr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    [self setText:newStr forIndexPath:[self indexPathForTextView:textView]];

    _userDrivenDataModelChange = NO; // TODO:unless there's a change in number of lines

    _last_range = range;
    _was_delete = ( [text compare:@""] == 0 );

    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{

}
#pragma mark -------
#pragma mark UITableView Delegate Methods
// Display customization
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CGSize stringSize = [LLTableViewCell textViewSize:[self textForIndexPath:indexPath]
                                             forWidth:[self widthOfTextViewAtIndexPath:indexPath]];
    return MAX(44,stringSize.height+19);
}
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSUInteger fromIndex = sourceIndexPath.row;
    NSUInteger toIndex = destinationIndexPath.row;

    if (fromIndex == toIndex) return;

    NSManagedObject *movingObject = [self.fetchedResultsController.fetchedObjects objectAtIndex:fromIndex];
    NSManagedObject *toObject  = [self.fetchedResultsController.fetchedObjects objectAtIndex:toIndex];

    int toObjectDisplayOrder =  [[toObject valueForKey:[self sortKey]] integerValue];
    int fromObjectDisplayOrder =  [[movingObject valueForKey:[self sortKey]] integerValue];

    [movingObject setValue:[NSNumber numberWithInteger:toObjectDisplayOrder] forKey:[self sortKey]];
    [toObject setValue:[NSNumber numberWithInteger:fromObjectDisplayOrder] forKey:[self sortKey]];

    // This allows us to animate moving the cells
    _userDrivenDataModelChange = YES;

    [self saveContext];

    _userDrivenDataModelChange = NO;

    // update with a short delay the moved cell
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(sourceIndexPath) afterDelay:0.2];
    [self performSelector:(@selector(configureCellAtIndexPath:)) withObject:(destinationIndexPath) afterDelay:0.2];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *name = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    return name;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    NSUInteger count = [[self.fetchedResultsController sections] count];
    return count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfObjects = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    return numberOfObjects;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

        [self saveContext];
    }
}
- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    CGRect rect = cell.frame;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [[UIColor grayColor] CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:image];

    // should prevent losing the cursor in the textview
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
}
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:(LLTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] initWithFrame:CGRectZero]; // empty footer prevents empty cells from drawing
}
#pragma ------------
#pragma NSFetchedResultsController Delegate Methods
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
    if (_userDrivenDataModelChange) return;
    
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    if (_userDrivenDataModelChange) return;
    
//    NSEntityDescription *entity = [[controller fetchRequest] entity];
    
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

            // The range needs to be set, or else the cursor just goes to the end
            if (_last_range.length !=0 || _last_range.location != 0)
                cell.textView.selectedRange = _was_delete ? NSMakeRange(_last_range.location, 0) : NSMakeRange(_last_range.location+1, 0);

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
    
    if (_userDrivenDataModelChange) return;
    
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

    if (_userDrivenDataModelChange) return;

    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

#pragma mark ----------
#pragma mark Fetched Results Controller
- (NSFetchedResultsController *)fetchedResultsController {

    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:[self entityName]
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:[self sortKey] ascending:NO];
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
@end
