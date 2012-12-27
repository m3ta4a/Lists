//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define HEADER_TITLE_MARGIN 5

@class LLViewController;

@interface LLTableViewHeaderControl : UIControl

@property(nonatomic, strong) NSArray *Tags;
@property(nonatomic) CGPoint startLocation;
@property(nonatomic) CGPoint lastLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLViewController *)delegate;

- (void)textFieldDidChange:(UITextField *)sender;

- (void)oneFingerSwipeLeft:(UIPanGestureRecognizer *)recognizer;

- (void)resetTabs;

- (void)deviceOrientationDidChange:(id)sender;

@end