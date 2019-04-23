//
//  GameStageTableViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/1.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTableViewController.h"
#import "GameStageTableViewCell.h"
#import "MJRefresh.h"
#import "MissionModel.h"
#import "MissionSimpleForList.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "MissionlistApiManager.h"
#import "GameFileApiManager.h"
#import "GVUserDefaults+Properties.h"
#import "GameStageTableViewCell.h"

#define GSTVCELL @"GameStageTableViewCell"

@interface GameStageTableViewController ()

@property (strong, nonatomic) MissionlistApiManager *missionlistApiManager;

@property (strong,nonatomic) GameFileApiManager *gameFileApiManager;

@end

@implementation GameStageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏列表";
    __weak typeof (self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    NSMutableArray* tempdataSource = [[NSMutableArray alloc]init];
    [self.missionlistApiManager loadDataWithParams:@{@"userId":[GVUserDefaults standardUserDefaults].userId,@"service":@"App.Game.GameList"} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        [self.tableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        NSLog(@"datasource 删除了数据");
            NSDictionary *news = responseData[@"data"][@"1"];
            for (NSDictionary *tmp in news) {
                MissionSimpleForList *modelForList = [MissionSimpleForList yy_modelWithJSON:tmp];
                NSLog(@"loadData simpleModel = %@",modelForList);
                [tempdataSource addObject:modelForList];
                //[self.dataSource addObject:modelForList];
            }
        NSLog(@"datasource 里面是%@",tempdataSource);
        for (MissionSimpleForList *modelForlist in tempdataSource) {
            self.gameFileApiManager = [[GameFileApiManager alloc]initWithGameId:modelForlist.gameId];
            [self.gameFileApiManager loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
                NSDictionary *news = responseData[@"data"];
                for (NSDictionary *tmp in news) {
                    MissionModel *model = [MissionModel yy_modelWithJSON:tmp];
                    NSLog(@"loadData model = %@",model);
                    [self.dataSource addObject:model];
                    NSLog(@"datasource 添加了数据");
                }
            }];
        }
    }];
    [self.tableView  reloadData];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    NSLog(@"dataSource count = @%@",self.dataSource);
    return [self.dataSource count];
    //返回显示几条数据
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameStageTableViewCell *cell = (GameStageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GSTVCELL];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:GSTVCELL bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GSTVCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:GSTVCELL];
    }
    MissionModel *missionModel = self.dataSource[indexPath.row];
    [cell configureCell:missionModel];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate toMain];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(MissionlistApiManager*) missionlistApiManager{
    if (!_missionlistApiManager) {
        _missionlistApiManager = [[MissionlistApiManager alloc]init];
    }
    return _missionlistApiManager;
}

-(GameFileApiManager*) gameFileApiManager{
    if (!_gameFileApiManager) {
        _gameFileApiManager = [[GameFileApiManager alloc]init];
    }
    return _gameFileApiManager;
}


@end
