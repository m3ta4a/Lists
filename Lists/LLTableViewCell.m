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
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width-50, self.frame.size.height)];
    self.textField.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textColor = [UIColor blackColor];
    
    [self addSubview:self.textField];
    
    self.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];


}

- (void)resizeToFitTextExactly {
    CGFloat width;
    width = [self.textField.text sizeWithFont:self.textField.font].width;
    CGRect frame = self.textField.frame;
    float _width = MAX(width+2*ITEM_TEXT_MARGIN, 50);
    
    self.textField.frame = CGRectMake(frame.origin.x, frame.origin.y,
                              _width, frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}
@end
