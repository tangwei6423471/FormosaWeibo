//
//  ThemeImageView.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/9.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView


@property(nonatomic,copy)NSString *imageName;

@property(nonatomic,assign)float leftCapWidth;
@property(nonatomic,assign)float topCapWidth;
/**
 *  初始化圖片
 *
 *  @param imageName         imageName
 *  @param highlithImageName highlithImageName
 *
 */
-(id)initWithImageName:(NSString *)imageName;

@end
