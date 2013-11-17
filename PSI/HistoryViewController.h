//
//  HistoryViewController.h
//  PSI
//
//  Created by Terence Tan on 4/7/13.
//  Copyright (c) 2013 ttwj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataViewController.h"
#import "MainViewController.h"

@interface HistoryViewController : DataViewController<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UIScrollView* graphScrollView;
@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property (nonatomic, strong) MainViewController* mainView;

@end
