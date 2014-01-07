//
//  WeiboTableView.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/23.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboView.h"

@implementation WeiboTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //監聽刷新的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil ];
       
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

-(void)awakeFromNib
{
    //調用父類的awakeFromNib,不然這裡會複寫父類,就不會調用_initViews
    [super awakeFromNib];
    //監聽刷新的通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:kReloadWeiboTableNotification object:nil ];
    
}

//----------------------TableView Delegate-------------------
#pragma mark- TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"WeiboCell";
    WeiboCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell=[[[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify]autorelease ];
        
    }
    
    
    
    
    //賦給cell數據
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    cell.weiboModel=weibo;
    NSLog(@"%@",weibo);
    return cell;
    
}
//設置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WeiboModel *weibo = [self.data objectAtIndex:indexPath.row];
    float height = [WeiboView getWeiboViewHeight:weibo isSource:NO isDetail:NO];
    //height加上頭像視圖 和邊緣高度 以及發佈時間
    return height +=60;
}
//選中的cell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
////    DetailViewController *detail = [[DetailViewController alloc] init];
////    //賦給數據
////    detail.weiboModel = [_data objectAtIndex:indexPath.row];
////    [self.navigationController pushViewController:detail animated:YES];
////    [detail release];
////    
////    //清除選中效果
////    [tableView deselectRowAtIndexPath:indexPath animated:YES];
////    
//}
//----------------------TableView Delegate End-------------------
@end
