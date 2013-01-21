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

@interface List : NSManagedObject{
    NSMutableArray *m_orderedItems;
}

@property (nonatomic, retain) NSNumber * listID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSMutableSet *items;


@end


@interface List (CoreDataGeneratedAccessors)
    
- (void)addItemsObject:(ListItem *)value;
- (void)removeItemsObject:(ListItem *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
