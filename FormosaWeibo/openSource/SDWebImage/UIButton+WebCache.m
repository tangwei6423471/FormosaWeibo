//
//  UIButton+WebCache.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/16.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"
@implementation UIButton (WebCache)
- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];
    
    [self setImage:placeholder forState:UIControlStateNormal];
    
    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
    
        self.alpha = 0.0;
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.6];
        self.alpha = 1.0;
        [UIView commitAnimations];
}
@end
