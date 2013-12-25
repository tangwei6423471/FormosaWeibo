//
//  CommentCell.h
//  FormosaWeibo
//
//  Created by Joey on 2013/12/20.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"
@class CommentModel;

@interface CommentCell : UITableViewCell<RTLabelDelegate>
{

    RTLabel *_rtTextLabel;


}
@property(nonatomic,retain)CommentModel *commentModel;


/**
 *  計算評論內容的高度
 *
 *  @param commentModel commentModel
 *
 *  @return comment內容的高度
 */
+ (float)getCommentHeight:(CommentModel *)commentModel;



@end
