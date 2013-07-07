//
//  HistoryViewController.m
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HistoryViewController.h"
#import "Graph.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController {
    UITableViewCell *tappedCell;
    Graph* _graph;
}
int show = 0;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.3];
    self.tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.05];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0) {
        CGPoint offset = scrollView.contentOffset;
        offset.y = 0;
        scrollView.contentOffset = offset;
        NSLog(@"no scrolling lol");
        return;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self selectAtIndexPath:indexPath];
}

-(void)selectAtIndexPath:(NSIndexPath *) indexPath {

    if (tappedCell != nil) {
        tappedCell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.0];
    }
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    tappedCell = cell;
    [_graph showPoint:indexPath.row];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *cellIdentifier = @"HistoryCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UIButton *psi;
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];


        psi = [[UIButton alloc] initWithFrame:CGRectMake(190, 0, 128, 26)];
        psi.center = CGPointMake(250 ,cell.contentView.bounds.size.height/2);
        psi.titleLabel.textColor = [UIColor whiteColor];
        psi.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19];
        psi.layer.cornerRadius = 5;
        psi.tag = [indexPath row];
        psi.titleLabel.textAlignment = UITextAlignmentCenter;
        psi.layer.shadowColor = [[UIColor blackColor] CGColor];
        psi.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        psi.layer.shadowRadius = 2.0;
        psi.layer.shadowOpacity = 0.1;
        psi.layer.masksToBounds = NO;

        [psi addTarget:self action:@selector(buttonPressedAction:) forControlEvents:UIControlEventTouchUpInside];

        [cell addSubview:psi];
    }
    switch (show) {
        case 0: {

            break;
        }
    }
    int psi_t = [[[[self.data.sortedResults objectAtIndex:indexPath.row] objectForKey:@"psi"] objectForKey:@"3hr"] integerValue];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    psi.backgroundColor = [self.data getColorFromPSI:psi_t withAlpha:0.75];

    NSArray* split = [[self.data.sortedKeys objectAtIndex:indexPath.row] componentsSeparatedByString:@":"];
    int hour = [split[2] integerValue];
    NSString* suffix;
    if (hour == 0) {
        suffix = @"am";
        hour = 12;
    }
    else if (hour > 12) {
        hour = hour - 12;
        suffix = @"pm";
    }
    else {
        suffix = @"am";
        if (hour == 12) {
            suffix = @"pm";
        }
    }
    [psi setTitle:[NSString stringWithFormat:@"%d", psi_t] forState:UIControlStateNormal];
    cell.textLabel.text = [NSString stringWithFormat:@"%d%@", hour, suffix];



    return cell;


}
- (void)buttonPressedAction:(id)sender
{
    NSLog(@"pressed button");
    NSIndexPath *index = [NSIndexPath indexPathForItem:[sender tag] inSection:0];
    [self selectAtIndexPath:index];


}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    // If You have only one(1) section, return 1, otherwise you must handle sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.data sortedResults] count];
}
-(void)setData:(PSIData *)data {
    [super setData:data];
    NSLog(@"hello hello 12930-940849038403748374837##########");
    [self.tableView reloadData];
    int lastRowNumber = [self.tableView numberOfRowsInSection:0] - 1;
    NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
    _graph = [[Graph alloc] initWithData:data frame:CGRectMake(0, 0, 320, 312) controller:self];
    [self.graphScrollView addSubview:_graph];
    self.graphScrollView.scrollEnabled = NO;
    self.tableView.directionalLockEnabled = YES;
    self.tableView.bounces = NO;
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self selectAtIndexPath:ip];

}

@end
