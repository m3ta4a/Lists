//
//  LLListConfigureViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/21/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLViewController.h"
#import "List.h"

@interface LLListConfigureViewController : LLViewController{
    List *m_currentList;
}


@property (nonatomic, strong) List *currentList;


//- (void)saveContext;


@end
