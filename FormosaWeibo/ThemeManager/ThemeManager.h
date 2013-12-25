//
//  ThemeManager.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//
#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject
{
    @private
    //主題配置信息
    NSDictionary *_themeConfig;
}
//當前使用的主題名稱
@property(nonatomic,copy)NSString *themeName;
//主題配置信息
@property(nonatomic,retain)NSDictionary *themeConfig;
//字體配置信息
@property(nonatomic,retain)NSDictionary *fontConfig;
//ThemeManager單例
+(ThemeManager *)shareInstance;


/**
 *  由圖片名,得到當前主題下的圖片
 *
 *  @param imageName 圖片名稱
 *
 *  @return <#return value description#>
 */
-(UIImage *)getThemeImage:(NSString *)imageName;

/**
 *  通過名稱,返回當前主題下字體顏色

 *
 *  @param name name
 *
 *  @return UIColor
 */
-(UIColor *)getColorWithName:(NSString *)name;


@end
