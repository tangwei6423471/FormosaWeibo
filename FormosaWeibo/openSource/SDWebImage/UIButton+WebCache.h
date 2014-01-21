//
//  UIButton+WebCache.h
//  FormosaWeibo
//
//  Created by Joey on 2014/1/16.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"
@interface UIButton (WebCache)<SDWebImageManagerDelegate>


- (void)setImageWithURL:(NSURL *)url;
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
- (void)cancelCurrentImageLoad;

@end
