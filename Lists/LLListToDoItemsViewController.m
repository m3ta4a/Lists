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

- (id)init
{
    self = [super init];
    if (!self)
        return nil;

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

//    ListItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];

    // do extra configuring special to ToDo items
}
@end
