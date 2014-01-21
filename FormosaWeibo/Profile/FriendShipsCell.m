//
//  FriendShipsCell.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "FriendShipsCell.h"
#import "UserGridView.h"
#import "UserModel.h"

@implementation FriendShipsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
        //去除選中效果
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)_initViews
{
    for (int i = 0; i<3; i++) {
        UserGridView *gridView= [[UserGridView alloc] initWithFrame:CGRectZero];
        gridView.tag = 2014+ i;
        [self.contentView addSubview:gridView];
        [gridView release];
    }

}
////複寫setUserData
//-(void)setUserData:(NSArray *)userData
//{
//    if (_userData !=userData) {
//        [_userData release];
//        _userData = [userData retain];
//    }
//   
//
//}
-(void)layoutSubviews
{
    
    //先全隱藏gridView 視圖
    for (int i = 0; i<3; i++)
    {
        
        int tag = 2014 +i;
        UserGridView *gridView=(UserGridView *) [self.contentView viewWithTag:tag];
        gridView.hidden = YES;
        
    }
    
    //遍歷用戶數據,有幾個就顯示幾個
    for (int i = 0; i<_userData.count; i++)
    {
        int tag = 2014 +i;
        UserGridView *gridView=(UserGridView *) [self.contentView viewWithTag:tag];
        gridView.frame = CGRectMake(100 * i +12 , 10, 96, 96);
        gridView.hidden =NO;
        UserModel *userModel = [_userData objectAtIndex:i];
        gridView.user = userModel;
        [gridView setNeedsLayout];
    }


}


@end
