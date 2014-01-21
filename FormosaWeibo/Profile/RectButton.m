//
//  RectButton.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/19.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//複寫setTitle
-(void)setTitle:(NSString *)title
{
    
    if(_title !=title)
    {
        [_title release];
        _title= [title copy];
    }
      [self setTitle:nil forState:UIControlStateNormal];
    
    if (_rectTitleLabel == nil && _title !=nil) {
        _rectTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _rectTitleLabel.backgroundColor = [UIColor clearColor];
        _rectTitleLabel.textColor = [UIColor blackColor];
        _rectTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_rectTitleLabel];
    }
     [self setNeedsLayout];
    
}
-(void)setSubTitle:(NSString *)subTitle
{
    
    if(_subTitle !=subTitle)
    {
        [_subTitle release];
        _subTitle= [subTitle copy];
    }
    
  

    if (_subTitleLabel == nil &&_subTitle != nil) {
        _subTitleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor = [UIColor blueColor];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitleLabel];

    }
    
    [self setNeedsLayout];

}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_subTitleLabel !=nil) {
        _subTitleLabel.frame = CGRectMake(0, 15, self.width, 20);
        _subTitleLabel.text = self.subTitle;
    }
    
    if (_rectTitleLabel !=nil) {
        _rectTitleLabel.text = self.title;
        _rectTitleLabel.frame = CGRectMake(0, _subTitleLabel.bottom, self.width, 20);
        
        if (_subTitleLabel == nil) {
            _rectTitleLabel.top = (self.height - _rectTitleLabel.height)/2;
        }
    }
    
    


}

@end
