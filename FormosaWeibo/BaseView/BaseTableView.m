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

    
    
    
    //創建下拉刷新
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    self.delegate = self;
    self.dataSource = self;
    //預設為開啟
    self.refreshHeader =YES;
    [_refreshHeaderView release];
    
    //------------------------------加載更多-------------------------
    //預設為開啟
    self.isMore =YES;
    //創建加載更多的按鈕
    //UIButton為類方法,會被autorelease,所以要retain下
    _moreButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    _moreButton.backgroundColor = [UIColor clearColor];
    _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
    [_moreButton setTitle:@"上拉加載更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
    [_moreButton addTarget:self action:@selector(loadMoreAction) forControlEvents:UIControlEventTouchUpInside];
    
    //風火輪視圖
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.frame= CGRectMake(90, 10, 20, 20);
    //stopAnimating 預設為隱藏
    [activityView stopAnimating];
    activityView.tag = 2013;
    [_moreButton addSubview:activityView];
    [activityView release];
    self.tableFooterView = _moreButton;
     //------------------------------加載更多 End-------------------------
    
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

-(void)setIsMore:(BOOL)isMore
{
    _isMore = isMore;
    
    if (isMore) {
        [_moreButton setTitle:@"上拉加載更多" forState:UIControlStateNormal];
    }else
    {
        [_moreButton setTitle:@"加載完成" forState:UIControlStateNormal];
        //禁用Button
        _moreButton.enabled = NO;
    }
    
    
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView stopAnimating];


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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.refreshDelegate respondsToSelector:@selector(didSelectRowAtIndexPath:indexPath:)]) {
        [self.refreshDelegate didSelectRowAtIndexPath:self indexPath:indexPath];
    }

}

//------------------------------加載更多 -------------------------
- (void)loadMoreAction
{
    [_moreButton setTitle:@"正在加載" forState:UIControlStateNormal];
    UIActivityIndicatorView *activityView = (UIActivityIndicatorView *)[_moreButton viewWithTag:2013];
    [activityView startAnimating];
    
    //調用代理方法 上拉的協議
    if ([self.refreshDelegate respondsToSelector:@selector(refreshUp:)]) {
        [self.refreshDelegate refreshUp:self];
    }


}
//------------------------------加載更多 End-------------------------


//----------------------下拉刷新 控件相關方法 Delegate-------------------
//顯示下拉加載
- (void)showRefreshHeader
{
    [_refreshHeaderView refreshLoading:self];
}


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

   // NSLog(@"偏移量:%f",scrollView.contentOffset.y);
   //NSLog(@"內容高度:%f",	scrollView.contentSize.height);
    
    //偏移量+scrollView.height(TableView的高度) =內容高度
    

    //上拉超出的尺寸
    float h= scrollView.contentOffset.y + scrollView.height - scrollView.contentSize.height;
    NSLog(@":%f",h);
    
    
    if ( h > 30 ) {
        [self loadMoreAction];
    }
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
