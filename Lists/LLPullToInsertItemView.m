//
//  LLPullToInsertNewItemView.m
//  Lists
//
//  Created by Jake Van Alstyne on 1/19/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import "LLPullToInsertItemView.h"

@implementation LLPullToInsertItemView

@synthesize status = _status;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)setStatus:(LLPullToInsertItemStatus)newStatus animated:(BOOL) animated {
	if (_status == newStatus) return;
	switch (newStatus) {
		case kPullStatusReleaseToReload:
//			statusLabel.text = NSLocalizedString(@"Release to refresh...", @"label");
			
			break;
		case kPullStatusPullDownToReload:
//			statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"label");
			
			break;
		case kPullStatusLoading:
//			statusLabel.text = NSLocalizedString(@"Loading...", @"label");
  
			break;
		default:
			break;
	}
	_status = newStatus;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
