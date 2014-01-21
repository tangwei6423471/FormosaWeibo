//
//  RectButton.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/19.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RectButton : UIButton
{
    UILabel *_rectTitleLabel;
    UILabel *_subTitleLabel;
}


@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subTitle;
@end
