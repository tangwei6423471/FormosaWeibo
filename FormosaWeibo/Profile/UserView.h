//
//  UserView.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/19.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RectButton;
@class UserModel;
@interface UserView : UIView

@property(nonatomic,retain)UserModel *user;

@property (retain, nonatomic) IBOutlet UIImageView *userImage;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;

@property (retain, nonatomic) IBOutlet UILabel *addressLabel;
@property (retain, nonatomic) IBOutlet UILabel *infoLabel;
@property (retain, nonatomic) IBOutlet RectButton *attButton;

@property (retain, nonatomic) IBOutlet RectButton *fansButton;

@property (retain, nonatomic) IBOutlet UILabel *countLabel;

- (IBAction)attAction:(id)sender;
- (IBAction)fansAction:(id)sender;

@end
