//
//  CommentTableView.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/30.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "CommentTableView.h"
#import "CommentCell.h"
#import "CommentModel.h"
@implementation CommentTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

//---------------------------TableView--------------------
#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *identify = @"CommentCell";
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        //Xib創cell的方式
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CommentCell" owner:self options:nil] lastObject];

    }
    cell.commentModel =  [self.data objectAtIndex:indexPath.row];

    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *comment = [self.data objectAtIndex:indexPath.row];
    float height = [CommentCell getCommentHeight:comment];
    return height +40 ;
}
//設置section高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
//section的頭視圖設置
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 40)];
    sectionHeaderView.backgroundColor = [UIColor whiteColor];
    //評論數Label
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    countLabel.backgroundColor = [UIColor clearColor];
    countLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    countLabel.textColor = [UIColor blueColor];

    NSNumber *total = [self.commentDic objectForKey:@"total_number"];
    int value = [total intValue];
    countLabel.text = [NSString stringWithFormat:@"評論數:%d",value];
    [sectionHeaderView addSubview:countLabel];
    [countLabel release];

    return [sectionHeaderView autorelease];

}
//---------------------------TableView End--------------------

@end
