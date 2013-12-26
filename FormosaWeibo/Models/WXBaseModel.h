//
//  WXBaseModel.h
//  MTWeibo
//
//所有對象實體的基類
//  
//  Copyright 2011年  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXBaseModel : NSObject <NSCoding>{

}

-(id)initWithDataDic:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;
- (NSString *)customDescription;
- (NSString *)description;
- (NSData*)getArchivedData;

- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串

@end
