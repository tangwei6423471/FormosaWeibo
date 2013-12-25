//
//  ThemeManager.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//邏輯:切換路徑達到更換主題的效果
//條件 1.主題圖片名都要一樣


#import "ThemeManager.h"
//單例相關方法
static ThemeManager *sigleton = nil;

@implementation ThemeManager

-(id)init
{
    self=[super init];
    if (self!=nil) {
        //---------主題配置文件-------
        //取得主題Plist文件路徑
        NSString *filePath= [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        //由檔案讀到字典
        _themeConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
        [_themeConfig retain];//NSDictionary由自動釋放池管控,避免他被誤判釋放所以retain
        //---------主題配置文件 End-------
        
        //---------字體顏色配置文件-------
        NSString *fontConfigPath= [[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"];
        //由檔案讀到字典
        _fontConfig = [[NSDictionary dictionaryWithContentsOfFile:fontConfigPath] retain];
        
        //---------字體顏色配置文件 End-------
        //默認的主題
        self.themeName= @"ClassStyle";
        
    }

    return self;
}
//複寫setThemeName
-(void)setThemeName:(NSString *)themeName
{
    if (_themeName!=themeName) {
        //release之前的
        [_themeName release];
        //把目前的copy 給_themeName
        _themeName=[themeName copy];
    }
    
    //---------字體顏色配置文件-------
    //獲取主題包的根目錄
    NSString *themePath=[self getThemePath];
    //拼接
    NSString *filePath=  [themePath stringByAppendingPathComponent:@"fontColor.plist"];
    //由檔案讀到字典
    //fontConfig的set方法自動release,copy
    self.fontConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    //---------字體顏色配置文件 End-------
    

}
/**
 *  獲取主題包的根目錄
 *
 *  @return 主題包的根目錄
 */
-(NSString *)getThemePath
{
    //獲取到根路徑
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    
    //判斷是否為默認的主題,因為默認的主題圖片在根目錄
    if([self.themeName isEqualToString:@"ClassStyle"])
    {
       
        return resourcePath;
    }
    
    //取得當前主題的子路徑 例如blue
    NSString *subPath = [_themeConfig objectForKey:self.themeName];
    //主題的完整路徑
    NSString *path = [resourcePath stringByAppendingPathComponent:subPath];
    return path;
    

}
//由圖片名,得到當前主題下的圖片
-(UIImage *)getThemeImage:(NSString *)imageName
{
    //判斷圖片名是否為空
    if(imageName.length==0)
    {
        return nil;
    }
    
    
    //根路徑
    NSString *path = [self getThemePath];
    //imagePath 當前主題的文件路徑
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    //給文件路徑就可以取出圖片
    UIImage *image=[UIImage imageWithContentsOfFile:imagePath];
 



    return image;

}
//通過名稱,返回當前主題下字體顏色
-(UIColor *)getColorWithName:(NSString *)name
{
    if (name.length == 0) {
        return nil;
    }
    
    NSString *rgb = [self.fontConfig objectForKey:name];
    //分割字符串
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    if(rgbs.count ==3 )
    {
        float r=[rgbs[0] floatValue];
        float g=[rgbs[1] floatValue];
        float b=[rgbs[2] floatValue];
        //Color(r,g,b,1) 為紅
        UIColor *color = Color(r,g,b,1);//[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
        return color;
    }
    
    return nil;
    
}



//------------------單例相關方法------------------
#pragma mark - 單例相關方法
+ (ThemeManager *)shareInstance {
    if (sigleton == nil) {
        @synchronized(self){
            sigleton = [[ThemeManager alloc] init];
        }
    }
    return sigleton;
}
//限制當前對象建多個實例(單例必須加的)
#pragma mark - sengleton setting
+ (id)allocWithZone:(NSZone *)zone {
    @synchronized(self) {
        if (sigleton == nil) {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

+ (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}
//------------------單例相關方法 End------------------
@end
