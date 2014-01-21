//
//  CONSTS.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/4.
//  Copyright (c) 2013年 Joey. All rights reserved.
//
//定義紅


#ifndef FormosaWeibo_CONSTS_h
#define FormosaWeibo_CONSTS_h


#endif

////---------------------weibo OAuthu2.0-------------------------------
#define kAppKey @"3769558941"
#define kAppSecret @"310b02eaa7b7387c9201fff67f013b42"
#define kAppRedirectURI @"http://api.weibo.com/oauth2/default.html"

//color
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//---------------------主題-------------------------------
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kThemeListLabel @"kThemeListLabel"
//---------------------通知-------------------------------
//刷新微博通知
#define kReloadWeiboTableNotification @"kReloadWeiboTableNotification"
//登入成功的通知
#define kLoginSuccessNotification @"kLoginSuccessNotification"

//---------------------UserDefault keys-------------------------------
#define LargeMode 1  //大圖瀏覽模式
#define smallMode 2  //小圖瀏覽模式
#define kBrowMode @"kBrowMode"

//---------------------URL-------------------------------
#define URL_FRIENDS @"friendships/friends.json" //關注列表
#define URL_FOLLOWERS @"friendships/followers.json"  //粉絲列表
