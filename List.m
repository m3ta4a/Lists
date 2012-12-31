//
//  List.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/30/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "List.h"

@implementation List

@dynamic listID;
@dynamic items;

-(ListItem*)itemAtRow:(int)row
{
    for (ListItem* item in self.items) {
        if (item.row == row)
            return item;
    }
    return nil;
}

-(void)addItem:(ListItem*)item toRow:(int)row
{
    item.row = row;
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&item count:1];
    
    [self willChangeValueForKey:@"items"
                withSetMutation:NSKeyValueUnionSetMutation
                   usingObjects:changedObjects];
    [self.items addObject:item];
    [self didChangeValueForKey:@"items"
               withSetMutation:NSKeyValueUnionSetMutation
                  usingObjects:changedObjects];
}
-(void)removeItemInRow:(int)row
{
    ListItem *item = [self itemAtRow:row];
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&item count:1];
    
    [self willChangeValueForKey:@"items"
                withSetMutation:NSKeyValueMinusSetMutation
                   usingObjects:changedObjects];
    [self.items removeObject:item];
    [self didChangeValueForKey:@"items"
               withSetMutation:NSKeyValueMinusSetMutation
                  usingObjects:changedObjects];
}
-(void)replaceItemInRow:(int)row withItem:(ListItem*)item
{
    [self removeItemInRow:row];
    [self addItem:item toRow:row];
}
@end
