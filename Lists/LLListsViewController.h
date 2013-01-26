//
//  LLListsViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/20/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "LLViewController.h"
#import "LLListItemsViewController.h"
#import "LLListConfigureViewController.h"

@interface LLListsViewController : LLViewController <LLReorderingTableViewControllerDelegate>
{
    UIView* _headerView;
}

@property (nonatomic, strong) UIView* headerView;

-(void)insertNewList;
-(void)insertNewListNamed:(NSString*)name;
-(void)enterConfigListMode:(UIButton*)sender;
-(void)configureAppSettings;

@end
