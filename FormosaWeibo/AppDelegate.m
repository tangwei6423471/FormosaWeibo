//
//  AppDelegate.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DDMenuController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "SinaWeibo.h"
#import "ThemeManager.h"
#import "MBProgressHUD.h"
#import "HomeViewController.h"
@implementation AppDelegate

//初始化使用者對象 (裝載使用者訊息)
-(void)_initSinaWeibo
{
    _sinaweibo= [[SinaWeibo alloc]initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self ];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //取出SinaWeiboAuthData的Value
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    //如果滿足條件,表示之前已經授權過
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        //取出令牌
        _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        //取出令牌的到期時間
        _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        //取出用戶ID
        _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }
    

}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //------設定StatusBarStyle--------------
    if (DeviceIOSVersion >= 7.0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    //------設定StatusBarStyle End----------
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    //-----初始化微博對象,裡面裝著使用者訊息,令牌---
    [self _initSinaWeibo];
    //-----初始化微博對象 End---------------
    
    //-----初始化主題-----
    [self _initTheme];
    //-----初始化主題 End-----
    
    
    //--------DDMenu設置--------
    self.mainCtrl = [[MainViewController alloc] init];
    LeftViewController *leftCtrl = [[LeftViewController alloc] init];
    RightViewController *rightCtrl = [[RightViewController alloc] init];
    DDMenuController *menu = [[DDMenuController alloc] initWithRootViewController:self.mainCtrl];
    [menu setRightViewController:rightCtrl];
    [menu setLeftViewController:leftCtrl];
    //--------DDMenu End--------
    
    
    self.window.rootViewController = menu;
    [menu release];
  
   
    return YES;
}


-(void)_initTheme
{
    NSString *themeName = [[NSUserDefaults standardUserDefaults] objectForKey:kThemeName];
    //使用者第一次執行時,themeName是還沒設置NSUserDefaults的,所以themeName沒有值
    if (themeName.length==0) {
        return;
    }
    
    [ThemeManager shareInstance].themeName=themeName;
    


}
#pragma mark-SinaWeibo delegate
//登入成功
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    //設置NSUserDefaults,         創建 KEY:SinaWeiboAuthData 並且寫入Value:authData
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"]; // 新增Key,Value到字典 語法類似 :[someclass  setValue:@"5566" forKey:@"天團"];
     //同步置本地文件 user的信息
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //發送登入成功的通知 Weibo列表刷新
    [[NSNotificationCenter defaultCenter] postNotificationName:kLoginSuccessNotification object:nil];
    

}
//註銷成功
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    //同步置本地文件
  [[NSUserDefaults standardUserDefaults] synchronize];
  //註銷成功的提示
    MBProgressHUD *hud= [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    //圖片可以自己設
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //顯示模式設為自定義
    hud.mode =MBProgressHUDModeCustomView;
    hud.labelText = @"註銷成功";
    //顯示1.5秒
    [hud hide:YES afterDelay:1.5];


}
@end
