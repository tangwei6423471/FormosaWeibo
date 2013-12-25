//
//  ThemeButton.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"
@implementation ThemeButton


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
 
    if (self) {
    
        [self Notification];
    }
    return self;
}

-(id)initWithImage:(NSString *)imageName
  highlighted:(NSString *)highlithImageName
{
    self = [super initWithFrame:CGRectZero];
    
    if (self !=nil) {
        self.imageName=imageName;
        self.highlithImageName=highlithImageName;
        [self Notification];
      
    }
    return self;

}


-(id)initWithBackground:(NSString *)backgroundImageName
  highlightedBackground:(NSString *)backgroundHighlightImageName
{
    self = [super initWithFrame:CGRectZero];
    if (self !=nil) {
        self.backgroundImageName= backgroundImageName;
        self.backgroundHighlightImageName = backgroundHighlightImageName;
        [self Notification];
        
    }
    return self;
    
}


//--------Xib限定--------
//使用XIB創建此類的對象,會調用這方法
-(void)awakeFromNib
{
    [super awakeFromNib];
    //註冊監聽:監聽主題切換的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    
    [self loadThemeImage];
}
//--------Xib限定 End--------

///註冊監聽:監聽主題切換的通知
-(void)Notification
{
    //註冊監聽:監聽主題切換的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    [self loadThemeImage];
}

-(void)loadThemeImage
{
    //由ThemeManager加載圖片
    ThemeManager *themeManager=[ThemeManager shareInstance];
    UIImage *image=[themeManager getThemeImage:self.imageName];
    UIImage *highlightImage = [themeManager getThemeImage:self.highlithImageName ];
    //設置圖片
    if (image !=nil) {
         [self setImage:image forState:UIControlStateNormal];
    }
    if (highlightImage !=nil) {
        [self setImage:highlightImage forState:UIControlStateHighlighted];
    }
    
    //設置背景圖片
    UIImage *backimage=[themeManager getThemeImage:self.backgroundImageName];
    UIImage *backhighlightImage = [themeManager getThemeImage:self.backgroundHighlightImageName];
    backimage = [backimage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    backhighlightImage = [backhighlightImage stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    if (backimage !=nil) {
        
        [self setBackgroundImage:backimage forState:UIControlStateNormal];
    }
    if (backhighlightImage !=nil) {
        [self setBackgroundImage:backhighlightImage forState:UIControlStateHighlighted];
    }
    
    
}

-(void)setLeftCapWidth:(float)leftCapWidth
{
    _leftCapWidth = leftCapWidth;
    [self loadThemeImage];
}
-(void)setTopCapWidth:(float)topCapWidth
{
    _topCapWidth = topCapWidth;
    [self loadThemeImage];
}

//當切換主題時,會調用的方法
-(void)themeNotification:(NSNotification *)notification
{
    [self loadThemeImage];


}



-(void)dealloc
{
    //移除當前對象的所有通知
    //[[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除指定通知,用name辨識
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kThemeDidChangeNotification object:nil];
    [super dealloc];
}

@end
