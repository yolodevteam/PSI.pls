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

@implementation HistoryViewController

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
    NSLog(@"yolo swag yolo232443434344343");
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.5];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"HistoryCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    NSArray* split = [[self.data.sortedKeys objectAtIndex:indexPath.row] componentsSeparatedByString:@":"];
    int hour = [split[2] integerValue];
    NSString* suffix;
    if (hour == 0) {
        suffix = @"am";
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
    cell.textLabel.text = [NSString stringWithFormat:@"%d%@", hour, suffix];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
    UILabel *psi = [[UILabel alloc] initWithFrame:CGRectMake(190, 2, 128, 26)];
    int psi_t = [[[[self.data.sortedResults objectAtIndex:indexPath.row] objectForKey:@"psi"] objectForKey:@"3hr"] integerValue];
    psi.text = [NSString stringWithFormat:@"%d", psi_t];
    psi.backgroundColor = [self.data getColorFromPSI:psi_t withAlpha:0.75];
    psi.layer.cornerRadius = 5;
    psi.textAlignment = UITextAlignmentCenter;
    [cell addSubview:psi];
    NSLog(@"no swag 420 %@", cell.textLabel.text);
    return cell;


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
    Graph* graph = [[Graph alloc] initWithData:data frame:CGRectMake(0, 0, 1280, 312) controller:self];
    [self.graphScrollView addSubview:graph];
}

@end
