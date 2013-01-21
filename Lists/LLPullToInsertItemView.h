//
//  LLPullToInsertNewItemView.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/19/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	kPullStatusReleaseToReload = 0,
	kPullStatusPullDownToReload	= 1,
	kPullStatusLoading = 2
} LLPullToInsertItemStatus;

@interface LLPullToInsertItemView : UIView{
@private
	LLPullToInsertItemStatus _status;
}
@property (nonatomic, readonly) LLPullToInsertItemStatus status;

- (void)setStatus:(LLPullToInsertItemStatus)status animated:(BOOL)animated;

@end
