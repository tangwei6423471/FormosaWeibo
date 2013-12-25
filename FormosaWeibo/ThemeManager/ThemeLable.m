//
//  ThemeLable.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "ThemeLable.h"
#import "ThemeManager.h"
@implementation ThemeLable

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self Notification];
    }
    return self;
}
-(id)initWithColorName:(NSString *)colorName
{
    self = [super initWithFrame:CGRectZero];
    if (self != nil) {
        
        self.colorName = colorName;
       
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
    
    [self setColor];
}
//--------Xib限定 End--------

-(void)setColor
{
   UIColor *textColor =[[ThemeManager shareInstance] getColorWithName:self.colorName];
    self.textColor=textColor;
    
}
///註冊監聽:監聽主題切換的通知
-(void)Notification
{
    //註冊監聽:監聽主題切換的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    [self setColor];
}


//當切換主題時,會調用的方法
-(void)themeNotification:(NSNotification *)notification
{
    [self setColor];
    
}


-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:kThemeDidChangeNotification object:nil ];
    [super dealloc];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
