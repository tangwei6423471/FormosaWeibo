//
//  UIView+Additions.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/18.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "UIView+Additions.h"

@implementation UIView (Additions)

-(UIViewController *)GetSelfViewController
{
    //得到下一個響應者
    UIResponder *next = [self nextResponder];
    do {
        //如果找到了
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        
        next = [next nextResponder];
    } while (next != nil);
    
    
    return nil;
}

@end
