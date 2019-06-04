//
//  OptionsViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/5.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "OptionsViewController.h"
#import "MJRefresh.h"
#import "PersonalPageViewController.h"
#import "GVUserDefaults+Properties.h"
#import "BasicTableViewCell.h"
#import "PersonalInfoBasicTableViewCell.h"
#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"
#import "BTViewController.h"
#import "FingerprintListTableViewController.h"

@interface OptionsViewController ()

//@property(readwrite,assign,nonatomic)NSInteger *number;

@end
@implementation OptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    self.tableView.separatorColor = [UIColor clearColor];
    self.title = @"设置";
    [self loadData];
    }

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //[self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //NSLog(@"dataSource count = @%@",self.dataSource);
    //return [self.dataSource count];
    //返回显示几条数据
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.font = SystemFont(60);
        //cell.textLabel.text = @"test";
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.multipleTouchEnabled = false;
        return cell;
    }
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"清理缓存";
        cell.textLabel.font = SystemFont(28);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"蓝牙设置";
        cell.textLabel.font = SystemFont(28);
        cell.textLabel.textColor = UIColorFromRGB(0x66666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"指纹录入";
        cell.textLabel.font = SystemFont(28);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"隐私政策";
    cell.textLabel.font = SystemFont(28);
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.section == 2) {
        BTViewController *btvc = [[BTViewController alloc]init];
        [self.navigationController pushViewController:btvc animated:YES];
    }
    if (indexPath.section == 3) {
        FingerprintListTableViewController *ftvc = [[FingerprintListTableViewController alloc]init];
        [self.navigationController pushViewController:ftvc animated:YES];
    }
}


-(void)loadData{
    [self.tableView reloadData];
}
@end
