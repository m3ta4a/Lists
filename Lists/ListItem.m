//
//  ListItem.m
//  ToDo
//
//  Created by Jake Van Alstyne on 5/7/10.
//  Copyright 2010 EggDevil. All rights reserved.
//

#import "ListItem.h"


@implementation ListItem
@dynamic text;
@dynamic row;

- (void) awakeFromInsert {
    [super awakeFromInsert];
    self.text = @"New Item";
}
- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"text"]) {
        self.text = @"";
    }
    else {
        [super setNilValueForKey:key];
    }
}
@end
