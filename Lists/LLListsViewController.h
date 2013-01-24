//
//  LLListsViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"
#import "LLListItemsViewController.h"
#import "LLListConfigureViewController.h"

@interface LLListsViewController : LLViewController
{
    
}

-(void)insertNewList;
-(void)insertNewListNamed:(NSString*)name;
-(void)enterConfigListMode:(UIButton*)sender;

@end
