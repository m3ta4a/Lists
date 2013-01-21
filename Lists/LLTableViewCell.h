//
//  LLTableViewCell.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define ITEM_TEXT_MARGIN 5

@interface LLTableViewCell : UITableViewCell <UITextFieldDelegate>
enum styles{
    CustomStyleHeader
};

@property (nonatomic, strong) UITextField *textField;


- (void)resizeToFitTextExactly;


@end
