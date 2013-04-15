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
@synthesize justCreated = _justCreated;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil)
        return nil;

    _justCreated = NO;

    // Text field
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(0.0f, 3.0f, 0.0f, 0.0f)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.scrollEnabled = NO;
    _textView.font = TEXT_INPUT_FONT;
    _textView.contentInset = UIEdgeInsetsZero;
    _textView.userInteractionEnabled = NO;
    _textView.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    _textView.autocorrectionType = UITextAutocorrectionTypeYes;

    [self addSubview:_textView];
    
    // Don't use textLabel, use textView (editable)
    self.textLabel.hidden = YES;
    self.textLabel.enabled = NO;
    
    return self;
}
- (void) adjustTextInputHeightForText:(NSString*)text andWidth:(NSInteger)width{

    [_textView sizeToFit];

    int height = [LLTableViewCell textViewSize:text forWidth:width].height;

    // This tests if text is only a single line,
    // if so the textView width shouldn't be wider than that line
    int shouldBeHeightOfSingleLine = [LLTableViewCell textViewSize:@"-" forWidth:[text sizeWithFont:TEXT_INPUT_FONT].width].height;
    if (height == shouldBeHeightOfSingleLine)
        width = [text sizeWithFont:TEXT_INPUT_FONT].width+17; //magic value. Seems to work.

    [UIView animateWithDuration:.1f animations:^
     {
         CGSize fits = [_textView sizeThatFits:CGSizeMake(width, MAX(19,height+10))]; //magic values. Seem to work.
         CGRect frame = _textView.frame;
         frame.size.height = fits.height;
         frame.size.width = fits.width;
         _textView.frame = frame;
     } completion:^(BOOL finished)
     {

     }];
}
- (CGSize)textViewSize{

    return [LLTableViewCell textViewSize:self.textView.text forWidth:self.textView.frame.size.width];
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
