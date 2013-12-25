//
//  CommentModel.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/19.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
- (void)setAttributes:(NSDictionary *)dataDic {
    
 
    [super setAttributes:dataDic];//設置屬性

    
    
    //由字典取出user資訊
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        //將JSON內容賦給UserModel的屬性 ,字典轉Model
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];
    }
    
    //由字典取出status資訊
    NSDictionary *status = [dataDic objectForKey:@"status"];
    if (status != nil) {
        //將JSON內容賦給UserModel的屬性 ,字典轉Model
        WeiboModel *weibo = [[WeiboModel alloc] initWithDataDic:status];
        self.weibo = weibo;
        [weibo release];
    }
    
    //由字典取出sourceComment資訊
    NSDictionary *replyCommentDic = [dataDic objectForKey:@"reply_comment"];
    if (replyCommentDic != nil) {
        //將JSON內容賦給UserModel的屬性 ,字典轉Model
        CommentModel *sourceComment = [[CommentModel alloc] initWithDataDic:replyCommentDic];
        self.sourceComment = sourceComment;
        [sourceComment release];
    }
    
    
    
    //結論:只要是字典中,"又有字典(這字典可另成為一個Model)"就需要這麼做
    //    Model  又有 Model
    /*
     1.由字典的key取得數據
     NSDictionary *userDic = [dataDic objectForKey:@"user"];
     if (userDic != nil) {
     //將JSON內容賦給UserModel的屬性 ,字典轉Model
     UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
     self.user = user;
     [user release];
     }
     */
    
}

- (void)dealloc
{
    //待加
    [super dealloc];
}

@end
