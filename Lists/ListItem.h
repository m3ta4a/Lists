//
//  ListItem.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/3/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class List;

@interface ListItem : NSManagedObject

@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) List *list;

@end
