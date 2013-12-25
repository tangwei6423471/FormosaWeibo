//
//  BaseTableView.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/23.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
@class BaseTableView;
//BaseTableViewRefreshDelegate
@protocol BaseTableViewRefreshDelegate <NSObject>
@optional
//下拉事件
- (void)refreshDown:(BaseTableView *)tableView;
//上拉事件
- (void)refreshUp:(BaseTableView *)tableView;
//選中單元格事件
- (void)didSelectRowAtIndexPath:(BaseTableView *)tableView indexPath:(NSIndexPath *)indexPath;
@end


@interface BaseTableView : UITableView<EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    


}
//BaseTableViewRefreshDelegate
@property(nonatomic,assign)id<BaseTableViewRefreshDelegate> refreshDelegate;
@property(nonatomic,retain)NSArray *data;

///是否需要下拉刷新
@property(nonatomic,assign)BOOL refreshHeader;

/**
 *  收起下拉刷新
 */
- (void)doneLoadingTableViewData;
@end
