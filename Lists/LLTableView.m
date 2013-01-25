//
//  LLTableView.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/17/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLTableView.h"

@implementation LLTableView

- (id)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:frame style:UITableViewStylePlain];
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (!self)
        return nil;


    NSString * backgroundFileName = @"background.png";
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] &&
        ([UIScreen mainScreen].scale == 2.0)) {
        backgroundFileName = @"background@2x.png";
    }

    background = [UIImage imageNamed:backgroundFileName];


    if (style == UITableViewStyleGrouped)
        self.backgroundView = [[UIImageView alloc] initWithImage:background];

    return self;
}
-(void)drawRect:(CGRect)rect
{
    [background drawInRect:rect];
}

@end