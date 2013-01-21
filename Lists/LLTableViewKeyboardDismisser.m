//
//  LLTableViewKeyboardDismisser.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/1/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLTableViewKeyboardDismisser.h"

@implementation LLTableViewKeyboardDismisser {
    UITapGestureRecognizer *tapGR;
}
@synthesize view = _view;
-(id)initWithView:(UIView *)view{
    if ((self = [super initWithFrame:CGRectMake(0, 0, 0, 0)])){
        _view = view;
        tapGR = [[UITapGestureRecognizer alloc] initWithTarget:_view action:@selector(endEditing:)];
        // Pass the tap through to the UITableView
        tapGR.cancelsTouchesInView = NO;
    }
    return self;
}
-(void)didMoveToWindow{ // When the accessory view presents this delegate method will be called
    [super didMoveToWindow];
    if (self.window){ // If there is a window it is now visible, so one of it's textfields is first responder
        [_view addGestureRecognizer:tapGR];
    }
    else { // If there is no window the textfield is no longer first responder
        [_view removeGestureRecognizer:tapGR];
    }
}
@end
