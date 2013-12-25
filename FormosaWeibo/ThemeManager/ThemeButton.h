//
//  ThemeButton.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

//normal狀態下的圖片名稱
@property(nonatomic,copy)NSString *imageName;
//高亮下的圖片名稱
@property(nonatomic,copy)NSString *highlithImageName;

//背景圖片名稱
@property(nonatomic,copy)NSString *backgroundImageName;
@property(nonatomic,copy)NSString *backgroundHighlightImageName;
//圖片拉伸位子
@property(nonatomic,assign)float leftCapWidth;
@property(nonatomic,assign)float topCapWidth;
/**
 *  初始化主題按鈕
 *
 *  @param imageName         imageName
 *  @param highlithImageName highlithImageName
 *  
 */
-(id)initWithImage:(NSString *)imageName
       highlighted:(NSString *)highlithImageName;


-(id)initWithBackground:(NSString *)backgroundImageName
       highlightedBackground:(NSString *)backgroundHighlightImageName;


@end
