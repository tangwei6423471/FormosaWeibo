//
//  BaseTableView.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/23.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseTableView.h"
#import "HomeViewController.h"
@implementation BaseTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self _initViews];
    
    }
    return self;
}

//xib創建會掉這個進行init
-(void)awakeFromNib
{
    [self _initViews];

}

-(void)_initViews
{

    
    self.delegate = self;
    self.dataSource = self;
    
    //創建下拉刷新
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    //預設為開啟
    self.refreshHeader =YES;
    [_refreshHeaderView release];


}

-(void)setRefreshHeader:(BOOL)refreshHeader
{
    _refreshHeader = refreshHeader;
    
    if (_refreshHeader) {
        
       [self addSubview:_refreshHeaderView];
        
    }else
    {
        [_refreshHeaderView removeFromSuperview];
    
    }

}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify] autorelease];
    }
    return cell;
    
}
//----------------------下拉刷新Delegate-------------------
#pragma mark - 下拉刷新Delegate
//Data Source Loading / Reloading Methods
- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}
//收起下拉刷新(會用到)
- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}



#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉手指放开时调用 (會用到)
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //respondsToSelector判断是否實現了某方法
    //調用代理對象的下拉協議方法
    if ([self.refreshDelegate respondsToSelector:@selector(refreshDown:)]) {
           [self.refreshDelegate refreshDown:self];
    }
 
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}
//----------------------下拉刷新Delegate End-------------------

@end
