//
//  FavoritesTableViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/6.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "FavoritesTableViewController.h"
#import "MJRefresh.h"
#import "PersonalPageViewController.h"
#import "GVUserDefaults+Properties.h"
#import "BasicTableViewCell.h"
#import "PersonalInfoBasicTableViewCell.h"
#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"

@interface FavoritesTableViewController ()

@end
static NSInteger number;
@implementation FavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [super viewDidLoad];
    self.title = @"收藏列表";
    __weak typeof (self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];}

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    //NSLog(@"dataSource count = @%@",self.dataSource);
    //return [self.dataSource count];
    //返回显示几条数据
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSString *string = [[NSString alloc] initWithFormat:@"%@%@", @"已收藏歌曲 ",[NSString stringWithFormat:@"%ld",++number ] ];
    cell.textLabel.text = string;
    cell.textLabel.font = SystemFont(14);
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

-(void)loadData{
    number = 0;
}
@end
