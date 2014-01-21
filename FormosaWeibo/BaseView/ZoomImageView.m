//
//  ZoomImageView.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/13.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "ZoomImageView.h"
#import "THProgressView.h"
#import "MBProgressHUD.h"
@implementation ZoomImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)addZoom:(NSString *)urlString
{
    self.urlString = urlString;
    
    self.userInteractionEnabled = YES;
    
    //添加放大圖片的點擊手勢
    UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomInAction)];
    [self addGestureRecognizer:tap];
    [tap release];
    
    
}
-(void)_initView
{
    
    if (_coverView == nil) {
        _coverView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _coverView.backgroundColor = [UIColor blackColor];
        //縮小圖片的手勢
          UITapGestureRecognizer *tap= [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zoomOutAction)];
        [_coverView addGestureRecognizer:tap];
      
        [self.window addSubview:_coverView];
        [tap release];
    }
    
    if (_fullImageView == nil) {
        _fullImageView = [[UIImageView alloc] initWithImage:self.image];
        //等比例縮放
        _fullImageView.contentMode = UIViewContentModeScaleAspectFit;
        _fullImageView.userInteractionEnabled = YES;
        [_coverView addSubview:_fullImageView];
    }
    //------
    if (_progressView == nil) {
       
        _progressView = [[THProgressView alloc] initWithFrame:CGRectMake(10, ScreenHeight-80, ScreenWidth-20, 20)];
        _progressView.borderTintColor = [UIColor whiteColor];
        _progressView.progressTintColor = [UIColor whiteColor];
        [_progressView setProgress:0.0f animated:YES];
       
        [_coverView addSubview:_progressView];
    }
   //------
    
    //儲存按鈕
    if (_saveButton ==nil) {
        _saveButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        [_saveButton setImage:[UIImage imageNamed:@"tableview_pulltorefresh_arrow.png"] forState:UIControlStateNormal];
        //高亮的
        [_saveButton setImage:[UIImage imageNamed:@"tableview_pulltorefresh_arrow.png"] forState:UIControlStateHighlighted];
        _saveButton.frame = CGRectMake(ScreenWidth-20-16, ScreenHeight-20-30, 16, 30);
        
        [_saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.hidden =YES;
        [self.window addSubview:_saveButton];
    }
   
    
//    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(10, ScreenHeight/2, ScreenWidth-20, 50)];
//    test.backgroundColor = [UIColor yellowColor];
//    [self.window addSubview:test];
//    
    //轉換座標,將當前視圖的座標轉換成顯示在Window上的坐標
    CGRect frame = [self convertRect:self.bounds toView:self.window];
    _fullImageView.frame = frame;

}
//放大圖片
-(void)zoomInAction
{
    [self _initView];
    //設UIScrollView 背景為透明
    _coverView.backgroundColor = [UIColor clearColor];
    //隱藏statusBar
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
    //動畫效果
    [UIView animateWithDuration:0.3f animations:^{
        _fullImageView.frame = [UIScreen mainScreen].bounds;
       
    }completion:^(BOOL finished)
    {
      _coverView.backgroundColor = [UIColor blackColor];
        _saveButton.hidden = NO;
    }];
    

    
    //請求網路圖片
    [_data release];//release 舊的資料
    _data = [[NSMutableData alloc] init];
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request= [NSURLRequest requestWithURL:url
                                            cachePolicy:NSURLRequestReturnCacheDataElseLoad//緩存策略
                                        timeoutInterval:30];//超時時間
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    
}

//縮小圖片
-(void)zoomOutAction
{
    //顯示statusBar
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    //設UIScrollView 背景為透明
    _coverView.backgroundColor = [UIColor clearColor];
    //隱藏進度條
    _progressView.hidden = YES;
    //隱藏saveButton
    _saveButton.hidden = YES;
    //動畫效果
    [UIView animateWithDuration:0.3f animations:^{
        CGRect frame = [self convertRect:self.bounds toView:self.window];
        _fullImageView.frame = frame;
        
        
        
    }completion:^(BOOL finished)
    {
        [_coverView removeFromSuperview];
        
        
        
        //釋放_coverView
        [_coverView release];
        _coverView = nil;//安全釋放 設為nil
        
        [_fullImageView release];
        _fullImageView =nil;
        
        [_progressView release];
        _progressView =nil;
        [_saveButton release];
        _saveButton = nil;
        
        
    
    }];

}

//----------saveAction----------------
-(void)saveAction
{
    UIImage *image = _fullImageView.image;
    if (image != nil) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
        hud.labelText = @"存檔中...";
        hud.dimBackground = YES;//是否要蓋住後面的視圖
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), hud);
    }
   
}
//圖片保存至相簿調用的方法 一定要實現的方法
//存檔完成會調用 ,失敗也會
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    MBProgressHUD *hud = contextInfo;
    //打勾的圖片(圖片可以自己設)
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    //顯示模式設為自定義
    hud.mode =MBProgressHUDModeCustomView;
    hud.labelText = @"存檔完成";
    [hud hide:YES afterDelay:1.5f];
    
    
}
//------------saveAction End--------------
#pragma mark - NSURLConnectionData Delegate
//伺服器做出響應時會調用的方法

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   //伺服器響應的訊息會放在response內
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    //得到響應head所有的訊息
    NSDictionary *allHeaderFields = [httpResponse allHeaderFields];
    NSLog(@"%@",allHeaderFields);//test
    //檔案的總大小
    NSString *size = [allHeaderFields objectForKey:@"Content-Length"];
    
    _length = [size doubleValue ];
}

//載入中時調用
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
    
    float progress = _data.length/_length;
    //NSLog(@"%f",progress);//test
    [_progressView setProgress:progress animated:YES];
    
   
}

//載入完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *image = [UIImage imageWithData:_data];
    _fullImageView.image = image;
    
    
    //加載完後隱藏進度條
    [_progressView setProgress:1.0f animated:YES];//嚴謹些 設為1
    _progressView.hidden = YES;
    [_progressView removeFromSuperview];
  
   
    //圖片等比例拉寬
    //image.size可拿到圖片原始大小
   // image.size.height/image.size.width = ?/320;
    float height = image.size.height /image.size.width *ScreenWidth;
    //圖片大小 小於ScreenHeight
    if(height < ScreenHeight)
    {
        //讓圖居中
        _fullImageView.top =(ScreenHeight-height)/2;
    }
    
    _fullImageView.size = CGSizeMake(ScreenWidth, height);
    //ScrollView大小
    _coverView.contentSize = CGSizeMake(ScreenWidth, height);
    
    
}

-(void)dealloc
{
    [_data release];
    [_urlString release];
    [super dealloc];
}

@end
