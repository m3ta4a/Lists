//
//  LLTableViewKeyboardDismisser.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/1/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//
// from http://stackoverflow.com/questions/9246509/how-to-dismiss-uikeyboardtypenumberpad/9288516#9288516

#import <UIKit/UIKit.h>

@interface LLTableViewKeyboardDismisser : UIView
@property (nonatomic, assign) IBOutlet UIView *view; // weak if iOS5 only

-(id)initWithView:(UIView *)view;

@end
