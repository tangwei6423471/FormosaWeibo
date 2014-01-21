//
//  FriendShipsViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "FriendShipsViewController.h"
#import "UserModel.h"

@interface FriendShipsViewController ()
//下一頁的遊標值
@property (nonatomic,copy)NSString *nextCursor;
@end

@implementation FriendShipsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _data =[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //加載提示
    self.tableView.hidden = YES;
    [super showLoading:YES];
    
    self.tableView.refreshDelegate = self;
    //去除單元格分隔線
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //關注列表
    if (self.shipType == Attention)
    {
        self.title = @"關注列表";
        [self loadData:URL_FRIENDS];
        
    }else if(self.shipType == Fans)
    {
        self.title = @"粉絲列表";
        [self loadData:URL_FOLLOWERS];
    }
   
   
}

-(void)loadData:(NSString *)urlString
{
    
    if (self.userID.length == 0) {
        NSLog(@"用戶Id為空");
        return;
    }
    //接口升级后：uid与screen_name只能为当前授权用户，第三方微博类客户端不受影响；
    //NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:self.userID forKey:@"uid"];
    //這改為自己賬號的UID
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"3539732542" forKey:@"uid"];
    [params setObject:@"29" forKey:@"count"];
    //@"friendships/friends.json"
    [self.sinaweibo requestWithURL:urlString params:params httpMethod:@"GET" delegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - SinaWeiboRequest delegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSLog(@"%@",result);
    //記錄下一頁的遊標值
    self.nextCursor = [result objectForKey:@"next_cursor"];
    
    /* 結構:
      一個大數組裝多個小數組
     [
        ["用戶1","用戶2","用戶3"],
        ["用戶4","用戶5","用戶6"],
      ]
     
     
     */
    NSArray *usersArray = [result objectForKey:@"users"];
    //小數組
    NSMutableArray *array2D = nil;
    for (int i = 0; i<usersArray.count; i++)
    {
        //每被3整除(取餘數)就創建一個小的數組
        if (i % 3 == 0) {
            //滿足條件就創建
            array2D = [NSMutableArray arrayWithCapacity:3];
            [_data addObject:array2D];
        }
        
        NSDictionary *userDic =[usersArray objectAtIndex:i];
        UserModel *userModel = [[UserModel alloc] initWithDataDic:userDic];
        [array2D addObject:userModel];
        [userModel release];
        
    }
    if(usersArray.count >= 20)
    {
        self.tableView.isMore = YES;
    }else
    {
        self.tableView.isMore = NO;
    }
    
    self.tableView.data = _data;
    self.tableView.hidden = NO;
     [super showLoading:NO];
    [self.tableView reloadData];
    //收起下拉
    [self.tableView doneLoadingTableViewData];
    

}
#pragma mark - BaseTableView delegate
//下拉事件
- (void)refreshDown:(BaseTableView *)tableView
{   //清空數據

    if(_data != nil)
    {
        [_data removeAllObjects];
        
    }
   
    
    if (self.shipType == Attention)
    {
      [self loadData:URL_FRIENDS];

    }else if(self.shipType == Fans)
    {
        [self loadData:URL_FOLLOWERS];
    }
    
    
    NSLog(@"下拉");
    
}
//上拉事件
- (void)refreshUp:(BaseTableView *)tableView
{


}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
