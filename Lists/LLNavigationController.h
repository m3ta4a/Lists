//
//  LLNavigationController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLListsViewController.h"
#import "LLListItemsViewController.h"

@interface LLNavigationController : UINavigationController

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) LLListsViewController *listsVC;
@property (nonatomic, strong) LLListItemsViewController *listItemsVC;

@end
