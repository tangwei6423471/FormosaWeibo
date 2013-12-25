//
//  MainViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "MessageViewController.h"
#import "ProfileViewController.h"
#import "MoreViewController.h"
#import "DiscoverViewController.h"
#import "BaseNavigationViewController.h"
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "UIFactory.h"
#import "AppDelegate.h"
@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	//初始化子控制器
    [self _initViewControllers];
    //設定自定義的Tabbar
    [self _initTabbarView];
    
    //隨時更新新微博,會有小圖標提示未讀數
    [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 初始化子控制器. 
-(void)_initViewControllers
{
    //初始化ViewController
    home =    [[HomeViewController alloc] init] ;//全局不需autorelease
    MessageViewController  *message = [[[MessageViewController alloc] init ] autorelease ];
    ProfileViewController  *profile = [[[ProfileViewController alloc] init] autorelease];
    MoreViewController     *more =    [[[MoreViewController alloc] init]autorelease ];
    DiscoverViewController *discover =[[[DiscoverViewController alloc] init] autorelease ];
    
    NSArray *views = @[home,message,profile,discover,more];
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    //使用迴圈方式初始化NavigationViewController
    for (UIViewController *viewController in views)
    {
      
        BaseNavigationViewController *nav=[[BaseNavigationViewController alloc] initWithRootViewController:viewController];
        //Tabbar 隱藏 部份 ,將每個Navigation 加上代理方法
        nav.delegate =self ;
        [viewControllers addObject:nav];
        [nav release];
        
    }
    
    //viewControllers給TabbarController
    self.viewControllers=viewControllers;


}
//設定自定義的Tabbar
-(void)_initTabbarView
{
    //隱藏系統自帶的Tabbar
    [self.tabBar setHidden:YES];
   // self.tabBarController.tabBar.hidden = YES;
    //判斷設備版本
    if(DeviceIOSVersion >=7.0)
    {
        //self.topLayoutGuide.length 自動計算Status Bar 的長度 (IOS7才能用)
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-self.topLayoutGuide.length, ScreenWidth, 49-self.topLayoutGuide.length) ];
        
    }else
    {
        _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-49-20, ScreenWidth, 49) ];
    }
     //_tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_background.png"]];
    //ThemeImageView *backgroundImage = [[ThemeImageView alloc] initWithImageName:@"tabbar_background.png"];
    UIImageView *backgroundImage = [UIFactory createImageView:@"tabbar_background.png"];
    
    backgroundImage.frame=_tabbarView.bounds;
    [_tabbarView addSubview:backgroundImage];
    [self.view addSubview:_tabbarView];
    //類方法會自動加入自動釋放池,所以這裡不需release
    //[backgroundImage release];
  
    
    NSArray *background=@[@"tabbar_home.png",@"tabbar_message_center.png",@"tabbar_profile.png",@"tabbar_discover.png",@"tabbar_more.png"];
    
    NSArray *backgroundHighlight=@[@"tabbar_home_highlighted.png",@"tabbar_message_center_highlighted.png",@"tabbar_profile_highlighted.png",@"tabbar_discover_highlighted.png",@"tabbar_more_highlighted.png"];
    
    for (int i=0; i<background.count; i++)
    {
        NSString *backImage= background[i];
        NSString *highlightImage=backgroundHighlight[i];
        
        //UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
        //ThemeButton *button=[[ThemeButton alloc] initWithImage:backImage highlighted:highlightImage];
        
        //工廠模式創建Button,如果未來想擴展或是不想要ThemeBotton,只需改UIFactory
        UIButton *button= [UIFactory createButton:backImage highlighted:highlightImage];
        float itemWidth= ScreenWidth/5;//5個按鈕
        
        
        //(itemWidth-30)/2 X座標,位子置中
        //(i*itemWidth) 個數
        //(49-30)/2   y座標,位子置中
        //圖片置中公式:(按鈕大小-圖片大小)/2
        button.frame=CGRectMake((itemWidth-30)/2+(i*itemWidth), (49-30)/2, 30, 30);
        button.tag=i;
        //[button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        //[button setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
        
        
        
        
    }
    

}



- (void)selectedTab:(UIButton *)button
{   //   判斷是否為重複點擊                    僅限第一個按鈕有這作用
    if (self.selectedIndex == button.tag && button.tag ==0 ) {
        //自動下拉加載微博(不用自己拉)
        [home refreshWeibo];
    }
    
    self.selectedIndex=button.tag;
    
    

}
//-------------------微博 未讀數部份-----------------
- (void)timeAction:(NSTimer *)timer
{
    //網路請求
    [self loadUnReadData];
    
}

#pragma mark - UI

- (void)refreshUnReadView:(NSDictionary *)result
{
    if (_badgeView==nil) {
        _badgeView = [[UIFactory createImageView:@"main_badge.png"] retain];
        //64 第一個tabbar區域
        _badgeView.frame = CGRectMake(64-20, 5, 20, 20);
        [_tabbarView addSubview: _badgeView];
        
        UILabel *badgeLable =[[UILabel alloc] initWithFrame:_badgeView.bounds];
        badgeLable.backgroundColor = [UIColor clearColor];
        badgeLable.textAlignment = NSTextAlignmentCenter;
        badgeLable.font = [UIFont boldSystemFontOfSize:13.0f];
        badgeLable.textColor =[ UIColor purpleColor];
        badgeLable.tag = 100;
        [_badgeView addSubview:badgeLable];
        [badgeLable release];

    }
   NSNumber *status = [result objectForKey:@"status"];
    //NSNumber 轉為int 類型
   int unRead = [status intValue];
    NSLog(@"未讀數:%d",unRead);
    if (unRead > 0) {
        _badgeView.hidden = NO;
        if(unRead >=100 )
        {
            //如果未讀數為100以上只顯示99
            unRead =99;
        }
        
        UILabel *badgeLabel = (UILabel *)[_badgeView viewWithTag:100];
        badgeLabel.text = [NSString stringWithFormat:@"%d",unRead];
        
    }else
    {
        _badgeView.hidden = YES;
    
    }

}
- (void)showBadge:(BOOL)show
{
    _badgeView.hidden = !show;
    
}
#pragma mark - data

//請求未讀數
- (void)loadUnReadData
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    SinaWeibo *sinaweibo= appDelegate.sinaweibo;
    NSString *userId = sinaweibo.userID;
    [sinaweibo requestWithURL:@"remind/unread_count.json" params:nil httpMethod:@"GET" delegate:self];
    
    
}
//請求失敗
- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"網路請求失敗%@",error);
}

//請求完成
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    //刷新未讀視圖
    [self refreshUnReadView:result];
    
}



//-------------------微博 未讀數部份 End-----------------

//-------------------Tabbar 隱藏部份-----------------
//是否顯示Tabbar
- (void)showTabbarTool:(BOOL)show
{
    [UIView animateWithDuration:0.35 animations:^{
        if (show) {
            _tabbarView.left= 0 ;
            
        }else
        {
            _tabbarView.left = -ScreenWidth;
        }

    }];
    
    for(UIView *subView in self.view.subviews)
    {
        //NSClassFromString由類名找出 ,給類名即可
        //UITransitionView為nav的私有類
        if([subView isKindOfClass:NSClassFromString(@"UITransitionView")])
        {
            if(!show)
            {
                if (DeviceIOSVersion >= 7.0) {
                    subView.height =ScreenHeight -self.topLayoutGuide.length;

                }else
                {
                     subView.height =ScreenHeight - 20;
                }
               
                
            }else
            {
                if (DeviceIOSVersion >= 7.0) {
                    
                    subView.height =ScreenHeight -self.topLayoutGuide.length -self.bottomLayoutGuide.length;

                
                    
                }else
                {
                    
                    subView.height =ScreenHeight -20-49;

                
                }
                
                
            

            }
        }
    }

}
#pragma mark - UINavigationControllerDelegate
//push到下個視圖時會執行的協議方法
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    //如果Navigation擁有2個視圖代表push了視圖
    int count = navigationController.viewControllers.count;
    
    if (count ==2)
    {
        //隱藏Tabbar
        [self showTabbarTool:NO];
    }
    else if (count ==1)
    {
        //顯示Tabbar
        [self showTabbarTool:YES];
    }
    

}

//-------------------Tabbar 隱藏部份 End-----------------



@end
