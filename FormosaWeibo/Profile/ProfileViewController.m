//
//  ProfileViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "ProfileViewController.h"
#import "UserModel.h"
#import "UserView.h"
#import "WeiboTableView.h"
#import "WeiboModel.h"
#import "UIFactory.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"個人中心";
        _requestArray= [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //返回首頁按鈕
   UIButton *homeButton = [UIFactory createButton:@"tabbar_home.png" highlighted:@"tabbar_home_highlighted.png"];
    homeButton.frame = CGRectMake(0, 0, 34, 27);
    [homeButton addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:homeButton];
    self.navigationItem.rightBarButtonItem =[rightItem autorelease];
    
    
    _userView = [[UserView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
    self.tableView.refreshDelegate = self;
    self.tableView.tableHeaderView =_userView;
    //顯示加載提示
    self.tableView.hidden = YES;
    [super showLoading:YES];
 
   
    //加載用戶資料數據
    [self loadUserData];
    //加載微博列表數據
    [self loadWeiboData];
}

//請求用戶資料
-(void)loadUserData
{
    if (self.userName.length == 0 &&self.userId.length ==0) {
        NSLog(@"error:用戶暱稱為空");
        return;
    }
    
   
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    //userId 當前用戶id 在 MainViewController.h -> _initViewControllers 內給值
    if (self.userId.length != 0)
    {
        [params setObject:self.userId forKey:@"uid"];
    }else
    {
        [params setObject:self.userName forKey:@"screen_name"];
    }
    
    SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"users/show.json" params:params httpMethod:@"GET" delegate:self];
    request.tag = 100 ;
    
    [_requestArray addObject:request];

}

-(void)loadWeiboData
{
    
    if (self.userName.length == 0 &&self.userId.length ==0) {
        NSLog(@"error:用戶暱稱為空");
        return;
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //userId 當前用戶id 在 MainViewController.h -> _initViewControllers 內給值
    if (self.userId.length != 0)
    {
        [params setObject:self.userId forKey:@"uid"];
    }else
    {
        [params setObject:@"xincode9" forKey:@"screen_name"];
    }
    //此api Weibo以棄用 現在只能看自己帳號的微博列表
     SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/user_timeline.json" params:params httpMethod:@"GET" delegate:self];
     request.tag = 101 ;
    [_requestArray addObject:request];



}
#pragma mark - SinaWeiboRequest delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    if (request.tag == 100) {
        UserModel *userModel = [[UserModel alloc] initWithDataDic:result];
        _userView.user = userModel;
        [userModel release];
        //LayoutsubView 只會在創建視圖時候調用一次(這時還沒有資料) ,所以這裡手動調用一次
        [_userView setNeedsLayout];
        //隱藏加載提示
        self.tableView.hidden =NO;
        [super showLoading:NO];
    }else if(request.tag == 101)
    {
      
        NSArray *statuses = [result objectForKey:@"statuses"];
        NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statuses.count];
        for (NSDictionary *dic in statuses)
        {
            WeiboModel *weiboModel = [[WeiboModel alloc] initWithDataDic:dic];
            [weibos addObject:weiboModel];
            [weiboModel release];
        }
        self.tableView.data = weibos;
        
        if (weibos.count >=16)
        {
            self.tableView.isMore = YES;
        }else
        {
            self.tableView.isMore = NO;
        
        }
       
        [self.tableView reloadData];
       
        
    }
   
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    for (SinaWeiboRequest *request in _requestArray) {
        //取消請求
        [request disconnect];
    }

}

//下拉事件
- (void)refreshDown:(BaseTableView *)tableView
{
    NSLog(@"下拉");
    
}
//上拉事件
- (void)refreshUp:(BaseTableView *)tableView
{
    NSLog(@"上拉");
}

-(void)goHome
{
    //pop到首頁
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
