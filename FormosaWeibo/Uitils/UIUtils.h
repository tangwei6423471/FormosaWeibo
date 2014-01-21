//
//  UIUtils.h
//
//
//  Copyright (c) 2012年 reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

//获取包documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;

//-------------日期格式化-------------
//data日期對象-->格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 --> date日期對象
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;
//格式化
+ (NSString *)fomateString:(NSString *)datestring;
//-------------日期格式化 End----------

/**
 *  解析與替換為超鏈接 正規表達式
 *
 *  @param text 要解析的內容
 *
 *  @return 解析完成
 */
+ (NSString *)parseLink:(NSString *)text;

//打開(處理)RTLabel中的鏈接
+ (void)openLink:(NSURL *)url view:(UIView *)view;

@end
