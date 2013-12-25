//
//  DetailViewController.h
//  FormosaWeibo
//  微博正文控制器
//  Created by Joey on 2013/12/17.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseViewController.h"
@class WeiboView;
@class WeiboModel;
@interface DetailViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    WeiboView *_weiboView;

    
}
//微博模型數據  這裡的weiboModel資料是由home視圖傳過來的
@property(nonatomic,retain)WeiboModel *weiboModel;
//存放微博Comment數據
@property(nonatomic,retain)NSArray *data;

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (retain, nonatomic) IBOutlet UIView *userBarView;
@property (retain, nonatomic) IBOutlet UIImageView *userImageView;
@property (retain, nonatomic) IBOutlet UILabel *nickLabel;

@end
