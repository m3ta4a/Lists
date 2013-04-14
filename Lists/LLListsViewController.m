//
//  LLListsViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListsViewController.h"

#define CHECKMARK_ICN_TAG 1111
#define OUTLINE_ICN_TAG 2222


@interface LLListsViewController ()
{
    bool configToggle;
}

@end

@implementation LLListsViewController

@synthesize headerView = _headerView;

-(NSString*)sortKey
{
    return @"listID";
}
-(NSString*)entityName
{
    return @"List";
}
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
    header_view.textLabel.text = @"Rename / Configure Lists";
    header_view.textLabel.font = [UIFont boldSystemFontOfSize:15.0];
    header_view.textLabel.textAlignment = NSTextAlignmentCenter;
    header_view.backgroundColor = UIColorFromRGB(0x7d7d7d);
    header_view.textLabel.textColor = UIColorFromRGB(0x343434);
    header_view.textLabel.shadowColor = UIColorFromRGB(0xbcbcbc);
    header_view.textLabel.shadowOffset = CGSizeMake(1, 1);

//    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(configureAppSettings)];
//    tap.numberOfTapsRequired = 1;
//    [header_view addGestureRecognizer:tap];

    self.headerView = header_view;
    
    [self.view addSubview:self.headerView];

    configToggle = NO;
    
    return self;
}
- (void)viewDidLoad
{
    // Table View must be loaded for reordering TVController
    self.tableView = [[LLTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.contentInset = DEFAULT_TABLE_INSETS;
    [self.view addSubview:self.tableView];

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
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSArray* relationship = [self.fetchedResultsController fetchedObjects];
    if ([relationship count] == 0)
    {
        [self insertNewList];
    }
}
//-(void)configureAppSettings
//{
//    // TODO: Need an App Settings View Controller
//    LLListConfigureViewController *vc = [[LLListConfigureViewController alloc] init];
//
//    vc.managedObjectContext = self.managedObjectContext;
//
//    [self.navigationController pushViewController:vc animated:YES];
//
//}
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
    cell.justCreated = YES;
    [cell.textView setUserInteractionEnabled:YES];
    [cell.textView becomeFirstResponder];
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
        frame.origin.y = frame.origin.y - HEADER_VIEW_HEIGHT;
        frame.size.height = frame.size.height + HEADER_VIEW_HEIGHT;
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
        frame.size.height = HEADER_VIEW_HEIGHT;
        [self.headerView setFrame:frame];

        frame = self.tableView.frame;
        frame.origin.y = frame.origin.y + HEADER_VIEW_HEIGHT;
        frame.size.height = frame.size.height - HEADER_VIEW_HEIGHT;
        self.tableView.frame = frame;

        [UIView commitAnimations];  
    }
       
    [self.tableView reloadData];
}
#pragma mark ---------
#pragma mark Reordering Table View delegate methods
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow
//{
//    _fromIndex = dragRow;
//}
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//    [self tableView:dragTableViewController.tableView moveRowAtIndexPath:_fromIndex toIndexPath:destinationIndexPath];
//}
//- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//
//}
//- (BOOL)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath
//{
//    return YES;
//}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfObjects = [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];

    return numberOfObjects;
}
- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    assert(cell!=nil);
    assert(indexPath!=nil);

    [super configureCell:cell atIndexPath:indexPath];

    // =============================
    //
    // Common to All TableViewCells
    //
    // =============================

    // Italics for config mode
    if (configToggle){
        cell.textView.font = [UIFont italicSystemFontOfSize:TEXT_INPUT_FONT_SIZE];
        cell.textView.textColor = UIColorFromRGB(0x1b1b1b);
        [cell.textView setUserInteractionEnabled:YES];
    }
    else{
        cell.textView.font = TEXT_INPUT_FONT;
        cell.textView.textColor = [UIColor blackColor];
        [cell.textView setUserInteractionEnabled:cell.justCreated];
    }

    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];

    cell.textView.text = [NSString stringWithFormat:@"%@", list.text];
    cell.textView.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];

    if (!cell.textView.delegate)
        cell.textView.delegate = self;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    [cell adjustTextInputHeightForText:list.text andWidth:[self widthOfTextViewAtIndexPath:indexPath]];

    // ==============================
    //
    // Customize:
    //      Simple
    //      Todo
    //      Outline
    // There is a temptation to subclass, but resist!
    // For that is the point of reuseIdentifier
    // ==============================

    [[cell viewWithTag:CHECKMARK_ICN_TAG] removeFromSuperview];
    [[cell viewWithTag:OUTLINE_ICN_TAG] removeFromSuperview];

    int height = [self.tableView rectForRowAtIndexPath:indexPath].size.height;

    UIView * newchkmrk = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Check"]];
    newchkmrk.tag = CHECKMARK_ICN_TAG;
    newchkmrk.frame = CGRectMake(281, height/2-12, 24, 24);

    UIView * newoutline = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Outline"]];
    newoutline.tag = OUTLINE_ICN_TAG;
    newoutline.frame = CGRectMake(285, height/2-6, 12, 12);

    switch ([list.type intValue]) {
        case SimpleList:
            break;
        case ToDoList:
            [cell addSubview: newchkmrk];
            break;
        case OutlineList:
            [cell addSubview: newoutline];
            break;
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTableViewCell *cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);

//    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSString *identifier = @"ListCell";

    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);

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

- (void) textViewDidEndEditing:(UITextView*)textView{
    [super textViewDidEndEditing:textView];

    LLTableViewCell *cell = (LLTableViewCell*)[textView superview];
    cell.justCreated = NO;
}

#pragma mark -------
#pragma mark TableView Delegate Methods
// used by parent class in heightForRowAtIndexPath:
- (void)setText:(NSString*)text forIndexPath:(NSIndexPath*)indexPath{
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    list.text = text;
}
- (NSString*)textForIndexPath:(NSIndexPath*)indexPath{
    List *list = [self.fetchedResultsController objectAtIndexPath:indexPath];
    return list.text;
}
- (NSInteger)widthOfTextViewAtIndexPath:(NSIndexPath*)indexPath{
    return self.tableView.frame.size.width * 5/6;
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
        List* list = [self.fetchedResultsController objectAtIndexPath:indexPath];

        LLListItemsViewController *vc;

        switch ([list.type intValue]) {
            case SimpleList:
                vc = [[LLListItemsViewController alloc] init];
                break;
            case ToDoList:
                vc = [[LLListToDoItemsViewController alloc] init];
                break;
            case OutlineList:
                vc = [[LLListOutlineItemsViewController alloc] init];
                break;
            default:
                break;
        }

        vc.managedObjectContext = self.managedObjectContext;
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
@end
