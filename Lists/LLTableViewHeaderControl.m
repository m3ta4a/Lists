//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "LLTableViewHeaderControl.h"
#import "LLHeaderTextField.h"

@implementation LLTableViewHeaderControl

@synthesize startLocation = _startLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLViewController *)delegate {

    self = [super initWithFrame:frame];
    if (self == nil)
        return nil;

    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];

    self.backgroundColor = [UIColor blackColor];

    LLHeaderTextField *headerLabel = [[LLHeaderTextField alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.opaque = YES;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];
    headerLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    headerLabel.textAlignment = NSTextAlignmentCenter;

    headerLabel.text = @"New List";
    CGFloat width = [headerLabel.text sizeWithFont:headerLabel.font].width;

    CGRect newFrame = CGRectMake((frame.size.width - width) / 2 - HEADER_TITLE_MARGIN,
            0, width + 2 * HEADER_TITLE_MARGIN, 44);
    headerLabel.frame = newFrame;
    headerLabel.centerFrame = newFrame;
    headerLabel.delegate = (id) delegate;
    [headerLabel addTarget:self action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];

    self.Tags = [[NSArray alloc] initWithObjects:headerLabel, nil];

    [self addSubview:headerLabel];

    UIPanGestureRecognizer *oneFingerSwipeLeft;
    oneFingerSwipeLeft = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(oneFingerSwipeLeft:)];
    [self addGestureRecognizer:oneFingerSwipeLeft];


    return self;
}

- (void)textFieldDidChange:(UITextField *)sender {
    CGFloat width;
    width = [sender.text sizeWithFont:sender.font].width;
    sender.frame = CGRectMake((self.frame.size.width - width) / 2 - HEADER_TITLE_MARGIN,
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
        LLHeaderTextField *tf = [self.Tags objectAtIndex:i];
        tf.frame = tf.centerFrame;
    }


    [UIView commitAnimations];
}

- (void)deviceOrientationDidChange:(id)sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    self.frame = CGRectMake(0.0, 0.0, screenWidth, 44.0);
    for (int i = 0; i < [self.Tags count]; i++) {
        LLHeaderTextField *tf = [self.Tags objectAtIndex:i];
        CGFloat width = [tf.text sizeWithFont:tf.font].width;
        tf.centerFrame = CGRectMake((screenWidth - width) / 2 - HEADER_TITLE_MARGIN,
                0, width + 2 * HEADER_TITLE_MARGIN, 44);
    }
    [self resetTabs];
}
@end