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

@interface LLViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, strong) LLDataSource *dataSrc;

@end
