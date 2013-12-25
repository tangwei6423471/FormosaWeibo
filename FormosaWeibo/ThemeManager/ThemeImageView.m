//
//  ThemeImageView.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"
@implementation ThemeImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self Notification];
    }
    return self;
}
-(id)initWithImageName:(NSString *)imageName
{
   
    self = [super initWithFrame:CGRectZero];

    if (self !=nil) {
         self.imageName=imageName;
        
        [self Notification];

    }
    return self;

}

///註冊監聽:監聽主題切換的通知
-(void)Notification
{
    //註冊監聽:監聽主題切換的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    [self loadThemeImage];
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

-(void)loadThemeImage
{
    if (self.imageName.length==0) {
        return;
    }
    //由ThemeManager加載圖片
    UIImage *image=[[ThemeManager shareInstance] getThemeImage:self.imageName];
    //拉伸
    image= [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapWidth];
    //NSLog(@"leftCapWidth:%f",self.leftCapWidth);
    //設置圖片
    self.image=image;
}

//當切換主題時,會調用的方法
-(void)themeNotification:(NSNotification *)notification
{ [self loadThemeImage];
    
}

-(void)dealloc
{
    //移除通知
    [[NSNotificationCenter defaultCenter ]removeObserver:self name:kThemeDidChangeNotification object:nil ];
    [super dealloc];

}

@end
