//
//  FriendShipTableView.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/21.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "FriendShipTableView.h"
#import "FriendShipsCell.h"
@implementation FriendShipTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"UserCell";
    FriendShipsCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[[FriendShipsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease ];
    }
    //因為FriendShipsViewController.m ->refreshDown 會removeAllObjects ,造成這裡crash
    //所以判斷data內是否有資料,如果沒有則 什麼事都不做
    if(self.data.count == 0)
    {
        //NSLog(@"沒資料");
    }else
    {
        cell.userData = [self.data objectAtIndex:indexPath.row];
    }
    
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}

@end
