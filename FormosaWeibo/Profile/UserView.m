//
//  UserView.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/19.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "UserView.h"
#import "UserModel.h"
#import "RectButton.h"
#import "UIImageView+WebCache.h"
#import "FriendShipsViewController.h"
@implementation UserView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //code與xib混和用法(推薦使用)
        //此xib作為userView的子視圖 (xib當作一的View處理) 在add上userView
        UIView *userView =[[[NSBundle mainBundle] loadNibNamed:@"UserInfoView" owner:self options:nil] lastObject];
        userView.backgroundColor = Color(245, 245, 245, 1);
        [self addSubview:userView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //用戶頭像
    NSString *urlString = self.user.avatar_large;
    //有默認圖的話調用這方法
    [self.userImage setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:[UIImage imageNamed:@"page_image_loading.png"]];
    
    //暱稱
    self.nameLabel.text = self.user.screen_name;
    //--------------------
    //性別
    NSString *gender = self.user.gender;
    NSString *sexName = @"未知";
    if ([gender isEqualToString:@"f"]) {
        sexName = @"女";
        
    }else if([gender isEqualToString:@"m"])
    {
        sexName = @"男";
    }
    
    //地址
    NSString *location = self.user.location;
    if (location == nil) {
        location = @" ";
    }
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",sexName,location];
     //--------------------
    //簡介
    self.infoLabel.text = (self.user.debugDescription == nil) ? @"":self.user.debugDescription;
    
    
    //微博數
   
    NSString *countString = [self.user.statuses_count stringValue];
    self.countLabel.text = [NSString stringWithFormat:@"共%@條微博",countString];
    
    
    //關注數
    long friends = [_user.friends_count longValue];
    _attButton.title = @"關注";
    _attButton.subTitle = [NSString stringWithFormat:@"%ld",friends];
    //粉絲數
    long fans = [_user.followers_count longValue];
    _fansButton.title = @"粉絲";
    if (fans >= 10000) {
        fans = fans /10000;
        _fansButton.subTitle = [NSString stringWithFormat:@"%ld萬",fans];
    }else
    {
        _fansButton.subTitle = [NSString stringWithFormat:@"%ld",fans];
    }
    

}

- (void)dealloc {
    [_userImage release];
    [_addressLabel release];
    [_infoLabel release];
    [_attButton release];
    [_fansButton release];
    [_countLabel release];
    [_infoLabel release];
    [_nameLabel release];
    [super dealloc];
}

- (IBAction)attAction:(id)sender
{
    FriendShipsViewController *friendships = [[FriendShipsViewController alloc] init];
    friendships.userID = _user.idstr;
    //關注列表類型
    friendships.shipType = Attention;
    [self.GetSelfViewController.navigationController pushViewController:friendships animated:YES];
    [friendships release];
    
}
//粉絲數
- (IBAction)fansAction:(id)sender
{
    FriendShipsViewController *friendships = [[FriendShipsViewController alloc] init];
    friendships.userID = _user.idstr;
    //粉絲列表類型
    friendships.shipType = Fans;
    [self.GetSelfViewController.navigationController pushViewController:friendships animated:YES];
    [friendships release];
}
@end
