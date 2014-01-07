//
//  BrowModeViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2014/1/7.
//  Copyright (c) 2014年 Joey. All rights reserved.
//

#import "BrowModeViewController.h"

@interface BrowModeViewController ()

@end

@implementation BrowModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"圖片瀏覽模式";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  2;

}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify ] autorelease];
    }
    if (indexPath.row == 0)
    {
        cell.textLabel.text=@"大圖";
    }
    else if (indexPath.row == 1 )
    {
        cell.textLabel.text=@"小圖";
        
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int mode = smallMode;
    if (indexPath.row == 0)
    {
         mode = LargeMode;

    }else if(indexPath.row == 1)
    {

       mode = smallMode;

    }
    //將瀏覽模式存到本地
    [[NSUserDefaults standardUserDefaults] setInteger:mode forKey:kBrowMode];
    [[NSUserDefaults standardUserDefaults] synchronize] ;

    //發送刷新微博列表的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kReloadWeiboTableNotification object:nil];
    //pop彈出返回
    [self.navigationController popToRootViewControllerAnimated:YES];

}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
