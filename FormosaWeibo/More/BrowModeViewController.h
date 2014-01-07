//
//  BrowModeViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/7.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "BaseViewController.h"

@interface BrowModeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
