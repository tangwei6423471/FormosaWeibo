//
//  UserGridView.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "UserGridView.h"
#import "UserModel.h"
#import "UIButton+WebCache.h"
@implementation UserGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //code與xib混和用法(推薦使用)
        //此xib作為userView的子視圖 (xib當作一的View處理) 在add上userView
        UIView *userView =[[[NSBundle mainBundle] loadNibNamed:@"UserGridView" owner:self options:nil] lastObject];
        //userView.backgroundColor = Color(245, 245, 245, 1);
        [self addSubview:userView];
        //賦給size
        self.size = userView.size;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //暱稱
    nickLabel.text = _user.screen_name;
    //用戶圖像
    NSString *urlString = _user.profile_image_url;
    [imageButton setImageWithURL:[NSURL URLWithString:urlString]];
    
    //粉絲數
    long fansValue = [self.user.followers_count longLongValue];
    if (fansValue >=10000) {
        fansValue /= 10000;
        fansLabel.text = [NSString stringWithFormat:@"%ld萬粉絲",fansValue];
    }
     fansLabel.text = [NSString stringWithFormat:@"%ld粉絲",fansValue];

}

- (void)dealloc {
    [imageButton release];
    [nickLabel release];
    [fansLabel release];
    [super dealloc];
}
@end
