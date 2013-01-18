//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LLHeaderTag.h"


@implementation LLHeaderTag
@synthesize centerFrame, cornerRadius;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    self.textColor = [UIColor blackColor];
    self.font = [UIFont boldSystemFontOfSize:20];
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textAlignment = NSTextAlignmentCenter;

    self.cornerRadius = 8;

    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowRadius = 5.0;
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.clipsToBounds = NO;

    self.text = @"New";

    self.frame = frame;
    self.centerFrame = frame;

    [self addTarget:self action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];

    return self;
}

-(double)getWidth
{
    return [self.text sizeWithFont:self.font].width + (self.cornerRadius * 2.0);
}
#pragma mark -----------------
#pragma mark Textfield delegate
- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    // get the contect
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //now draw the rounded rectangle
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 0.0);
    
    //since I need room in my rect for the shadow, make the rounded rectangle a little smaller than frame
    CGRect rrect = CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetWidth(rect), CGRectGetHeight(rect));
    CGFloat radius = self.cornerRadius;
    // the rest is pretty much copied from Apples example
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect), maxy = CGRectGetMaxY(rrect);
    
    {
        //for the shadow, save the state then draw the shadow
        CGContextSaveGState(context);
        
        // Start at 1
        CGContextMoveToPoint(context, minx, miny);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx+radius, miny, minx+radius, midy, radius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, minx+radius, maxy, midx, maxy, radius);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx-radius, maxy, maxx-radius, midy, radius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, maxx-radius, miny, maxx, miny, radius);
        // Close the path
        CGContextClosePath(context);
        
        CGContextSetShadow(context, CGSizeMake(4,-5), 10);
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
        
        //for the shadow
        CGContextRestoreGState(context);
    }
    
    {
        // Start at 1
        CGContextMoveToPoint(context, minx, miny);
        // Add an arc through 2 to 3
        CGContextAddArcToPoint(context, minx+radius, miny, minx+radius, midy, radius);
        // Add an arc through 4 to 5
        CGContextAddArcToPoint(context, minx+radius, maxy, midx, maxy, radius);
        // Add an arc through 6 to 7
        CGContextAddArcToPoint(context, maxx-radius, maxy, maxx-radius, midy, radius);
        // Add an arc through 8 to 9
        CGContextAddArcToPoint(context, maxx-radius, miny, maxx, miny, radius);
        // Close the path
        CGContextClosePath(context);
        
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextSetRGBFillColor(context, 0.5, 0.5, 0.1, 1.0);
        
        // Fill & stroke the path
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end