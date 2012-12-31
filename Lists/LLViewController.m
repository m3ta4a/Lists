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
@synthesize settings = _settings;

@synthesize managedObjectContext = _managedObjectContext;

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Settings" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *settingsArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    if ([settingsArray count] == 0)
    {
        List *newList = [NSEntityDescription
                                        insertNewObjectForEntityForName:@"List"
                                        inManagedObjectContext:self.managedObjectContext];
        ListItem *newItem = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Item"
                             inManagedObjectContext:self.managedObjectContext];
        Settings *settings = [NSEntityDescription
                             insertNewObjectForEntityForName:@"Settings"
                             inManagedObjectContext:self.managedObjectContext];
        
        NSMutableSet *listitems = [NSMutableSet setWithObjects:newItem, nil];
        newList.items = listitems;
        
        settings.currentListID = 0;
        self.settings = settings;
        
        self.currentList = newList;
        
        [super viewDidLoad];

        return;
    }
    
    Settings *settings = [settingsArray objectAtIndex:0];
    self.settings = settings;
    
    fetchRequest = [[NSFetchRequest alloc] init];
    entity = [NSEntityDescription
                    entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSArray *listArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *list in listArray) {
        List *_list = (List*)list;
        if (_list.listID == self.settings.currentListID){
            self.currentList = _list;
            break;
        }
    }
    
    
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1; // Hard code 1 section (Apple's header makes for a sticky title bar)
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.currentList items] count] + 1; // +1 for Add row
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused(tv)
#pragma unused(indexPath)
    LLTableViewCell *cell;

    assert(tv == self.tableView);
    assert(indexPath != nil);

    int addButtonRow = [[self.currentList items] count];
    
    NSString *identifier = @"Cell";
    if (indexPath.row == addButtonRow)
        identifier = @"AddRow";

    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);

    
    if (indexPath.row < addButtonRow){
        cell.textField.tag = indexPath.row;
        cell.textField.text = [self.currentList itemAtRow:indexPath.row].text;
    }
    
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
    if (indexPath.row == [[self.currentList items] count])
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
    ListItem *newItem = [NSEntityDescription
                         insertNewObjectForEntityForName:@"Item"
                         inManagedObjectContext:self.managedObjectContext];
    [self.currentList addItem:newItem toRow:[[self.currentList items] count]];
    [self.tableView reloadData];
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int row = textField.tag;
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    ListItem *item = [self.currentList itemAtRow:row];
    item.text = newStr;
    [self.currentList replaceItemInRow:row withItem:item];
    
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
@end
