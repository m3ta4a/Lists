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
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)awakeFromNib
{
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [self addGestureRecognizer:tap];
}
-(void)tapReceived:(UITapGestureRecognizer*)recognizer
{
    CGPoint point = [recognizer locationInView:self];
	NSIndexPath *indexPath = [self indexPathForRowAtPoint:point];
    
	if (!indexPath)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LLTableViewHitOutsideCell" object:self];
	}
}
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
	// check if a row was hit
//	NSIndexPath *indexPath = [self indexPathForRowAtPoint:point];
    
    CGRect sectionRect = [self rectForSection:0];    
    if (!CGRectContainsPoint(sectionRect, point))
    {
		[[NSNotificationCenter defaultCenter] postNotificationName:@"LLTableViewHitOutsideCell" object:self];
    }
    
//	if (!indexPath)
//	{
//		[[NSNotificationCenter defaultCenter] postNotificationName:@"LLTableViewHitOutsideCell" object:self];
//	}
    
	return [super hitTest:point withEvent:event];
}

@end
