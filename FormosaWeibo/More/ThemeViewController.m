//
//  ThemeViewController.m
//  FormosaWeibo
//
//  Created by Joey on 2013/12/5.
//  Copyright (c) 2013年 Joey. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeManager.h"
#import "UIFactory.h"

@interface ThemeViewController ()

@end

@implementation ThemeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      
        self.title=@"主題切換";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _themes = [[ThemeManager shareInstance].themeConfig allKeys] ;
    [_themes retain];//NSArray由自動釋放池管控,避免他被誤判釋放所以retain
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _themes.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify=@"themeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell==nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify ] autorelease];
        //--------設置主題Lable---------
        UILabel *textLable = [UIFactory createLable:kThemeListLabel];
        textLable.frame=CGRectMake(10, 10, 200, 30);
        textLable.backgroundColor = [UIColor clearColor];
        textLable.font = [UIFont boldSystemFontOfSize:18.0f];
        textLable.tag=2013;
        [cell.contentView addSubview:textLable];
        //--------設置主題Lable End---------
    }
    
    UILabel *textLable = (UILabel *)[cell.contentView viewWithTag:2013];
    textLable.text=_themes[indexPath.row];
    //cell.textLabel.text=_themes[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取得選中的主題名稱
    NSString *themeName= _themes[indexPath.row];
    
    [ThemeManager shareInstance].themeName=themeName;
    
    //發送通知
    [[NSNotificationCenter defaultCenter]postNotificationName:kThemeDidChangeNotification object:themeName ];
    
    
    //保存主題到本地
    [[NSUserDefaults standardUserDefaults] setObject:themeName forKey:kThemeName];
    //同步保存到本地
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
