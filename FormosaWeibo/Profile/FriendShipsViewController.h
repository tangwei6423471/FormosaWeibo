//
//  FriendShipsViewController.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "BaseViewController.h"
#import "FriendShipTableView.h"
//typedef enum
//{
//   Attention,//關注列表
//   Fans     //粉絲列表
//
//}FriendshipType;
//Ios 定義enum的方式
typedef NS_ENUM(NSInteger, FriendshipType) {
    Attention,//關注列表
    Fans     //粉絲列表
};


@class FriendShipTableView;
@interface FriendShipsViewController : BaseViewController<BaseTableViewRefreshDelegate>
{   //大數組
    NSMutableArray *_data;
}
@property (retain, nonatomic) IBOutlet FriendShipTableView *tableView;
//列表類型 enum為基本數據類型
@property (nonatomic,assign) FriendshipType shipType;
@property(nonatomic,copy) NSString *userID;


@end
