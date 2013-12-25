//
//  BaseViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "UIFactory.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Navigation Bar的返回按鈕
    [self backButton];
}

//-------------Navigation Bar的返回按鈕-------------
-(void)backButton
{
    
    //push進去的視圖大於1,才會有返回按鈕
    NSArray *viewControllers = self.navigationController.viewControllers;
	if (self.isBackButton &&viewControllers.count > 1) {
        UIButton *button = [UIFactory createButton:@"navigationbar_back.png" highlighted:@"navigationbar_back_highlighted.png"];
        button.frame = CGRectMake(0, 0, 24, 24);
        //按下時出現Highlighted效果
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem=[[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem= [backItem autorelease];
    }

}
-(void)backAction:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//-------------Navigation Bar的返回按鈕 End-------------

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(SinaWeibo *)sinaweibo
{
    //返回AppDelegate內的sinaweibo Object
    AppDelegate *appDelegate= (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate.sinaweibo;
}


//複寫setTitle 改變title顏色
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    //IOS 7.0 本身字體就為黑色 ,所以7.0以下的才要改變
    if(DeviceIOSVersion <= 7.0)
    {
        //UILabel *titleLable= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UILabel *titleLable =[UIFactory createLable:kNavigationBarTitleLabel];
        titleLable.font = [UIFont boldSystemFontOfSize:18.0f];
        titleLable.backgroundColor = [UIColor clearColor];
        //titleLable.textColor = [UIColor blackColor];
        titleLable.text=self.title;
        [titleLable sizeToFit];//依照內容自動適應Frame的大下
        self.navigationItem.titleView = titleLable;
        //類方法會自動加入自動釋放池,所以這裡不需release
        //[titleLable release];
    }
    
}
//-------------------加載提示--------------
- (void)showLoading:(BOOL)show
{
    //因為會被多次調用,所以要判斷
    if (_loadView == nil) {
        _loadView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-20-44-49)/2, ScreenWidth, 20)];
        //風火輪視圖
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_loadView addSubview:activityView];
        
        //正在加載的Lable
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在載入...";
        loadLabel.font = [UIFont boldSystemFontOfSize:16.0];
        loadLabel.textColor =[UIColor blackColor];
        [loadLabel sizeToFit];
        [_loadView addSubview:loadLabel];
        
        loadLabel.left = (ScreenWidth - loadLabel.width)/2;
        activityView.right = loadLabel.left-5;
        [loadLabel release];
        [activityView release];
        
        
        
    }
    
    if (show) {
        [self.view addSubview:_loadView];
    }else
    {
        [_loadView removeFromSuperview];
    
    }

}
//-------------------加載提示 End--------------

//--------------------HUD---------------------
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
   self.hud =  [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   self.hud.labelText = title ;
   self.hud.dimBackground = isDim; //蓋住視圖,不讓別人點擊

}

//操作完成的提示
- (void)showHUDComplete:(NSString *)title
{
    //圖片可以自己設
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //顯示模式設為自定義
    self.hud.mode =MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    //延遲1秒隱藏
    [self.hud hide:YES afterDelay:1];

}

- (void)hideHUD
{
    [self.hud hide:YES];

}

//--------------------HUD End------------------


@end
