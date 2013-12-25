//
//  BaseViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "MBProgressHUD.h"
@interface BaseViewController : UIViewController<SinaWeiboRequestDelegate>
{
    UIView *_loadView;
    

}

@property(nonatomic,assign)BOOL isBackButton;
@property(nonatomic,retain)MBProgressHUD *hud;
- (SinaWeibo *)sinaweibo;
//系統自帶的加載提示
- (void)showLoading:(BOOL)show;

//-------------HUD----------
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;
//操作完成的提示
- (void)showHUDComplete:(NSString *)title;
- (void)hideHUD;
//-------------HUD End------
@end
