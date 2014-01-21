//
//  UserGridView.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface UserGridView : UIView
{
    //放垮號內會成為 私有的
    
    IBOutlet UIButton *imageButton;
    IBOutlet UILabel *nickLabel;
    IBOutlet UILabel *fansLabel;
}
@property(nonatomic,retain)UserModel *user;

@end
