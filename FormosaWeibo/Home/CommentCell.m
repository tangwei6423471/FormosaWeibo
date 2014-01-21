//
//  CommentCell.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/20.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "CommentCell.h"
#import "UIImageView+WebCache.h"
#import "CommentModel.h"
#import "UIUtils.h"
@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//通過NSBundle創的cell 會調用這方法初始化(Xib)
//通過nib文件創建view對象是執行awakeFromNib
-(void)awakeFromNib
{
    [super awakeFromNib];
    _rtTextLabel = [[RTLabel alloc] initWithFrame:CGRectZero];
    _rtTextLabel.font = [UIFont systemFontOfSize:14.0f];
    _rtTextLabel.delegate =self;
    //link的顏色
    _rtTextLabel.linkAttributes = [NSDictionary dictionaryWithObject:@"#4595CB" forKey:@"color"];
    //設置選中link時的顏色
    _rtTextLabel.selectedLinkAttributes = [NSDictionary dictionaryWithObject:@"darkGray" forKey:@"color"];
    [self.contentView addSubview:_rtTextLabel];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    //通過Tag值取得用戶頭象視圖 tag值在Xib內設好了
    UIImageView *userImage = (UIImageView *)[self.contentView viewWithTag:100];
    userImage.frame = CGRectMake(10, 10, 40, 40);
    userImage.layer.cornerRadius = 5;
    userImage.layer.masksToBounds = YES;
    userImage.layer.borderColor = [ UIColor grayColor].CGColor;
    userImage.layer.borderWidth = 1;
    NSString *urlstring =  _commentModel.user.profile_image_url;
    [userImage setImageWithURL:[NSURL URLWithString:urlstring]];
    
    //暱稱
    UILabel *nickLabel = (UILabel *)[self.contentView viewWithTag:101];
    nickLabel.text = _commentModel.user.screen_name;
    
    //發佈時間
    UILabel *timeLabel = (UILabel *)[self.contentView viewWithTag:102];
     timeLabel.text = [UIUtils fomateString:_commentModel.created_at];
    //評論內容
    _rtTextLabel.frame = CGRectMake(userImage.right+10, nickLabel.bottom+5, 240, 21);
    _rtTextLabel.text =[UIUtils parseLink:_commentModel.text];
    _rtTextLabel.height = _rtTextLabel.optimumSize.height;

}
// 計算評論內容的高度
+ (float)getCommentHeight:(CommentModel *)commentModel
{
    RTLabel *rt = [[RTLabel alloc] initWithFrame:CGRectMake(0, 0, 240, 0)];
    rt.font= [UIFont systemFontOfSize:14.0f];
    rt.text = commentModel.text;

    return rt.optimumSize.height;
}

- (void)rtLabel:(id)rtLabel didSelectLinkWithURL:(NSURL*)url
{
     [UIUtils openLink:url view:self];
}

@end
