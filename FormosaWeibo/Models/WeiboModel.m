//
//  WeiboModel.m
//  weibo
//
//
//  Copyright (c) 2013年 joey. All rights reserved.
//

#import "WeiboModel.h"
#import "UserModel.h"
//step
//                     遍歷
//1.setAttributes 大字典-->大數組
//2.attributeMapDictionary把大數組內的字典丟給Model

                                                           //字典丟給Model
//請求Server-->返回Json字符串-->解析成大字典-->遍歷數組(很多條微博)-->取出每一個微博字典-->創建微博Model
@implementation WeiboModel
//attributeMapDictionary為設定映射關係 ,映射有點像是"小名" 方便我們找到屬性
//EX :JSON解析的數據名:created_at   此對象的屬性名:createDate
- (NSDictionary *)attributeMapDictionary {
    NSDictionary *mapAtt = @{
   // WeiboModel屬性名:  微博字典Value
        @"createDate":@"created_at",
        @"weiboId":@"id",
        @"text":@"text",
        @"source":@"source",
        @"favorited":@"favorited",
        @"thumbnailImage":@"thumbnail_pic",
        @"bmiddleImage":@"bmiddle_pic",
        @"originalImage":@"original_pic",
        @"geo":@"geo",
        @"repostsCount":@"reposts_count",
        @"commentsCount":@"comments_count"
    };
    
    return mapAtt;
}

//dataDic是一個JSON解析完後,完整的微博字典
 //将字典数据根据映射关系填充到当前对象的"属性"上。
- (void)setAttributes:(NSDictionary *)dataDic {
   
    //setAttributes 解析大字典-->遍歷大數組
    //將dataDic設置給"屬性"們
    [super setAttributes:dataDic];//設置屬性
    
    //由字典取出源微博,源微博本是微博
    NSDictionary *retweetDic = [dataDic objectForKey:@"retweeted_status"];
    if (retweetDic != nil) {
        //字典轉Model
        WeiboModel *relWeibo = [[WeiboModel alloc] initWithDataDic:retweetDic];
        self.relWeibo = relWeibo;
        [relWeibo release];        
    }
    
    //因為在回傳的Json字典 User訊息是一個字典,所以要這麼做
    //由字典取出user資訊
    NSDictionary *userDic = [dataDic objectForKey:@"user"];
    if (userDic != nil) {
        //將JSON內容賦給UserModel的屬性 ,字典轉Model
        UserModel *user = [[UserModel alloc] initWithDataDic:userDic];
        self.user = user;
        [user release];        
    }
    
    
    //結論:只要是字典中,"又有字典(這字典可另成為一個Model)"就需要這麼做
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
    
    self.createDate = nil;        //微博的创建时间
    self.weiboId = nil;            //微博id
    self.text = nil;               //微博内容
    self.source = nil;            //微博来源
    self.favorited  = nil;         //是否已收藏，true：是，false：否
    self.thumbnailImage = nil;    //缩略图片地址，没有时不返回此字段
    self.bmiddleImage = nil;      //中等尺寸图片地址，没有时不返回此字段
    self.originalImage = nil;     //原始图片地址，没有时不返回此字段
    self.geo = nil;               //地理信息字段
    self.repostsCount = nil;      //转发数
    self.commentsCount = nil;     //评论数
    self.relWeibo = nil;          //被转发的原微博(源微博對象)
    self.user = nil;              //微博的作者
 
    [super dealloc];
    
}


@end
