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

//    NSString * backgroundFileName = @"dark_background.png";
//    background = [UIImage imageNamed:backgroundFileName];
//
//    if (style == UITableViewStyleGrouped)
//        self.backgroundView = [[UIImageView alloc] initWithImage:background];

    return self;
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    //    [background drawInRect:rect];
    // Create a gradient from white to red
    float f = 139.0/255.0;
    float t = 229.0/255.0;
    CGFloat colors [] = {
        t, t, t, 1.0,
        f, f, f, 1.0
    };

    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, colors, NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));

    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
}

@end