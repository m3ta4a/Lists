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
#define TEXT_VIEW_WIDTH [[UIScreen mainScreen] bounds].size.width*5/6
#define TEXT_INPUT_FONT [UIFont systemFontOfSize:15]

@interface LLTableViewCell : UITableViewCell
enum styles{
    CustomStyleHeader
};

@property (nonatomic, strong) UITextView *textView;

-(int)textViewWidth;
+ (CGSize)textViewSize:(NSString*)text forWidth:(NSInteger)width;
- (void) adjustTextInputHeightForText:(NSString*)text;
//- (void)resizeToFitTextExactly;


@end
