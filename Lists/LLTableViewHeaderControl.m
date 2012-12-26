//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LLTableViewHeaderControl.h"


@implementation LLTableViewHeaderControl

-(LLTableViewHeaderControl*)initWithFrame:(CGRect)frame andDelegate:(NSObject*)delegate {

    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.opaque = YES;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];

    headerLabel.text = @"New List";
    CGFloat width =  [headerLabel.text sizeWithFont:headerLabel.font].width;

    headerLabel.frame = CGRectMake( (frame.size.width - width)/2, 0, width, 44);

    [self addSubview:headerLabel];

    [self addTarget:delegate action:@selector(handleTouchUpInsideHeader:event:) forControlEvents:UIControlEventTouchUpInside];

    return self;
}


@end