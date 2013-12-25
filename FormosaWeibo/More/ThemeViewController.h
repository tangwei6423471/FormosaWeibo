//
//  ThemeViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseViewController.h"

@interface ThemeViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_themes;
    
    
}


@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
