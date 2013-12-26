//
//  UIUtils.m
//
//
//  
//  Copyright (c) 2012年 All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>
#import "RegexKitLite.h" //要導入libicucore.dylib 類庫
#import "NSString+URLEncoding.h"

@implementation UIUtils

+ (NSString *)getDocumentsPath:(NSString *)fileName {
    
    //两种获取document路径的方式
//    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documents = [paths objectAtIndex:0];
    NSString *path = [documents stringByAppendingPathComponent:fileName];
    
    return path;
}

+ (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	[formatter release];
	return str;
}

+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formate];
    NSDate *date = [formatter dateFromString:datestring];
    [formatter release];
    return date;
}

//格式化回傳的日期
//Sat Jan 12 11:50:16 +0800 2013
+ (NSString *)fomateString:(NSString *)datestring {
    NSString *formate = @"E MMM d HH:mm:ss Z yyyy";
    NSDate *createDate = [UIUtils dateFromFomate:datestring formate:formate];
    NSString *text = [UIUtils stringFromFomate:createDate formate:@"MM-dd HH:mm"];
    return text;
}


//解析與替換為超鏈接
+ (NSString *)parseLink:(NSString *)text
{
    //需要添加鏈接的字符串: @用戶 , http:// ,#話題# 正則表達式
    NSString *regex1 = @"@\\w+";    //因為\在oc裡面是特殊字符
    NSString *regex2 = @"http(s)?://([A-Za-z0-9._-]+(/)?)*";
    NSString *regex3 = @"#\\w+#";
    NSString *regex  =[NSString stringWithFormat:@"(%@)|(%@)|(%@)",regex1,regex2,regex3];
    
 
    //RTlable看開頭區分
    //@用戶  -->  <a href='user://@用戶'>@用戶</a>  user://自設的
    //http:// --> <a href='http://www.yahoo.com'>http://yahoo.com </a>
    //#話題#   --> <a href='topic://#話題#'>#話題#</a>   topic://自設的
    //正則表達式和內容相比
    NSArray *matchArray = [text componentsMatchedByRegex:regex];
    for (NSString *linkString in matchArray) {
        //hasPrefix :判斷字符串以什麼開頭
        if ([linkString hasPrefix:@"@"])
        {
            //url 內如果有中文就會出現null 所以要用NSString+URLEncoding 編碼以及解碼
            //中文URL編碼
            NSString *encodestring = [linkString URLEncodedString];
            NSString *replacement = [NSString stringWithFormat:@"<a href='user://%@'>%@</a>",encodestring,linkString];
            //把linkString字符串 替換為replacement
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacement];
        }
        else if([linkString hasPrefix:@"http"])
        {
            
            NSString *replacement = [NSString stringWithFormat:@"<a href='%@'>%@</a>",linkString,linkString];
            //把linkString字符串 替換為replacement
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacement];
        }
        else if([linkString hasPrefix:@"#"])
        {
            
            //中文URL編碼
            NSString *encodestring = [linkString URLEncodedString];
            
            NSString *replacement = [NSString stringWithFormat:@"<a href='topic://%@'>%@</a>",encodestring,linkString];
            //把linkString字符串 替換為replacement
            text = [text stringByReplacingOccurrencesOfString:linkString withString:replacement];
            
        }
        
    }
    return text;

}

@end
