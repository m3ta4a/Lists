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
#import "LLListToDoItemsViewController.h"
#import "LLListOutlineItemsViewController.h"
#import "LLListConfigureViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HEADER_VIEW_HEIGHT 30

@interface LLListsViewController : LLViewController <LLReorderingTableViewControllerDelegate>
{
    UIView* _headerView;
    NSArray* _leftButtonItems; // will just have one item
    NSArray* _editLeftButtonItems; //need it to hide and show
    UIButton* _configButton;
}

@property (nonatomic, strong) UIView* headerView;

-(void)insertNewList;
-(void)insertNewListNamed:(NSString*)name;
-(void)enterConfigListMode:(UIButton*)sender;
//-(void)configureAppSettings;

@end
