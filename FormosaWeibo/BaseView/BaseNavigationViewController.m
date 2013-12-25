//
//  BaseNavigationViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "BaseNavigationViewController.h"
#import "ThemeManager.h"
@interface BaseNavigationViewController ()

@end

@implementation BaseNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //註冊監聽:監聽主題切換的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
 
    //改變title顏色
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:UITextAttributeTextColor]];
    //改變Navigationbar顏色
    //self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    [self loadThemeImage];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//當切換主題時,會調用的方法
-(void)themeNotification:(NSNotification *)notification
{
    [self loadThemeImage];
    
    
}
-(void)loadThemeImage
{
    //由ThemeManager加載圖片
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:@"navigationbar_background.png"];
    [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    
}

@end
