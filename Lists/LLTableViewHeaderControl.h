//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>

@class LLTableViewController;

@interface LLTableViewHeaderControl : UIControl

@property(nonatomic, strong) NSArray *Tags;
@property(nonatomic) CGPoint startLocation;
@property(nonatomic) CGPoint lastLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLTableViewController *)delegate;

- (void)oneFingerSwipe:(UIPanGestureRecognizer *)recognizer;

- (void)resetTabs;

- (void)deviceOrientationDidChange:(CGFloat)screenWidth;

@end