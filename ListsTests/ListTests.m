//
//  ListsTests.m
//  ListsTests
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "ListTests.h"

@implementation ListTests

- (void)setUp
{
    [super setUp];

    app_delegate         = (LLAppDelegate*)[[UIApplication sharedApplication] delegate];
    navigation_controller = (LLNavigationController*)app_delegate.window.rootViewController;
    lists_view_controller = (LLListsViewController*)navigation_controller.topViewController;
    lists_view            = lists_view_controller.view;

}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testList
{
    
}

- (void) testAppDelegate {
    STAssertNotNil(app_delegate, @"Cannot find the application delegate");
}
- (void) testNavigationController {
    STAssertNotNil(navigation_controller, @"Cannot find the navigation controller");
}
- (void) testListsViewController {
    STAssertNotNil(lists_view_controller, @"Cannot find the lists view controller");
}
- (void) testListsView {
    STAssertNotNil(lists_view, @"Cannot find the lists view");
}
- (void) testManagedObjectContext{
    STAssertNotNil(lists_view_controller.managedObjectContext, @"Cannot find the managed object context");
}
- (void) testInsertingAndDeletingNewList{
    // See whether we need to create a first list
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List"
                                              inManagedObjectContext:lists_view_controller.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"listID" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setFetchBatchSize:20];

    NSError *error;
    NSArray *results = [lists_view_controller.managedObjectContext executeFetchRequest:fetchRequest error:&error];

    int initialCt = [results count];

    List *newList = [NSEntityDescription
                     insertNewObjectForEntityForName:@"List"
                     inManagedObjectContext:lists_view_controller.managedObjectContext];
    newList.text= @"New List";
    newList.listID = [NSNumber numberWithInt:0];

    int finalCt = [[lists_view_controller.managedObjectContext executeFetchRequest:fetchRequest error:&error] count];

    STAssertEquals(initialCt+1, finalCt, @"Adding a new List didn't increment the managed object context count correcly");

    [lists_view_controller.managedObjectContext deleteObject:newList];

    finalCt = [[lists_view_controller.managedObjectContext executeFetchRequest:fetchRequest error:&error] count];
    STAssertEquals(initialCt, finalCt, @"Deleting the new List didn't decrement the managed object context count correcly");
}
- (void) testPushingListItemsViewController
{
    LLListItemsViewController *listItemVC = [[LLListItemsViewController alloc] init];

    [navigation_controller pushViewController:listItemVC animated:YES];

    STAssertNotNil(listItemVC.navigationController, @"Expected ListItems View Controller to have navigation controller property set");

    [navigation_controller popToRootViewControllerAnimated:YES];

    STAssertNil(listItemVC.navigationController, @"Expected ListItems VC to have lost nav controller property");
}
@end
