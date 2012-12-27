//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "LLTableViewHeaderControl.h"


@implementation LLTableViewHeaderControl

@synthesize headerLabel = _headerLabel;
@synthesize startLocation = _startLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLViewController *)delegate {

    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    self.backgroundColor = [UIColor blackColor];

    self.headerLabel = [[UITextField alloc] initWithFrame:CGRectZero];
    self.headerLabel.backgroundColor = [UIColor redColor];
    self.headerLabel.opaque = YES;
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.font = [UIFont boldSystemFontOfSize:20];
    self.headerLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.headerLabel.textAlignment = NSTextAlignmentCenter;

    self.headerLabel.text = @"New List";
    CGFloat width = [self.headerLabel.text sizeWithFont:self.headerLabel.font].width;

    self.headerLabel.frame = CGRectMake((frame.size.width - width) / 2 - HEADER_TITLE_MARGIN,
            0, width + 2 * HEADER_TITLE_MARGIN, 44);

    self.headerLabel.delegate = (id) delegate;
    [self.headerLabel addTarget:self action:@selector(textFieldDidChange:)
               forControlEvents:UIControlEventEditingChanged];

    UIPanGestureRecognizer *oneFingerSwipeLeft;
    oneFingerSwipeLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];

    [self addGestureRecognizer:oneFingerSwipeLeft];

    [self addSubview:self.headerLabel];

    return self;
}

- (void)textFieldDidChange:(id)sender {
    CGFloat width;
    width = [self.headerLabel.text sizeWithFont:self.headerLabel.font].width;
    self.headerLabel.frame = CGRectMake((self.frame.size.width - width) / 2 - HEADER_TITLE_MARGIN,
            0, width + 2 * HEADER_TITLE_MARGIN, 44);
}

- (void)oneFingerSwipeLeft:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startLocation = [recognizer locationInView:self];
        self.lastLocation = self.startLocation;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint nextLocation = [recognizer locationInView:[self superview]];
        CGFloat dx = nextLocation.x - self.lastLocation.x;
        CGFloat dy = nextLocation.y - self.lastLocation.y;

        CGRect frame_ = self.frame;
        frame_.origin.x = self.frame.origin.x + dx;
        self.frame = frame_;

        self.lastLocation = nextLocation;


        NSLog(@"Start, Stop: %f %f, %f %f", self.startLocation.x, self.startLocation.y, nextLocation.x, nextLocation.y);
    }
}
@end