//
//  LLTableViewCell.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLTableViewCell.h"

@implementation LLTableViewCell
@synthesize textField = _textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self == nil)
        return nil;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textFieldDidChange:(UITextField *)sender {
    CGFloat width;
    width = [sender.text sizeWithFont:sender.font].width;
    CGRect frame = sender.frame;
    float _width = MAX(width+2*ITEM_TEXT_MARGIN, 150);
    
    sender.frame = CGRectMake(frame.origin.x, frame.origin.y,
                              _width, frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

@end
