//
//  ThemeLable.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLable : UILabel

@property(nonatomic,copy)NSString *colorName;

/**
 *  初始化Lable
 *
 *  @param colorName fontColor.Plist檔內的Key
 *
 *  @return return value description
 */
-(id)initWithColorName:(NSString *)colorName;

@end
