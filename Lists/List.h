//
//  List.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/3/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ListItem;

@interface List : NSManagedObject

@property (nonatomic, retain) NSNumber * listID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSOrderedSet *items;
@end

@interface List (CoreDataGeneratedAccessors)

- (void)insertObject:(ListItem *)value inItemsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromItemsAtIndex:(NSUInteger)idx;
- (void)insertItems:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInItemsAtIndex:(NSUInteger)idx withObject:(ListItem *)value;
- (void)replaceItemsAtIndexes:(NSIndexSet *)indexes withItems:(NSArray *)values;
- (void)addItemsObject:(ListItem *)value;
- (void)removeItemsObject:(ListItem *)value;
- (void)addItems:(NSOrderedSet *)values;
- (void)removeItems:(NSOrderedSet *)values;
@end
