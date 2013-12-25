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
@property(nonatomic,retain)NSDictionary *commentDic;
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
//---------------------------TableView--------------------
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        //Xib創cell的方式
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];
        
    }
    cell.commentModel =  [_data objectAtIndex:indexPath.row];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *comment = [_data objectAtIndex:indexPath.row];
    float height = [CommentCell getCommentHeight:comment];
    return height +40 ;
}
//設置section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
//section的頭視圖設置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    //評論數Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blueColor];
    
    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"評論數:%d",value];
    [sectionHeaderView addSubview:countLabel];
    [countLabel release];
    
    return [sectionHeaderView autorelease];

}
//---------------------------TableView End--------------------

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
    self.commentDic =result;
    NSArray *array = [result objectForKey:@"comments"];
    
    NSMutableArray *comments = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dic in array) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDataDic:dic];
        [comments addObject:commentModel];
        [commentModel release];
    }
    
    self.data = comments;
    
    //刷新tableView
    [self.tableView reloadData];

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
