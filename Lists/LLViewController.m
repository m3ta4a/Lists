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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    CGRect frame = self.view.frame;
    
    UIImage *vert_strip = [UIImage imageNamed:@"blue_leather_vert_strip.png"];
    UIImage *horiz_strip = [UIImage imageNamed:@"blue_leather_horiz_strip.png"];
    
    UIImageView* blockViewLeft = [[UIImageView alloc] initWithImage:vert_strip];
    blockViewLeft.frame = CGRectMake(0,
                                 frame.origin.y,
                                 BORDER_WIDTH,
                                 frame.size.height);
    
    UIImageView* blockViewRight = [[UIImageView alloc] initWithImage:vert_strip];
    blockViewRight.frame = CGRectMake(self.view.frame.size.width-BORDER_WIDTH,
                                     frame.origin.y,
                                     BORDER_WIDTH,
                                     frame.size.height);

    UIImageView* blockViewBottom = [[UIImageView alloc] initWithImage:horiz_strip];
    blockViewBottom.frame = CGRectMake(0,
                                      frame.size.height-BORDER_WIDTH,
                                      frame.size.width,
                                      BORDER_WIDTH);

    [self.view addSubview:blockViewLeft];
    [self.view addSubview:blockViewRight];
    [self.view addSubview:blockViewBottom];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row <= [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row <= [[[self.fetchedResultsController sections] objectAtIndex:indexPath.section] numberOfObjects];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
    }
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
    
    if (_userDrivenDataModelChange)
        return;
    
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

- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Subclasses of LLViewController must implement configureCell: atIndexPath:");
}
- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath
{
    [self configureCell:(LLTableViewCell*)[self.tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    
    if (_userDrivenDataModelChange) return;
    
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}
#pragma mark -----------------
#pragma mark Textfield delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect rect = textField.frame;
    rect.size.width = 200;
    textField.frame = rect;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    LLTableViewCell *field = (LLTableViewCell*)[textField superview];
    
    [field resizeToFitTextExactly];
    [textField setNeedsDisplay];
}
@end
