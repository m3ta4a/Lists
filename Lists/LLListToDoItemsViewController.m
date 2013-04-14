//
//  LLListToDoItemsViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 4/13/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLListToDoItemsViewController.h"

@interface LLListToDoItemsViewController ()

@end

@implementation LLListToDoItemsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)configureCell:(LLTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {

    [super configureCell:cell atIndexPath:indexPath];

    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textView.text = [NSString stringWithFormat:@"%@", item.text];

    [cell adjustTextInputHeightForText:item.text
                              andWidth:self.tableView.frame.size.width * 5/6];

    cell.textView.inputAccessoryView = [[LLTableViewKeyboardDismisser alloc] initWithView:self.tableView];
    cell.textView.delegate = self;
}
@end
