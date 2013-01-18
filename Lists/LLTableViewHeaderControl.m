//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "LLTableViewHeaderControl.h"
#import "LLHeaderTag.h"

@implementation LLTableViewHeaderControl

@synthesize startLocation = _startLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLTableViewController *)delegate {

    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    self.backgroundColor = [UIColor grayColor];

    float width = 25.;
    CGRect newFrame = CGRectMake((frame.size.width - width) / 2 - 5, 0, width + 2 * 5, frame.size.height);

    LLHeaderTag *headerLabel = [[LLHeaderTag alloc] initWithFrame:newFrame];

    self.Tags = [[NSArray alloc] initWithObjects:headerLabel, nil];

    [self addSubview:headerLabel];

    UIPanGestureRecognizer *oneFingerSwipe;
    oneFingerSwipe = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipe:)];
    [self addGestureRecognizer:oneFingerSwipe];

    return self;
}

- (void)oneFingerSwipe:(UIPanGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.startLocation = [recognizer locationInView:self];
        self.lastLocation = self.startLocation;
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint nextLocation = [recognizer locationInView:[self superview]];
        CGFloat dx = nextLocation.x - self.lastLocation.x;

        for (int i = 0; i < [self.Tags count]; i++) {
            UITextField *tf = [self.Tags objectAtIndex:(NSUInteger) i];
            CGRect frame_ = tf.frame;
            frame_.origin.x = frame_.origin.x + dx;
            tf.frame = frame_;
        }

        self.lastLocation = nextLocation;
        //NSLog(@"Start, Stop: %f %f, %f %f", self.startLocation.x, self.startLocation.y, nextLocation.x, nextLocation.y);
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded) {
        [self resetTabs];
    }
}

- (void)resetTabs {
    [UIView beginAnimations:nil context:NULL];

    for (int i = 0; i < [self.Tags count]; i++) {
        LLHeaderTag *tf = [self.Tags objectAtIndex:i];
        tf.frame = tf.centerFrame;
        [tf setNeedsDisplay];
    }

    [UIView commitAnimations];
}

- (void)deviceOrientationDidChange:(CGFloat)screenWidth {

    self.frame = CGRectMake(0.0, 0.0, screenWidth, 44.0);
    for (int i = 0; i < [self.Tags count]; i++) {
        LLHeaderTag *tf = [self.Tags objectAtIndex:i];
        CGFloat width = [tf.text sizeWithFont:tf.font].width;
        tf.centerFrame = CGRectMake((screenWidth - width) / 2 - 5,
                0, width + 2 * 5, 44);
    }
    [self resetTabs];
}
@end