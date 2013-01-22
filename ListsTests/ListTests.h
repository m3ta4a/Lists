//
//  ListsTests.h
//  ListsTests
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <CoreData/CoreData.h>
#import <SenTestingKit/SenTestingKit.h>

#import "LLAppDelegate.h"
#import "LLListsViewController.h"
#import "LLListItemsViewController.h"

@interface ListTests : SenTestCase
{
@private

    LLAppDelegate    *app_delegate;
    LLNavigationController *navigation_controller;
    LLListsViewController *lists_view_controller;
    LLListItemsViewController *listitems_view_controller;
    UIView             *lists_view;
}

@end
