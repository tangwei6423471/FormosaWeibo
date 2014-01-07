//
//  MoreViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/3.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeViewController.h"
#import "BrowModeViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       self.title=@"更多";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 2;
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
        cell.textLabel.text=@"主題";
    }
    else if (indexPath.row == 1 )
    {
        cell.textLabel.text=@"圖片瀏覽模式";
    
    }
    
    
  
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row== 0) {
        ThemeViewController *themeCtrl =[[ ThemeViewController alloc]init];
        [self.navigationController pushViewController:themeCtrl animated:YES];
        [themeCtrl release];
    }
    else if (indexPath.row == 1 )
    {
        BrowModeViewController *browModel = [[BrowModeViewController alloc] init];
        [self.navigationController pushViewController:browModel animated:YES];
        [browModel release];
        
    }

}

@end
