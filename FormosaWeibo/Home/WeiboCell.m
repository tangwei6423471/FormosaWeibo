//
//  WeiboCell.m
//  weibo
//
//  Created by Joey on 13/8/22.
//  Copyright (c) 2013年 joey. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "WeiboView.h"
#import "RegexKitLite.h"
#import "UIUtils.h"

@implementation WeiboCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}
-(void)_initViews
{   //用戶頭像
    _userImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    //---------------設置_userImage外邊框------------
    //設置圓弧半徑
    _userImage.layer.cornerRadius = 2;
    //外邊框
    _userImage.layer.borderWidth = 5;
    //外邊框顏色 borderColor 依賴CGColor ,所以設置時要將UIColor轉為CGColor
    _userImage.layer.borderColor = [UIColor clearColor].CGColor;
    //超出視圖的部份裁剪掉
    _userImage.layer.masksToBounds = YES;
    //---------------設置_userImage外邊框 End---------
    [self.contentView addSubview:_userImage];
    //暱稱
    _nickLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    //_nickLabel.backgroundColor=[UIColor grayColor];
    _nickLabel.font = [UIFont systemFontOfSize:14.0];
    [self.contentView addSubview:_nickLabel];
    
    //轉發數
    _repostCountLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    _repostCountLabel.backgroundColor=[UIColor clearColor];
    _repostCountLabel.font = [UIFont systemFontOfSize:12.0];
    _repostCountLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_repostCountLabel];
    //評論數(未layout)
    _commentLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    _commentLabel.backgroundColor=[UIColor grayColor];
    _commentLabel.font = [UIFont systemFontOfSize:12.0];
    _commentLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_commentLabel];
    //微博來源
    _sourceLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    _sourceLabel.backgroundColor=[UIColor clearColor];
    _sourceLabel.font = [UIFont systemFontOfSize:12.0];
    _sourceLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_sourceLabel];
    
    //發佈時間
    _createLabel =[[UILabel alloc] initWithFrame:CGRectZero];
    _createLabel.backgroundColor=[UIColor clearColor];
    _createLabel.font = [UIFont systemFontOfSize:12.0];
    _createLabel.textColor = [UIColor blueColor];
    [self.contentView addSubview:_createLabel];
    
    //微博視圖
    _weiboView= [[WeiboView alloc]initWithFrame:CGRectZero ];
    //_weiboView.backgroundColor=[UIColor orangeColor];
    [self.contentView addSubview:_weiboView];
    
    
    //被點選時的顏色
    UIImageView *selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"statusdetail_cell_sepatator.png"]];
    self.selectedBackgroundView = selectedBackgroundView ;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //------------------------用戶頭像------------------------
    _userImage.frame=CGRectMake(5, 5, 35, 35);
    NSString *userImageURL= _weiboModel.user.profile_image_url;
    [_userImage setImageWithURL:[NSURL URLWithString:userImageURL]];
    
    //------------------------用戶暱稱------------------------
    _nickLabel.frame=CGRectMake(_userImage.right+10, _userImage.top, 200, 20);
    _nickLabel.text=_weiboModel.user.screen_name;
    
    
    
    //------------------------微博視圖------------------------
    float h = [WeiboView getWeiboViewHeight:_weiboModel isSource:NO isDetail:NO];
    _weiboView.weiboModel = _weiboModel;
    _weiboView.frame=CGRectMake(_userImage.right+10, _nickLabel.bottom+10, Weibo_Width_Cell, h );
    //重新調用layoutSubViews
    [_weiboView setNeedsLayout];
    
    //------------------------發佈時間------------------------
    //返回的原格式 Fri Aug 28 00:00:00 +0800 2009
    //           E    M   d HH:mm:ss Z     yyyy
    //目標格式化05-16 14:53
    //        MM-dd HH:mm

    NSString *createDate = _weiboModel.createDate;
    if (createDate.length !=0) {
        _createLabel.hidden = NO;
        _createLabel.frame=CGRectMake(50, self.height-20, 100, 20);
        [_createLabel sizeToFit];
        /*
         //方法一
        //日期格式化
        NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
        //第一次格式化:Fri Aug 28 00:00:00 +0800 2009 轉為 日期對象
        [dateFormatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
        NSDate *date = [dateFormatter dateFromString:createDate];
        
        //第二次格式化:日期對象 轉為MM-dd HH:mm
        [dateFormatter setDateFormat:@"MM-dd HH:mm"];
        NSString *dateString =[dateFormatter stringFromDate:date];
         */
        //方法二 使用UIUtils的類方法
        _createLabel.text = [UIUtils fomateString:createDate];
    
        
    }else
    {
        _createLabel.height = YES;
    }
    
    //------------------------轉發數------------------------
    _repostCountLabel.frame=CGRectMake(_createLabel.right+10, _createLabel.top, 100, 20);
     [_repostCountLabel sizeToFit];
    //將NSNumber轉為NSString
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *repostCountToString = [numberFormatter stringFromNumber:_weiboModel.repostsCount];
    [numberFormatter release];
    NSString *String =[NSString stringWithFormat:@"轉發數: %@", repostCountToString];
    _repostCountLabel.text=String;

    
    //------------------------微博來源------------------------
    //用什麼客戶端發的來源
    //"source:"<a href= "http://weibo.com" rel="nofollow">新浪微博</a>"
    NSString *source = _weiboModel.source;
    NSString *regex = @">\\w+<";
    NSArray *array = [source componentsMatchedByRegex:regex];
    //判斷有無資料,防止array越界
    if (array.count > 0) {
        // >新浪微博<
        NSString *ret = [array objectAtIndex:0];
        //字串分割
        NSRange range;
        range.location =1;
        range.length =ret.length - 2;
        NSString *resultString= [ret substringWithRange:range];
        _sourceLabel.text = resultString;
        _sourceLabel.frame = CGRectMake(_repostCountLabel.right+10,_createLabel.top, 100, 20);
        [_sourceLabel sizeToFit];
    }
    
    
}

@end
