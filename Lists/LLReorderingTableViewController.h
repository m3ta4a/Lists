//
//  LLReorderingTableViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 1/19/13.
//  Copyright (c) 2013 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CADisplayLink.h>
#import <QuartzCore/CALayer.h>
#import "LLTableView.h"

@class LLReorderingTableViewController;

@protocol LLReorderingTableViewControllerDelegate
@optional

- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didBeginDraggingAtRow:(NSIndexPath *)dragRow;
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController willEndDraggingToRow:(NSIndexPath *)destinationIndexPath;
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController didEndDraggingToRow:(NSIndexPath *)destinationIndexPath;
- (BOOL)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController shouldHideDraggableIndicatorForDraggingToRow:(NSIndexPath *)destinationIndexPath;

@end


@protocol LLReorderingTableViewControllerDraggableIndicators
@optional
// hate this, required to fix an iOS 6 bug where cell is hidden when going through normal paths to get a cell
// you must make a new cell to return this (use reuseIdent == nil), do not use dequeueResable
- (UITableViewCell *)cellIdenticalToCellAtIndexPath:(NSIndexPath *)indexPath forDragTableViewController:(LLReorderingTableViewController *)dragTableViewController;

@required
/*******
 *
 *	-addDraggableIndicatorsToCell:forIndexPath and -removeDraggableIndicatorsFromCell: are guaranteed to be called.
 *	-hideDraggableIndicatorsOfCell: is usually called, but might not be.
 *
 *	These work in tandem, so if your subclass overrides any of them it should override the others as well.
 *
 *******/

//	Customize cell to appear draggable. Will be called inside an animation block.
//	Cell will have highlighted set to YES, animated NO. (changes are to the selectedBackgroundView if it exists)
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController addDraggableIndicatorsToCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath;
//	You should set alpha of adjustments to 0 and similar. Will be called inside an animation block.
//	This should make the cell look like a normal cell, but is not expected to actually be one.
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController hideDraggableIndicatorsOfCell:(UITableViewCell *)cell;
//	Removes all adjustments to prepare cell for reuse. Will not be animated.
//	-hideDraggableIndicatorsOfCell: will probably be called before this, but not necessarily.
- (void)dragTableViewController:(LLReorderingTableViewController *)dragTableViewController removeDraggableIndicatorsFromCell:(UITableViewCell *)cell;

@end


@interface LLReorderingTableViewController : UIViewController <UIGestureRecognizerDelegate, LLReorderingTableViewControllerDraggableIndicators>  {
@protected
	UIPanGestureRecognizer *dragGestureRecognizer;
	UILongPressGestureRecognizer *longPressGestureRecognizer;
    
@private
	// Use setter/getter, not even subclasses should adjust this directly.
	CADisplayLink *timerToAutoscroll;
	CGFloat distanceThresholdToAutoscroll;
    
	CGFloat initialYOffsetOfDraggedCellCenter;
	CGPoint veryInitialTouchPoint;
    
	UITableViewCell *draggedCell;
	NSIndexPath *indexPathBelowDraggedCell;
    
	__weak id resignActiveObserver;
}

// default is YES. Removes or adds gesture recognizers to self.tableView.
@property (assign, getter=isReorderingEnabled) BOOL reorderingEnabled;
@property (nonatomic, strong) LLTableView *tableView;

- (BOOL)isDraggingCell;

@property (weak) NSObject <LLReorderingTableViewControllerDelegate> *dragDelegate; // nil by default
@property (weak) NSObject <LLReorderingTableViewControllerDraggableIndicators> *indicatorDelegate; // self by default

@end


