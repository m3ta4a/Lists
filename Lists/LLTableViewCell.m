//
//  LLTableViewCell.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewCell.h"


@implementation LLTableViewCell

@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil)
        return nil;
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(15,0,self.frame.size.width-50, self.frame.size.height)];
    self.textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textColor = [UIColor blackColor];

    [self addSubview:self.textField];



    //    if (configToggle)
    //  cell.textField.font = [UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
    //    else
    self.textField.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];

    // Don't use textLabel, use textField (editable)
    self.textLabel.hidden = YES;
    self.textLabel.enabled = NO;
    
    return self;
}

- (void)resizeToFitTextExactly {
    CGFloat width;
    width = [self.textField.text sizeWithFont:self.textField.font].width;
    CGRect frame = self.textField.frame;
    float _width = MAX(width+2*ITEM_TEXT_MARGIN, 50);
    
    self.textField.frame = CGRectMake(frame.origin.x, frame.origin.y,
                              _width, frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

-(void)drawRect:(CGRect)rect
{
    float t = 215.0/255.0; // top
    float b = 199.0/255.0; // bottom
    float a = 0.35; // alpha
    CGFloat colors [] = {
        t, t, t, a,
        b, b, b, a
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
