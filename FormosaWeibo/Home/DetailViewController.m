//
//  DetailViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/17.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "CommentModel.h"
#import "CommentCell.h"


@interface DetailViewController ()

//私有的property

@property(nonatomic,retain)SinaWeiboRequest *request;

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"微博正文";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _initViews];

    self.tableView.refreshDelegate = self;

    //加載評論數據
    [self loadData];
}
//視圖要Disappear時 調用
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消請求
    [self.request disconnect];

}

-(void)_initViews
{   //高度先給0,因為weiboView 高度是會變的
    //創建表格的頭視圖
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    [tableHeaderView addSubview:self.userBarView];
    //加載用戶頭象
    NSString *userImageURL = _weiboModel.user.profile_image_url;
    [self.userImageView setImageWithURL:[NSURL URLWithString:userImageURL]];
    //圓角
    self.userImageView.layer.cornerRadius = 5;
    self.userImageView.layer.masksToBounds =YES;
    
    //加載用戶暱稱
    self.nickLabel.text = _weiboModel.user.screen_name;
    
    //微博視圖
    float h = [WeiboView getWeiboViewHeight:_weiboModel isSource:NO isDetail:YES];
    _weiboView = [[WeiboView alloc] initWithFrame:CGRectMake(10, _userBarView.bottom+10, ScreenWidth-20, h)];
    _weiboView.isDetail = YES;
    _weiboView.weiboModel = _weiboModel;
    
    [tableHeaderView addSubview:_weiboView];
    tableHeaderView.height = (self.userBarView.height+h);
    self.tableView.tableHeaderView = [tableHeaderView autorelease];
    

}


//請求評論數據
- (void)loadData
{
   NSString *weiboId = [_weiboModel.weiboId stringValue];
    if (weiboId.length == 0) {
        NSLog(@"微博ID為空");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:weiboId forKey:@"id"];
    //請求參數
    self.request = [self.sinaweibo requestWithURL:@"comments/show.json" params:params httpMethod:@"GET" delegate:self];


}
//請求完成
#pragma  mark - SinaWeiboRequest delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{

    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    self.data = comments;
    
    //刷新tableView
    self.tableView.data = comments;
    self.tableView.commentDic = result;
    [self.tableView reloadData];





}
//Todo:This TODO
#pragma mark - BaseTableView delegate
//下拉事件
- (void)refreshDown:(BaseTableView *)tableView
{
    //請求評論列表接口,參數是Since_id

    //收起下拉
      [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3];



}
//上拉事件
- (void)refreshUp:(BaseTableView *)tableView
{
   //請求下一頁評論列表,參數是Max_id

   //恢復上拉
   [tableView performSelector:@selector(setIsMore:) withObject:@YES afterDelay:3];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [_userBarView release];
    [_userImageView release];
    [_nickLabel release];
    [super dealloc];
}
@end
