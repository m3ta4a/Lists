//
//  List.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/30/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface List : NSManagedObject

@property (nonatomic) int id;
@property (nonatomic) NSSet *items;
@end
