//
//  MainViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"

@class HomeViewController;
@interface MainViewController : UITabBarController<SinaWeiboRequestDelegate,UINavigationControllerDelegate>
{
    UIView *_tabbarView;
    UIImageView *_badgeView;
    HomeViewController *home;
   


}



/**
 *  是否顯示微博未讀數
 *
 *  @param show Yes or No
 */
- (void)showBadge:(BOOL)show;

/**
 *  是否顯示Tabbar
 *
 *  @param show Yes or No
 */
- (void)showTabbarTool:(BOOL)show;

@end
