//
//  List.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/30/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "ListItem.h"

@interface List : NSManagedObject

@property (nonatomic) int listID;
@property (nonatomic) NSMutableSet *items;

-(ListItem*)itemAtRow:(int)row;
-(void)addItem:(ListItem*)item toRow:(int)row;
-(void)removeItemInRow:(int)row;
-(void)replaceItemInRow:(int)row withItem:(ListItem*)item;
@end