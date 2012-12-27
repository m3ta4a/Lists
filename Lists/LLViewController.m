//
//  LLViewController.m
//  Lists
//
//  Created by Jake Van Alstyne on 12/26/12.
//  Copyright (c) 2012 EggDevil. All rights reserved.
//

#import "LLViewController.h"

@interface LLViewController ()


@end

@implementation LLViewController

@synthesize dataSrc = _dataSrc;
@synthesize header = _header;

- (void)viewDidLoad {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1; // Hard code 1 section (Apple's header makes for a sticky title bar)
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
#pragma unused(tv)
#pragma unused(indexPath)
    UITableViewCell *cell;

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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;

    if (!self.header)
        self.header = [[LLTableViewHeaderControl alloc] initWithFrame:CGRectMake(0.0, 0.0, screenWidth, 44.0)
                                                          andDelegate:self];

    return self.header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:.866
                                           green:.866
                                            blue:.866
                                           alpha:1.0];
}

@end
