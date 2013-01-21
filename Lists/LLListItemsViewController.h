//
//  LLMainViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/18/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"
#import "LLPullToInsertItemView.h"
#import "LLTabStackControl.h"


#define kPullDownToReloadToggleHeight 65.0f

@interface LLListItemsViewController : LLViewController{

@private    
	LLPullToInsertItemView *_pullToInsertItemView;
    List *m_currentList;
	BOOL checkForRefresh;
}

@property (nonatomic, strong) List *currentList;
@property (nonatomic, readonly) LLPullToInsertItemView *pullToInsertItemView;

- (void) gotoBack:(id)sender;
- (void) pullDownToReloadAction;
- (void) insertNewListItem;

@end
