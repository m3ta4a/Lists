//
//  LLListConfigureViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/21/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListConfigureViewController.h"

@interface LLListConfigureViewController ()

@end

@implementation LLListConfigureViewController

@synthesize currentList = m_currentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self)
        return nil;

        return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = self.view.frame;
    self.tableView = [[LLTableView alloc] initWithFrame:
                      CGRectMake(BORDER_WIDTH,
                                 frame.origin.y,
                                 frame.size.width-2*BORDER_WIDTH,
                                 frame.size.height-BORDER_WIDTH)
                                                  style:UITableViewStyleGrouped];
    [self.tableView
     setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView= nil;
    [self.view addSubview:self.tableView];
	// Do any additional setup after loading the view.
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);
    
    NSString *identifier = @"";

    // Get the right identifier
    switch (indexPath.section) {
        case ListTypeConfig: // List Type
            switch (indexPath.row) {
                case SimpleList:                    
                    identifier = @"SimpleListCell";
                    break;
                case ToDoList:
                    identifier = @"ToDoListCell";
                    break;
                case OutlineList:
                    identifier = @"OutlineListCell";
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];


    // Then get the right cell, if we must
    if (cell == nil) {
        switch (indexPath.section) {
            case ListTypeConfig: // List Type
                switch (indexPath.row) {
                    case SimpleList:
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        break;
                    case ToDoList:
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        break;
                    case OutlineList:
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                        break;
                    default:
                        break;
                }
                break;
                
            default:
                break;
        }
    }

    // and make sure we got a cell
    assert(cell != nil);

    // no config cells need these settings
    cell.selectionStyle = UITableViewCellSelectionStyleNone;


    // Now we've verified and set common settings, set unique ones
    switch (indexPath.section) {
        case ListTypeConfig: // List Type

            cell.accessoryType = UITableViewCellAccessoryNone;

            switch (indexPath.row) {
                case SimpleList:
                    cell.textLabel.text = @"Simple List";
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                case ToDoList:
                    cell.textLabel.text = @"To Do List";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                case OutlineList:
                    cell.textLabel.text = @"Outline List";
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return cell;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"List Type";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    switch (indexPath.section) {
        case ListTypeConfig: // List Type

            switch (indexPath.row) {
                case SimpleList:
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    break;
                case ToDoList:
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    break;
                case OutlineList:
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-2 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section]].accessoryType = UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            break;

        default:
            break;
    }
}
@end
