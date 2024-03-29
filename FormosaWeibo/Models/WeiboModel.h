//
//  WeiboModel.h
//  weibo
//
//  
//  Copyright (c) 2013年 joey. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"


@interface WeiboModel : WXBaseModel

@property(nonatomic,copy)NSString           *createDate;        //微博的创建时间
@property(nonatomic,copy)NSNumber           *weiboId;           //微博id
@property(nonatomic,copy)NSString           *text;              //微博内容
@property(nonatomic,copy)NSString           *source;            //微博来源
@property(nonatomic,retain)NSNumber         *favorited;         //是否已收藏，true：是，false：否
@property(nonatomic,copy)NSString           *thumbnailImage;    //缩略图片地址，没有时不返回此字段
@property(nonatomic,copy)NSString           *bmiddleImage;      //中等尺寸图片地址，没有时不返回此字段
@property(nonatomic,copy)NSString           *originalImage;     //原始图片地址，没有时不返回此字段
@property(nonatomic,retain)NSDictionary     *geo;               //地理信息字段
@property(nonatomic,retain)NSNumber         *repostsCount;      //转发数
@property(nonatomic,retain)NSNumber         *commentsCount;     //评论数
@property(nonatomic,retain)WeiboModel       *relWeibo;          //被转发的原微博(源微博對象)
@property(nonatomic,retain)UserModel        *user;              //微博的作者用户 ,本身就為字典

@end
