//
//  LLNavigationController.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLNavigationController.h"

@interface LLNavigationController ()

@end

@implementation LLNavigationController

@synthesize managedObjectContext = _managedObjectContext;
@synthesize listsVC = _listsVC;
@synthesize listItemsVC = _listItemsVC;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (!self)
        return nil;

    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
