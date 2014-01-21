//
//  ProfileViewController.h
//  FormosaWeibo
//  個人中心頁面
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseViewController.h"
#import "WeiboTableView.h"
@class UserView;

@interface ProfileViewController : BaseViewController<BaseTableViewRefreshDelegate>
{
    UserView *_userView;
    NSMutableArray *_requestArray;
}

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *userId;

@property (retain, nonatomic) IBOutlet WeiboTableView *tableView;

@end
