//
//  LLViewController.h
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataSource.h"
#import "LLTableViewCell.h"
#import "LLTableViewHeaderControl.h"

@interface LLViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, strong) LLDataSource *dataSrc;
@property (nonatomic, copy) NSString *headerName;
@property (nonatomic, strong) UIControl *header;

-(void)handleTouchUpInsideHeader:(id)sender event:(id)event;

@end

