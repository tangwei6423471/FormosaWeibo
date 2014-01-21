//
//  WeiboView.m
//  weibo
//
//  Created by Joey on 13/8/22.
//  Copyright (c) 2013年 joey. All rights reserved.
//

#import "WeiboView.h"
#import "WeiboModel.h"
#import "UIImageView+WebCache.h"
#import "UIFactory.h"
#import "ThemeImageView.h"
#import "RegexKitLite.h" //要導入libicucore.dylib 類庫
#import "NSString+URLEncoding.h"
#import "UIUtils.h"
#import "ZoomImageView.h"
#import "ProfileViewController.h"

@implementation WeiboView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _parseText = [[NSMutableString alloc] init];
        [self _initViews];
    }
    return self;
}
//源微博不可以在這就初始化,cell會死循環
-(void)_initViews
{
    _textLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _textLabel.delegate=self;
    _textLabel.font=[UIFont systemFontOfSize:14.0];
    //link的顏色
    _textLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //設置選中link時的顏色
    _textLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self addSubview:_textLabel];
    
    //微博圖片
    _imageView=[[ZoomImageView alloc] initWithFrame:CGRectZero];
    //UIViewContentModeScaleAspectFit 顯示圖片的原始比例,自適應
    _imageView.contentMode =UIViewContentModeScaleAspectFit;
    _imageView.backgroundColor=[UIColor clearColor];
    [self addSubview:_imageView];
    
    //-----------提醒----------
    //源微博不可以在這就初始化,cell會死循環
    //因為initWithFrame會造成死循環
   //_sourceWeiboView = [[WeiboView alloc]initWithFrame:CGRectZero ];
    //-----------提醒 End----------
    
    //----------------源微博的背景視圖----------------
   
    _sourceViewBackground =(ThemeImageView *)[UIFactory createImageView:@"timeline_retweet_background.png"];
    //切換主題時設置 因為init時leftCapWidth,topCapWidth 都為預設值0,
    //而 init時是先創建好_sourceViewBackground 才賦值的 所以變換主題時才會用到topCapWidth,leftCapWidth的值
    _sourceViewBackground.topCapWidth = 10;
    _sourceViewBackground.leftCapWidth = 25;
    //init時候設置的 因為init時leftCapWidth,topCapWidth 都為預設值0
     UIImage *image =_sourceViewBackground.image ;
    //設置拉伸stretchableImageWithLeftCapWidth
    //LeftCapWidth由左到右,像素第25開始拉伸
    //topCapHeight由上到下,像素第10開始拉伸
    image = [image stretchableImageWithLeftCapWidth:25 topCapHeight:10];
    _sourceViewBackground.image=image;
    
    _sourceViewBackground.backgroundColor=[UIColor clearColor];
    //非源微博不需要這個Background so預設是hidden
    _sourceViewBackground.hidden=YES;
    //插入視圖 0是最底部
    [self insertSubview:_sourceViewBackground atIndex:0];
    //----------------源微博的背景視圖 End------------
}

//要在這初始化源微博
//複寫WeiboModel的setter
-(void)setWeiboModel:(WeiboModel *)weiboModel
{
    
    //固定的複寫setter寫法(一定會有這段)
    if (_weiboModel!=weiboModel) {
        [_weiboModel release];
        _weiboModel=[weiboModel retain];
    }
    
    //創建源微博                     weiboModel的relWeibo是有資料的就 創建
    if (_sourceWeiboView == nil && _weiboModel.relWeibo !=nil) {
        _sourceWeiboView = [[WeiboView alloc] initWithFrame:CGRectZero];
        //_sourceWeiboView.backgroundColor=[UIColor redColor];
        //設置是源微博
        _sourceWeiboView.isSource = YES;// YES=源微博
        //源微博視圖設置是否為詳情
        _sourceWeiboView.isDetail = self.isDetail;
        
        
        [self addSubview:_sourceWeiboView];
    }
 
    
     //經過正則表達式後的text 賦給parseText
   //追加之前先置空
    [_parseText setString:@""];
    //判斷是否為源微博
    if (self.isSource) {
        //將源微博作者暱稱拼接
        NSString *nickName = _weiboModel.user.screen_name;
        NSString *encodestring = [nickName URLEncodedString];
        NSString *replacement = [NSString stringWithFormat:@"<a href='user://%@'>@%@</a>",encodestring,nickName];
        [_parseText appendFormat:@"%@:",replacement];
    }
    NSString *text = [UIUtils parseLink:_weiboModel.text];
    [_parseText appendString:text];
    
}

//單純抽出來的程式碼,沒有return 可加下劃線 方便識別
-(void)_renderTextLable
{
    float fontSize = [WeiboView getFontSize:self.isDetail isSource:self.isSource];
    _textLabel.font =[UIFont systemFontOfSize:fontSize];
    //高度是自動適應的,所以先給0
    _textLabel.frame=CGRectMake(0, 0, self.width, 0);
    if (self.isSource) {
        _textLabel.frame=CGRectMake(10, 10, self.width-20, 0);
        
    }
    _textLabel.text = _parseText;//_weiboModel.text;
    
    //optimumSize計算Label高度
    CGSize textSize=_textLabel.optimumSize;
    _textLabel.height=textSize.height;//lable高度
}

-(void)_renderSourceWeibo
{
    //有源微博數據才有View
    WeiboModel *sourceWeibo= _weiboModel.relWeibo;
    //判斷是否有源微博
    if (sourceWeibo!=nil) {
        _sourceWeiboView.hidden = NO;
        _sourceWeiboView.weiboModel = sourceWeibo;
        //計算源微博的高度,調用getWeiboViewHeight
        float height  = [WeiboView getWeiboViewHeight:sourceWeibo isSource:YES isDetail:self.isDetail];
        //self.width 當前WeiboView的width
        _sourceWeiboView.frame = CGRectMake(0, _textLabel.bottom, self.width, height);
        
        
    }else{
        _sourceWeiboView.hidden = YES;
    }

}
-(void)_renderImage
{
    //微博大圖
    NSString *originalImage =_weiboModel.originalImage;
    if (originalImage !=nil && ![@"" isEqualToString:originalImage])
    {
        //添加點擊放大效果
        [_imageView addZoom:_weiboModel.originalImage];
    }

    if(self.isDetail)
    {
        //中等尺寸的圖片URL
        NSString *bmiddleImage = _weiboModel.bmiddleImage;
        //不等於空,有圖片才顯示
        if (bmiddleImage !=nil && ![@"" isEqualToString:bmiddleImage]) {
            
            _imageView.hidden = NO;
            _imageView.frame = CGRectMake((self.width -280)/2, _textLabel.bottom+10, 280, 200);
            [_imageView setImageWithURL:[NSURL URLWithString:bmiddleImage]];
            
        }else
        {
            _imageView.hidden = YES;
            
        }
        
        
    } else
    {
        //取出使用者的圖片瀏覽模式
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        //如果使用者沒設定mode 初始會為0
        if (mode == 0) {
            mode = smallMode;
        }
        //小圖瀏覽模式
        if (mode == smallMode) {
            //縮圖的URL
            NSString *thumbnailImage = _weiboModel.thumbnailImage;
            //不等於空,有圖片才顯示
            if (thumbnailImage !=nil && ![@"" isEqualToString:thumbnailImage]) {
                
                _imageView.hidden = NO;
                _imageView.frame = CGRectMake(10, _textLabel.bottom+10, 70, 80);
                [_imageView setImageWithURL:[NSURL URLWithString:thumbnailImage]];
                
            }else
            {
                _imageView.hidden = YES;
                
            }
            
            
        }else if(mode == LargeMode)//大圖瀏覽模式
        {
            //中等尺寸的圖片URL
            NSString *bmiddleImage = _weiboModel.bmiddleImage;
            //不等於空,有圖片才顯示
            if (bmiddleImage !=nil && ![@"" isEqualToString:bmiddleImage]) {
                
                _imageView.hidden = NO;
                _imageView.frame = CGRectMake(10, _textLabel.bottom+10, self.width-20, 200);
                [_imageView setImageWithURL:[NSURL URLWithString:bmiddleImage]];
                
            }else
            {
                _imageView.hidden = YES;
                
            }
            
        }
        
        
        
    }
    

}
//layoutSubviews幹2件事 1.顯示數據 2.佈局視圖
//圖片和源微博只能擇一   ,圖片和源微博都在_textLabel的下方顯示
-(void)layoutSubviews
{
    [super layoutSubviews];
    //-----------_textLabel子視圖-----------
    [self _renderTextLable];

   
    //-----------_sourceWeiboView源微博視圖-----------
    [self _renderSourceWeibo];
    
    //------------------微博圖片_imageView------------------
    [self _renderImage];
    //------------------_sourceViewBackground------------------
   //判斷當前是否為源微博
    if (self.isSource) {
        _sourceViewBackground.hidden = NO;
        _sourceViewBackground.frame  =self.bounds;
    }
    else
    {
        _sourceViewBackground.hidden = YES;
    }
    
    

}
//獲取字體大小
+ (float)getFontSize:(BOOL)isDetail isSource:(BOOL)isSource
{
    float fontSize = 14.0f;
    
    if (!isDetail && !isSource)
    {
        fontSize = 14.0f;
    }
    else if(!isDetail && isSource)
    {
         fontSize = 12.0f;
    }
    else if(isDetail && isSource)
    {
         fontSize = 15.0f;
    }
    else if(isDetail && !isSource)
    {
         fontSize = 18.0f;
    }
    return fontSize;



}
//計算微博視圖高度
+(CGFloat)getWeiboViewHeight:(WeiboModel *)weiboModel
                    isSource:(BOOL)isSource
                    isDetail:(BOOL)isDetail
{
    //TIP:類方法無法直接訪問對象屬性,只能訪問類
    //對象才有屬性
    /*
       計算微博視圖高度
        想法:傳入WeiboModel 
        計算每個視圖的高度,然後相加
       這類方法是非源微博和源微博共用的類方法
     
     */
    
    //整個微博視圖的高度 預設為0
    float height = 0;
    //---------------計算textLabel微博內容的高度---------------
    RTLabel *textLabel = [[RTLabel alloc]initWithFrame:CGRectZero];
//    float fontSize = 16.0f;
//    if (isSource) {
//        fontSize=12.0f;
//    }
    float fontSize = [WeiboView getFontSize:isDetail isSource:isSource];
    
    textLabel.font=[UIFont systemFontOfSize:fontSize];
    float width = 0;
    if (isDetail) {
        width = 300;
    }else
    {
        width = Weibo_Width_Cell;
    }
    
    //判斷當前是否為源微博
    if (isSource)
    {
        //源微博寬度-20
        width= width-20;
        //加上10的間隙(源微博_textLabel的y座標是10)
        height +=10;
    }
    
    textLabel.width= width;
    NSString *text = weiboModel.text;
    
    if (isSource) {
        //微博作者的nickName
        NSString *nickName = weiboModel.user.screen_name;
        text = [NSString stringWithFormat:@"%@:%@",nickName,text];
    }

    textLabel.text= text;
    float textHeight = textLabel.optimumSize.height;
    height += textHeight;
    
    //---------------計算源微博內容的高度---------------
    //源微博對象
    WeiboModel *rewWeibo = weiboModel.relWeibo;
    //是否有源微博
    if ( rewWeibo!=nil ) {
       float reWeiboHeight= [WeiboView getWeiboViewHeight:rewWeibo isSource:YES isDetail:isDetail];
        height += reWeiboHeight;
    }
    //---------------計算微博圖片的高度---------------
    if (isDetail)
    {
        //中等尺寸的圖片URL
        NSString *bmiddleImage = weiboModel.bmiddleImage;
        //不等於空,有圖片才顯示
        if (bmiddleImage !=nil && ![@"" isEqualToString:bmiddleImage]) {
            height += (200+10);
        }

    } else{
        //取出使用者的圖片瀏覽模式
        int mode = [[NSUserDefaults standardUserDefaults] integerForKey:kBrowMode];
        //如果使用者沒設定mode 初始會為0
        if (mode == 0) {
            mode = smallMode;
        }
        //小圖瀏覽模式
        if (mode == smallMode)
        {
            NSString *thumbnailImage = weiboModel.thumbnailImage;
            if (thumbnailImage !=nil && ![@"" isEqualToString:thumbnailImage])
            {
                //微博圖片高度為80
                height += (80+10);
                
            }
        }else if (mode ==LargeMode)
        {
            //中等尺寸的圖片URL
            NSString *bmiddleImage = weiboModel.bmiddleImage;
            //不等於空,有圖片才顯示
            if (bmiddleImage !=nil && ![@"" isEqualToString:bmiddleImage]) {
                height += (200+10);
            }
        }
      
    }


    return height;
}
#pragma mark- RTlable delegate
- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
    [UIUtils openLink:url view:self];
}
@end
