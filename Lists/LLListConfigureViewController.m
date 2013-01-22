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
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = self.view.frame;
    
	// Do any additional setup after loading the view.
    self.tableView = [[LLTableView alloc] initWithFrame:
                      CGRectMake(BORDER_WIDTH,
                                 frame.origin.y,
                                 frame.size.width-2*BORDER_WIDTH,
                                 frame.size.height-BORDER_WIDTH)
                                                  style:UITableViewStyleGrouped];
    [self.tableView
            setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [self.view addSubview:self.tableView];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark ------------------
#pragma mark UITableView Data Source Methods
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LLTableViewCell *cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);
    
    NSString *identifier = @"";
    
    switch (indexPath.section) {
        case 0: // List Type
            switch (indexPath.row) {
                case 0: // Simple List
                    
                    identifier = @"SimpleListCell";
                    
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);
    
    switch (indexPath.section) {
        case 0: // List Type
            switch (indexPath.row) {
                case 0: // Simple List
                    
                    cell.textField.enabled = NO;
                    cell.textField.hidden = YES;
                    cell.textLabel.text = @"Simple List";
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.textField.delegate = self;
                    
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
@end
