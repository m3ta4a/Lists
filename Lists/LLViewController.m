//
//  LLViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLViewController.h"

#define LIST_TITLE_HEIGHT 28.0
#define DEFAULT_CELL_HEIGHT 50.0

@interface LLViewController ()


@end

@implementation LLViewController

@synthesize headerName = _headerName;
@synthesize dataSrc = _dataSrc;
@synthesize header = _header;

- (void)viewDidLoad
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewDidLoad];
    self.headerName = @"HEADER";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1; // Hard code 1 section (header makes for a nice titlebar)
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #pragma unused(tv)
    #pragma unused(indexPath)
    UITableViewCell *   cell;
    
    assert(tv == self.tableView);
    assert(indexPath != nil);

    NSString *identifier = @"Cell";

    cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell = [[LLTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    assert(cell != nil);

    cell.textLabel.text = @"Hello, World!";

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (!self.header)
    {
        LLTableViewHeaderControl* customView = [[LLTableViewHeaderControl alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 44.0) andDelegate:self];
        self.header = customView;
    }

    return self.header;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}
-(void)handleTouchUpInsideHeader:(id)sender event:(id)event
{
    for (UIView *view in self.header.subviews) {
        [view removeFromSuperview];
    }

    UILabel* headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor redColor];
    headerLabel.opaque = YES;
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:20];

    headerLabel.text = self.headerName;

    CGFloat width =  [headerLabel.text sizeWithFont:headerLabel.font].width;

    headerLabel.frame = CGRectMake( (self.header.frame.size.width - width)/2, 0, width, 44);

    [self.header addSubview:headerLabel];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor colorWithRed: .866
                                           green: .866
                                            blue: .866
                                           alpha: 1.0];
}

@end
