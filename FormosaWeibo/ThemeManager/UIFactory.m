//
//  UIFactory.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory
+ (UIButton *)createButton:(NSString *)imageName
               highlighted:(NSString *)highlightedName
{
    ThemeButton *button = [[ThemeButton alloc] initWithImage:imageName highlighted:highlightedName];
    //返回
    return [button autorelease];

}

+ (UIImageView *)createImageView:(NSString *)imageName
{
    ThemeImageView *themeImage=[[ThemeImageView alloc] initWithImageName:imageName];
    
    return [themeImage autorelease];


}

+ (UILabel *)createLable:(NSString *)colorName
{
    ThemeLable *themeLable= [[ThemeLable alloc]  initWithColorName:colorName];
    return [themeLable autorelease];


}


+(UIButton *)createNavigationButton:(NSString *)title
{
    ThemeButton *button = [[ThemeButton alloc] initWithBackground:@"main_badge.png"
                                            highlightedBackground:@""];//highlightedBackground可設置圖片,這目前沒設
    button.leftCapWidth = 6;
   
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 50, 30);
   
    //返回
    return [button autorelease];


}
@end
