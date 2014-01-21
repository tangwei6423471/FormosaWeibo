//
//  AppDelegate.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
@class MainViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate,SinaWeiboDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) MainViewController *mainCtrl;
@property (nonatomic,retain) SinaWeibo *sinaweibo;


@end
