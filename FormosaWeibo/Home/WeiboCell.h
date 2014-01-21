//
//  WeiboCell.h
//  weibo
//
//  Created by Joey on 13/8/22.
//  Copyright (c) 2013年 joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"
@class WeiboModel;
@class WeiboView;

@interface WeiboCell : UITableViewCell
{
  //子視圖
@private
    UIButton *_userImage;//用戶圖像
    UILabel     *_nickLabel;//暱稱
    UILabel     *_repostCountLabel;//轉發數
    UILabel     *_commentLabel;//評論數
    UILabel     *_sourceLabel;//微博來源
    UILabel     *_createLabel;//發佈時間
    //微博視圖
    WeiboView *_weiboView;
    
   
}
//這個weiboModel放微博Model
@property (nonatomic,retain)WeiboModel *weiboModel;




@end
