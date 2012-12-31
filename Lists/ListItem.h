//
//  ListItem.h
//  ToDo
//
//  Created by Jake Van Alstyne on 5/7/10.
//  Copyright 2010 EggDevil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ListItem : NSManagedObject

@property (nonatomic, copy) NSString *text;

@end
