//
//  WeiboView.h
//  weibo
//
//  Created by Joey on 13/8/22.
//  Copyright (c) 2013年 joey. All rights reserved.
//
//WeiBoView-WeiBo內容視圖
/*WeiBoView想法
 源微博就是被轉發的微博
                     放到   這個對象
先顯示原始微博,把原始微博 --> *weiboModel(源微博)  
利用hidden方式來顯示或隱藏 源微博
 
*/

#import <UIKit/UIKit.h>
#import "RTLabel.h"
//微博視圖在單元格中顯示的寬度
#define Weibo_Width_Cell ScreenWidth-60
@class WeiboModel;
@class ThemeImageView;
@interface WeiboView : UIView<RTLabelDelegate>
{
@private
    RTLabel *_textLabel;
    UIImageView  *_imageView;
    //源微博子視圖
    WeiboView    *_sourceWeiboView;
    //源微博的背景視圖
    ThemeImageView  *_sourceViewBackground;
    
    //經過正則表達式後的text
    NSMutableString *_parseText;

}

@property(nonatomic,assign)BOOL isSource;//當前微博視圖是否為源微博  源微博=YES
//微博視圖是否顯示在詳情頁面
@property(nonatomic,assign)BOOL isDetail;
//這個weiboModel放微博Model
@property(nonatomic,retain)WeiboModel *weiboModel;


//計算weiboModel此微博對象視圖的高度
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                    isSource:(BOOL)isSource
                    isDetail:(BOOL)isDetail;


@end
