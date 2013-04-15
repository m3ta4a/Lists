//
//  LLMainViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/18/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"


#define kPullDownToReloadToggleHeight 65.0f

@interface LLListItemsViewController : LLViewController <LLReorderingTableViewControllerDelegate>{

@private    
    List *m_currentList;
	BOOL checkForRefresh;
}

@property (nonatomic, strong) List *currentList;

- (id)initWithList:(List*)list andContext:(NSManagedObjectContext*)context;
- (void) gotoBack:(id)sender;
- (void) insertNewListItem;
- (void) insertNewListItemNamed:(NSString*)name;

@end
