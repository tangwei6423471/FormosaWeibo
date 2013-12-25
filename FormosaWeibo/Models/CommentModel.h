//
//  CommentModel.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/19.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "WXBaseModel.h"
#import "UserModel.h"
#import "WeiboModel.h"


/*
 返回值字段	字段类型	字段说明
 created_at	string	评论创建时间
 id	int64	评论的ID
 text	string	评论的内容
 source	string	评论的来源
 user	object	评论作者的用户信息字段 详细
 mid	string	评论的MID
 idstr	string	字符串型的评论ID
 status	object	评论的微博信息字段 详细
 reply_comment	object	评论来源评论，当本评论属于对另一评论的回复时返回此字段
 */
//******************因為Json屬性的字段和此Model的屬性名相同所以可以不作映射******************

@interface CommentModel : WXBaseModel


@property(nonatomic,copy)NSString *created_at;
@property(nonatomic,copy)NSString *idstr;
@property(nonatomic,copy)NSString *text;
@property(nonatomic,copy)NSString *source;


//Model內又有其他Model,就需要複寫setAttributes方法 ,設置其他Model的資料
@property(nonatomic,retain)UserModel *user;
@property(nonatomic,retain)WeiboModel *weibo;
@property(nonatomic,retain)CommentModel *sourceComment;//源評論




@end
