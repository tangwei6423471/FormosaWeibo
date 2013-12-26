//
//  HomeViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "HomeViewController.h"
#import "SinaWeibo.h"
#import "WeiboModel.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MainViewController.h"
#import "DetailViewController.h"


@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"首頁";
        
    }
    return self;
}

//請求Server-->返回Json字符串-->解析成大字典-->遍歷數組(很多條微博)-->取出每一個微博字典-->創建微博Model
- (void)viewDidLoad
{
    [super viewDidLoad];
    //登入按钮
    
    
    UIButton * loginButton = [UIFactory createNavigationButton:@"登入"];
    [loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *loginItem = [[UIBarButtonItem alloc] initWithCustomView:loginButton];
    self.navigationItem.rightBarButtonItem = [loginItem autorelease];
    
    //取消按钮
    UIButton * logoutButton = [UIFactory createNavigationButton:@"登出"];
    [loginButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc] initWithCustomView:logoutButton];
    self.navigationItem.leftBarButtonItem = [logoutItem autorelease];
    

    
    
    
    //隱藏tableView
    self.tableView.hidden = YES;
    //refreshDelegate
    self.tableView.refreshDelegate = self;
    
    //判断是否認證
    if (self.sinaweibo.isAuthValid) {
        //加載微博列表数据
        [self loadWeiboData];
    }
    
    
    
 

}
#pragma mark - load Data
//加載微博數據
- (void)loadWeiboData {
    //顯示加載提示 ios自帶的
    //[super showLoading:YES];
    //顯示加載提示 HUD
    [super showHUD:@"正在載入..." isDim:NO];
    
    //請求20條微博  params-請求幾條微博
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"20" forKey:@"count"];
    
     SinaWeiboRequest *request = [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
     request.tag=100;
}
//--------------------下拉刷新部份--------------------
//下拉刷新時調用的方法,獲取數據
- (void)LoadNewWeiboData {
    NSString *topId=@"";
    //判斷原_data有無資料
    if (_data.count>0) {
        //取第一個,第一個為較新的微博
        WeiboModel *topWeibo= [_data objectAtIndex:0];
        topId = [topWeibo.weiboId stringValue];
    }
   //since_id:若請求此參數,則返回ID比since_id大的微博(即是比since_id新的微博)
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",topId,@"since_id",nil ];
    
    SinaWeiboRequest *request =[self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                            params:params
                        httpMethod:@"GET"
                          delegate:self];
    //利用tag值判斷是否為新微博
    request.tag=101;
}

//加載更多微博
-(void)loadMoreWeiboData
{
    NSString *lastId=@"";
    //判斷原_data有無資料
    if (_data.count>0) {
        //取最後一個,最後一個為較舊的微博
        WeiboModel *lastWeibo= [_data lastObject];
        lastId = [lastWeibo.weiboId stringValue];
    }
    //max_id:若請求此參數,則返回ID比max_id舊的微博(即是比max_id舊的微博)
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"20",@"count",lastId,@"max_id",nil ];
    
    SinaWeiboRequest *request =[self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
                                                       params:params
                                                   httpMethod:@"GET"
                                                     delegate:self];
    //利用tag值判斷是否為請求舊微博
    request.tag=102;

}
//加載更多-資料下載完成時調用
- (void)afterLoadMoreData:(NSDictionary *)result
{
    NSArray *statues = [result objectForKey:@"statuses"];
    //存放Weibo Model
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    //遍歷數組 ,每個元素是一個微博字典
    for (NSDictionary *statuesDic in statues) {
        
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    if (weibos.count> 0) {
        //去除第一條重複的資料 ,因為max_id返回ID小於或"等於"max_id的微博
        [weibos removeObjectAtIndex:0];
    }
 
    
    [_data addObjectsFromArray:weibos];
    //刷新UI
    //如果statues.count大於20表示有舊微博
    if (statues.count >= 20 ) {
        self.tableView.isMore = YES;
    }else
    {
        self.tableView.isMore = NO;
    }
    self.tableView.data = _data;
    [self.tableView reloadData];
    
}

//------------------BaseTableView delegate------------------
#pragma mark - BaseTableView delegate
//下拉事件
- (void)refreshDown:(BaseTableView *)tableView
{
    [self LoadNewWeiboData];
}
//上拉事件
- (void)refreshUp:(BaseTableView *)tableView
{
    //加載更多的舊微博
    [self loadMoreWeiboData];
    
    
}
//選中單元格事件
- (void)didSelectRowAtIndexPath:(BaseTableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
        DetailViewController *detail = [[DetailViewController alloc] init];
        //賦給數據
        detail.weiboModel = [_data objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    
        //清除選中效果
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
//------------------BaseTableView delegate End------------------
#pragma mark - UI
-(void)showNewWeiboCount:(int)aCount
{
    if (_barView ==nil) {
        _barView = [(ThemeImageView *)[UIFactory createImageView:@"timeline_new_status_background.png"] retain ];
        _barView.leftCapWidth = 5;
        _barView.topCapWidth = 5;
        
        UIImage *image = [_barView.image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        _barView.image= image;
        _barView.frame = CGRectMake(5, -40, ScreenWidth-10, 40);
        
        [self.view addSubview:_barView];
        
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectZero];
        lable.tag = 2013;
        lable.font = [UIFont systemFontOfSize:16.0f];
        lable.textColor = [UIColor whiteColor];
        lable.backgroundColor = [UIColor clearColor];
        [_barView addSubview:lable];
        [lable release];
    }
    
    if (aCount > 0) {
        UILabel *lable= (UILabel*)[ _barView viewWithTag:2013];
        lable.text = [NSString stringWithFormat:@"%d條新微博",aCount];
        [lable sizeToFit];
        //置中
        lable.origin = CGPointMake((_barView.width-lable.width)/2, (_barView.height-lable.height)/2);
        
        //動畫呈現 使用block方式
        [UIView animateWithDuration:0.6
        animations:^
        {
            //從上滑下的動畫
            //top為 y座標
            _barView.top = 5;
        }
        completion:^(BOOL finished)
        {
            //收起的動畫
            if (finished) {
                
                [UIView beginAnimations:nil context:nil];
                //延遲一秒執行
                [UIView setAnimationDelay:1];
                [UIView setAnimationDuration:0.6];
                _barView.top = -40;
                [UIView commitAnimations];
            }
            
        }];
        
        //播放提示聲音
        //1.導入audiotoolbox庫
        //聲音文件路徑
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
        NSURL *url= [NSURL fileURLWithPath:filePath];
        
        //系統會自己註冊ID
        SystemSoundID soundId;
        //將聲音文件轉為系統聲音
        AudioServicesCreateSystemSoundID((CFURLRef)url, &soundId);
        //播放系統聲音
        AudioServicesPlayAlertSound(soundId);
        
        
    }

}
-(void)refreshWeibo
{
    //下拉顯示加載
    [self.tableView showRefreshHeader];
    //加載新微博數據
    [self LoadNewWeiboData];

}



#pragma mark-SinaWeiboRequest delegate
//加載失敗
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"訪問失敗:%@",error);
}
//加載完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if (request.tag == 102) {
        [self afterLoadMoreData:result];
        return;
    }
    
    //停止加載的風火輪
    //[super showLoading:NO];
    //隱藏HUD
    //[super hideHUD];
    [super showHUDComplete:@"載入完成"];
    //result是Json大字典
    //statuses內是一個數組(多條微博)
    NSArray *statues = [result objectForKey:@"statuses"];
    //存放Weibo Model
    NSMutableArray *weibos = [NSMutableArray arrayWithCapacity:statues.count];
    //遍歷數組 ,每個元素是一個微博字典
    for (NSDictionary *statuesDic in statues) {
        
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:statuesDic];
        [weibos addObject:weibo];
        [weibo release];
    }
    
    //定義為全局的,可以提供TableView數據
    //全局要retain
    //_data=[weibos retain];
    //下拉加載時會更新數據,將下拉更新,weibo新數據 加上 舊的_data 完成添加
    if(_data !=nil)
    {
         [weibos addObjectsFromArray:_data];
    }
   
    [_data release];//將舊有的_data release
    _data = [weibos retain];
    
    //數據請求完,刷新TableView,重新調用TableView Delegate
    self.tableView.hidden = NO;
    //將數據交給tableView去展示
    self.tableView.data = _data;
    [self.tableView reloadData];
    
    //利用tag值判斷是否為新微博 tag 101 為有新微博的請求
    if (request.tag ==101) {
        //收起下拉刷新
        [self.tableView doneLoadingTableViewData];
        //[self doneLoadingTableViewData];
        
        //顯示新微博的動畫
        int count = statues.count;
        [self showNewWeiboCount:count];
        
        //清除未讀數的小圖     拿到 MainViewController這個Controller(要有上下關系才能這樣做)
        MainViewController *mainCtrl = (MainViewController *)self.tabBarController;
        [mainCtrl showBadge:NO];
    }
   
}


#pragma mark-ButtonAction
-(void)loginAction
{
    //登入
    [self.sinaweibo logIn];

}

-(void)logoutAction
{
    //登出
    [self.sinaweibo logOut];
    
}



#pragma mark - Memory
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [_tableView release];
    [super dealloc];
}

//測試代碼

/*
 - (IBAction)sender:(id)sender
 {
 NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"1",@"count", nil];
 [self.sinaweibo requestWithURL:@"statuses/home_timeline.json"
 params:params
 httpMethod:@"GET"
 delegate:self];
 
 
 
 }*/
@end
