//
//  HomeViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseViewController.h"
#import "UIFactory.h"
#import "ThemeImageView.h"
#import "WeiboTableView.h"
@interface HomeViewController : BaseViewController<UITableViewDataSource,UITabBarDelegate,BaseTableViewRefreshDelegate>
{
    NSMutableArray *_data;

    ThemeImageView *_barView;
    
}

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

/**
 *  刷新微博
 */
-(void)refreshWeibo;


- (void)LoadNewWeiboData;

@end
