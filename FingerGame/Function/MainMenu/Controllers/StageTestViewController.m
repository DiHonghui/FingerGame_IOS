//
//  StageTestViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/6/23.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "StageTestViewController.h"
#import "GameStageTableViewCell.h"
#import "MJRefresh.h"
#import "MissionModel.h"
#import "MissionSimpleForList.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "MissionlistApiManager.h"
#import "GameFileApiManager.h"
#import "GVUserDefaults+Properties.h"
#import "GameDetailViewController.h"
#import "CostValueTableViewCell.h"
#import "HLXibAlertView.h"
#import "RechargeDiomondApiManager.h"
#import "MyAlertCenter.h"

#define GSTVCELL @"GameStageTableViewCell"

@interface StageTestViewController ()
//@property (strong ,nonatomic)UITableView* stageTableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *stageTableView;
//@property (strong,nonatomic)UIView* headerView;

@property (strong, nonatomic) MissionlistApiManager *missionlistApiManager;
@property (strong,nonatomic) GameFileApiManager *gameFileApiManager;
@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;
@property (strong,nonatomic) NSMutableArray* dataSource;


@end

@implementation StageTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *bgImage = [UIImage imageNamed:@"Game_Background.png"];
//    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    self.stageTableView.backgroundColor =[UIColor colorWithPatternImage:bgImage];
    self.headerView.backgroundColor = [UIColor whiteColor];
    //[bgImage release];
    self.title = @"精品列表";
    self.stageTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{;}];
    // Do any additional setup after loading the view from its nib.
    [self.stageTableView.mj_header beginRefreshing];
}

-(void)loadData{
    NSMutableArray* tempdataSource = [[NSMutableArray alloc]init];
    [self.missionlistApiManager loadDataWithParams:@{@"service":@"App.Game.GameList",@"userId":[GVUserDefaults standardUserDefaults].userId} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        [self.stageTableView.mj_header endRefreshing];
        [self.dataSource removeAllObjects];
        NSLog(@"datasource 删除了数据");
        NSDictionary *news = responseData[@"data"];
        for (NSDictionary *tmp in news) {
            MissionModel *modelForList = [MissionModel yy_modelWithJSON:tmp];
            NSLog(@"loadData simpleModel = %@",modelForList);
            [self.dataSource addObject:modelForList];
            //[self.dataSource addObject:modelForList];
        }
        NSLog(@"datasource 里面是%@",tempdataSource);
        
    }];
    [self.stageTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.stageTableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.stageTableView) {
        return [self.dataSource count];
    }else{
        return 0;
    }
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
    NSLog(@"收藏状态是%@",missionModel.like);
    [cell configureCell:missionModel];
    cell.delegate = self.stageTableView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}



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

-(RechargeDiomondApiManager*) rechargeApiManager{
    if (!_rechargeApiManager) {
        _rechargeApiManager = [[RechargeDiomondApiManager alloc]init];
    }
    return _rechargeApiManager;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
