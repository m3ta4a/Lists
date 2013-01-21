//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>
#import "LLHeaderTag.h"
#import "LLListItemsViewController.h"

@class LLListItemsViewController;

@interface LLTabStackControl : UIControl <UITextFieldDelegate>

@property(nonatomic, strong) NSArray *Tags;
@property(nonatomic) CGPoint startLocation;
@property(nonatomic) CGPoint lastLocation;

- (LLTabStackControl *)initWithFrame:(CGRect)frame andDelegate:(LLListItemsViewController *)delegate;

- (void)oneFingerSwipe:(UIPanGestureRecognizer *)recognizer;

- (void)resetTabs;

- (void)deviceOrientationDidChange:(CGFloat)screenWidth;

@end