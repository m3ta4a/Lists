//
//  LLDataSource.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) NSArray *lists;

@end
