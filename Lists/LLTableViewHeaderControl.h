//
// Created by Jake on 12/26/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

#define HEADER_TITLE_MARGIN 5

@class LLViewController;

@interface LLTableViewHeaderControl : UIControl

@property(nonatomic, strong) UITextField *headerLabel;
@property(nonatomic) CGPoint startLocation;
@property(nonatomic) CGPoint lastLocation;

- (LLTableViewHeaderControl *)initWithFrame:(CGRect)frame andDelegate:(LLViewController *)delegate;

- (void)textFieldDidChange:(id)sender;

- (void)oneFingerSwipeLeft:(UIPanGestureRecognizer *)recognizer;

@end