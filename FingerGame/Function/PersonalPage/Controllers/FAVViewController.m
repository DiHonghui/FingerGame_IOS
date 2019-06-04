//
//  FAVViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/6/4.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "FAVViewController.h"
#import "MJRefresh.h"
#import "PersonalPageViewController.h"
#import "GVUserDefaults+Properties.h"
#import "BasicTableViewCell.h"
#import "PersonalInfoBasicTableViewCell.h"
#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"

@interface FAVViewController ()

@end




static NSInteger number;
@implementation FAVViewController

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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
        // 1. 更新数据
        
        //[self.dataSource removeObjectAtIndex:indexPath.row];
        
        // 2. 更新UI
        
    }
                                       ];
    return @[rowAction];
    
}
//- (NSArray*)tableView:(UITableView*)tableView editActionsForRowAtIndexPath:(NSIndexPath*)indexPath{
//    UITableViewRowAction *rowAction =[UITableViewRowActionrowActionWithStyle:UITableViewRowActionStyleDefaulttitle:@"删除"handler:^(UITableViewRowAction*_Nonnullaction,NSIndexPath*_NonnullindexPath) {
//    NSLog(@"删除要实现的代码");
//
//}];
//    UITableViewRowAction*rowAction1 = [UITableViewRowActionrowActionWithStyle:UITableViewRowActionStyleDefaulttitle:@"标为已读"handler:^(UITableViewRowAction*_Nonnullaction,NSIndexPath*_NonnullindexPath) {
//        NSLog(@"标为已读要实现的代码");
//
//    }];
//    //自定义颜色rowAction.backgroundColor=RGB(231,96,35);rowAction1.backgroundColor=RGB(150,150,150);NSArray*arr =@[rowAction,rowAction1];return arr;}
//
//}
-(void)loadData{
    number = 0;
}

@end
