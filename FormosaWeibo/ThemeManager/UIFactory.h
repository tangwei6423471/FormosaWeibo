//
//  UIFactory.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLable.h"
@interface UIFactory : NSObject

/**
 *  創建主題Button
 *
 *  @param imageName       imageName
 *  @param highlightedName highlightedName
 *
 *  @return UIButton
 */
+ (UIButton *)createButton:(NSString *)imageName
               highlighted:(NSString *)highlightedName;


/**
 *  創建主題ImageView
 *
 *  @param imageName imageName
 *
 *  @return UIImageView
 */
+ (UIImageView *)createImageView:(NSString *)imageName;

/**
 *  創建主題Lable
 *
 *  @param colorName fontColor.Plist檔內的Key
 *
 *  @return UILable
 */
+ (UILabel *)createLable:(NSString *)colorName;

/**
 *  創建導航欄上的按鈕
 *
 *  @param title 標題
 *
 *  @return UIButton
 */
+(UIButton *)createNavigationButton:(NSString *)title;

@end
