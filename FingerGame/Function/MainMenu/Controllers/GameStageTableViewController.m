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
#import "GameDetailViewController.h"
#import "CostValueTableViewCell.h"
#import "HLXibAlertView.h"
#import "RechargeDiomondApiManager.h"
#import "MyAlertCenter.h"

#define GSTVCELL @"GameStageTableViewCell"

@interface GameStageTableViewController ()

@property (strong, nonatomic) MissionlistApiManager *missionlistApiManager;

@property (strong,nonatomic) GameFileApiManager *gameFileApiManager;

@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;

@end

@implementation GameStageTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"游戏列表";
    __weak typeof (self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    [weakself loadData];
    [self.tableView.mj_header beginRefreshing];
    
    // Do any additional setup after loading the view.
}

-(void)loadData{
    NSMutableArray* tempdataSource = [[NSMutableArray alloc]init];
    [self.missionlistApiManager loadDataWithParams:@{@"service":@"App.Game.GameList",@"userId":[GVUserDefaults standardUserDefaults].userId} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        [self.tableView.mj_header endRefreshing];
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
//        for (MissionSimpleForList *modelForlist in tempdataSource) {
//            self.gameFileApiManager = [[GameFileApiManager alloc]initWithGameId:modelForlist.gameId];
//            [self.gameFileApiManager loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
//                NSDictionary *news = responseData[@"data"];
//                for (NSDictionary *tmp in news) {
//                    MissionModel *model = [MissionModel yy_modelWithJSON:tmp];
//                    NSLog(@"loadData model = %@",model);
//                    [self.dataSource addObject:model];
//                    NSLog(@"datasource 添加了数据");
//                }
//            }];
//        }
    }];
    [self.tableView reloadData];
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return 1;
    //NSLog(@"dataSource count = @%@",self.dataSource);
    if (section == 0 ) {
        return 1;
    }
    return [self.dataSource count];
    //返回显示几条数据
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
        CostValueTableViewCell *cell = (CostValueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CostValueTableViewCell"];
        if (!cell) {
            UINib* nib = [UINib nibWithNibName:@"CostValueTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"CostValueTableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CostValueTableViewCell"];
        }
        [cell configureCell];
        cell.user_delegate = self;
        return cell;
    }
    
    GameStageTableViewCell *cell = (GameStageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GSTVCELL];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:GSTVCELL bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GSTVCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:GSTVCELL];
    }
    MissionModel *missionModel = self.dataSource[indexPath.row];
    NSLog(@"收藏状态是%@",missionModel.like);
    [cell configureCell:missionModel];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return;
    }
    NSInteger energyint = [[GVUserDefaults standardUserDefaults].energy integerValue ];
    if (energyint < 20) {
        [self alertViewWithXib];
    }else{
        energyint = energyint - 20;
        [GVUserDefaults standardUserDefaults].energy = [NSString stringWithFormat:@"%ld", energyint];
        GameDetailViewController *vc = [[GameDetailViewController alloc] initWithGameName:@"手指操"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

-(void)buyDiomond{
    UIAlertController *userIconActionSheet = [UIAlertController alertControllerWithTitle:@"请选择充值数额" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //相册选择
    UIAlertAction *addDiomond5 = [UIAlertAction actionWithTitle:@"充值50个" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"通过代理充值50个钻石");
        NSInteger number = 50;
        [self chargeDiomond:&number];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        NSLog(@"取消");
    }];
    [userIconActionSheet addAction:addDiomond5];
    //[userIconActionSheet addAction:photoAction];
    [userIconActionSheet addAction:cancelAction];
    [self presentViewController:userIconActionSheet animated:YES completion:nil];
}

-(void)buyEnergy{
    UIAlertController *userIconActionSheet = [UIAlertController alertControllerWithTitle:@"请选择增加体力" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //相册选择
    UIAlertAction *addEnergy = [UIAlertAction actionWithTitle:@"消耗健康豆补满体力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"通过代理充补满体力");
        [self chargeEnergy];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //取消
        NSLog(@"取消");
    }];
    [userIconActionSheet addAction:addEnergy];
    //[userIconActionSheet addAction:photoAction];
    [userIconActionSheet addAction:cancelAction];
    [self presentViewController:userIconActionSheet animated:YES completion:nil];
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

-(RechargeDiomondApiManager*) rechargeApiManager{
    if (!_rechargeApiManager) {
        _rechargeApiManager = [[RechargeDiomondApiManager alloc]init];
    }
    return _rechargeApiManager;
}


- (void)alertViewWithXib{
    
    [HLXibAlertView alertWithTittle:@"体力不足" message:@"请购买体力" block:^(NSInteger index) {
        if (index == XibAlertBlockSureButtonClick) {
            [self alertSureButtonClick];
        }else{
            [self alertCauseButtonClick];
        }
    }];
}

-(void)chargeDiomond:(NSInteger *)number{
    if (number!=0) {
        NSLog(@"触发充值按钮");
        NSString* sNumber = [NSString stringWithFormat:@"%ld", number];
        [self.rechargeApiManager loadDataWithParams:@{@"user_id":[GVUserDefaults standardUserDefaults].userId,@"amount":sNumber,@"service":@"App.User.Recharge"} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            //NSLog(@"充值结果为%@", responseData[@"data"][@"message"]);
        }];
        NSLog(@"update sucess");
    }
}

-(void)chargeEnergy{
    [GVUserDefaults standardUserDefaults].energy = @"100";
}


- (void)alertSureButtonClick{
    NSLog(@"点击了确认按钮");
    [self buyEnergy];
}

- (void)alertCauseButtonClick{
    NSLog(@"点击了取消按钮");
}

@end
