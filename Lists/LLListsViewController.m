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

@synthesize headerView = _headerView;

- (id)init
{
    self = [super init];
    if (!self)
        return nil;

    self.dragDelegate = self;

    UITableViewCell *header_view = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"app_config_identifier"];
    CGRect frame = header_view.frame;
    frame.size.height = 0; // hi
    header_view.frame = frame;
    header_view.textLabel.text = @"App Settings";
    header_view.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    header_view.backgroundColor = UIColorFromRGB(0xc0c0c0);
    header_view.textLabel.textColor = UIColorFromRGB(0x525252);
    header_view.textLabel.shadowColor = UIColorFromRGB(0xdEdEdE);
    header_view.textLabel.shadowOffset = CGSizeMake(1, 1);
    header_view.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configureAppSettings)];
    tap.numberOfTapsRequired = 1;
    [header_view addGestureRecognizer:tap];

    self.headerView = header_view;
    
    [self.view addSubview:self.headerView];

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
-(void)configureAppSettings
{
    LLListConfigureViewController *vc = [[LLListConfigureViewController alloc] init];

    vc.managedObjectContext = self.managedObjectContext;

    [self.navigationController pushViewController:vc animated:YES];

}
-(void)insertNewList
{
    [self insertNewListNamed:@""];
}
-(void)insertNewListNamed:(NSString*)name
{
    List *newList  = [NSEntityDescription
                         insertNewObjectForEntityForName:@"List"
                         inManagedObjectContext:self.managedObjectContext];
    newList.text   = name;
    newList.listID = [NSNumber numberWithInt:0];
    newList.type   = [NSNumber numberWithInt:SimpleList]; // Default is a Simple List
    
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

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.headerView cache:YES];
        [UIView setAnimationDuration:.3];

        CGRect frame = [self.headerView frame];
        frame.size.height = 0;
        [self.headerView setFrame:frame];

        frame = self.tableView.frame;
        frame.origin.y = frame.origin.y - 48;
        frame.size.height = frame.size.height + 48;
        self.tableView.frame = frame;

        [UIView commitAnimations];
    }
    else {
        [sender setSelected:YES];
        configToggle = YES;
        self.navigationItem.rightBarButtonItem.enabled = NO;

        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.headerView cache:YES];
        [UIView setAnimationDuration:.3];

        CGRect frame = [self.headerView frame];
        frame.size.height = 48;
        [self.headerView setFrame:frame];

        frame = self.tableView.frame;
        frame.origin.y = frame.origin.y + 48;
        frame.size.height = frame.size.height - 48;
        self.tableView.frame = frame;

        [UIView commitAnimations];  
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

    [movingObject setValue:[NSNumber numberWithInteger:toObjectDisplayOrder] forKey:@"listID"];
    [toObject setValue:[NSNumber numberWithInteger:fromObjectDisplayOrder] forKey:@"listID"];

    _userDrivenDataModelChange = YES;

    [self saveContext];
    
    _userDrivenDataModelChange = NO;

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

    // Italics for config mode
    if (configToggle){
        cell.textField.font = [UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
        cell.textField.textColor = UIColorFromRGB(0x1b1b1b);
    }
    else{
        cell.textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
        cell.textField.textColor = [UIColor blackColor];
    }

    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textField.text = [NSString stringWithFormat:@"%@", list.text];

    [cell resizeToFitTextExactly];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textField.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];
    cell.textField.delegate = self;

    CGRect tfframe = cell.textField.frame;

    [[cell viewWithTag:1111] removeFromSuperview];
    [[cell viewWithTag:2222] removeFromSuperview];

    UIView * newchkmrk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
    newchkmrk.tag = 1111;
    newchkmrk.frame = CGRectMake(3, 3, 15, 15);
    UIView * newoutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Outline"]];
    newoutline.tag = 2222;
    newoutline.frame = CGRectMake(5, 5, 7, 7);
    switch ([list.type intValue]) {
        case SimpleList:
            cell.textField.text = [NSString stringWithFormat:@"%@", list.text];
            tfframe.origin.x = 15;
            break;
        case ToDoList:
            cell.textField.text = [NSString stringWithFormat:@"%@", list.text];
            [cell addSubview: newchkmrk];
            tfframe.origin.x = 20;
            break;
        case OutlineList:
            cell.textField.text = [NSString stringWithFormat:@"%@", list.text];
            [cell addSubview: newoutline];
            tfframe.origin.x = 20;
            break;
        default:
            break;
    }

    cell.textField.frame = tfframe;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
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

//    // ivar
//    SystemSoundID mBeep;
//
//    // Create the sound ID
//    NSString* path = [[NSBundle mainBundle]
//                      pathForResource:@"Beep" ofType:@"aiff"];
//    NSURL* url = [NSURL fileURLWithPath:path];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &mBeep);
//
//    // Play the sound
//    AudioServicesPlaySystemSound(mBeep);
//
//    // Dispose of the sound
//    AudioServicesDisposeSystemSoundID(mBeep);

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
