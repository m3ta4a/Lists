//
//  LLTransparentToolbar.m
//  Lists
//
//  Created by Jake Van Alstyne on 4/14/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLTransparentToolbar.h"

@implementation LLTransparentToolbar

// Override init.
- (id) init
{
    self = [super init];
    [self applyTranslucentBackground];
    return self;
}

// Override initWithFrame.
- (id) initWithFrame:(CGRect) frame
{
    self = [super initWithFrame:frame];
    [self applyTranslucentBackground];
    return self;
}
// Override draw rect to avoid
// background coloring
- (void)drawRect:(CGRect)rect {
    // do nothing in here
}

// Set properties to make background
// translucent.
- (void) applyTranslucentBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.translucent = YES;
}
@end
