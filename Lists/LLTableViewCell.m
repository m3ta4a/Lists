//
//  LLTableViewCell.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewCell.h"


@implementation LLTableViewCell

@synthesize textView = _textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil)
        return nil;

    // Text field
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 0.0f, 0.0f)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    _textView.font = TEXT_INPUT_FONT;
    [self addSubview:_textView];
    
    // Don't use textLabel, use textView (editable)
    self.textLabel.hidden = YES;
    self.textLabel.enabled = NO;
    
    return self;
}
- (void) adjustTextInputHeightForText:(NSString*)text {

    [_textView sizeToFit];

    int width = (int)self.frame.size.width * 5/6;
    int height = [LLTableViewCell textViewSize:text forWidth:width].height+10; //magic value to keep it big enough

    [UIView animateWithDuration:.1f animations:^
     {
         CGSize fits = [_textView sizeThatFits:CGSizeMake(width, MAX(19,height))];
         CGRect frame = _textView.frame;
         frame.size.height = fits.height;
         frame.size.width = fits.width;
         _textView.frame = frame;
     } completion:^(BOOL finished)
     {

     }];
}
-(int)textViewWidth{
    return (int)self.frame.size.width*5/6;
}
- (CGSize)textViewSize{
    float fudgeFactor = 16.0;

    NSString *testString = @" ";
    if ([self.textView.text length] > 0)
        testString = self.textView.text;

    CGSize stringSize = [testString
                         sizeWithFont:TEXT_INPUT_FONT
                         constrainedToSize: CGSizeMake([self textViewWidth]-fudgeFactor, 9999)
                         lineBreakMode:NSLineBreakByWordWrapping];

    if ([self.textView.text hasSuffix:@"\n"])
        stringSize.height+=19;

    return stringSize;
}
+ (CGSize)textViewSize:(NSString*)text forWidth:(NSInteger)width{
    float fudgeFactor = 16.0;

    NSString *testString = @" ";
    if ([text length] > 0)
        testString = text;

    CGSize stringSize = [testString
                             sizeWithFont:TEXT_INPUT_FONT
                             constrainedToSize: CGSizeMake(width-fudgeFactor, 9999)
                             lineBreakMode:NSLineBreakByWordWrapping];

    if ([text hasSuffix:@"\n"])
        stringSize.height+=19;

    return stringSize;
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
