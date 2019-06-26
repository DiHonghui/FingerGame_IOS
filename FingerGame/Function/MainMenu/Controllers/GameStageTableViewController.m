//
//  GameStageTableViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/1.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTableViewController.h"
#import "GameDetailViewController.h"
#import "MainGameViewController.h"

#import "GameStageTableViewCell.h"
#import "MJRefresh.h"
#import "MissionSimpleForList.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "GVUserDefaults+Properties.h"
#import "CostValueTableViewCell.h"
#import "HLXibAlertView.h"
#import "NSObject+ProgressHUD.h"

#import "MissionlistApiManager.h"
#import "GameFileApiManager.h"
#import "RechargeDiomondApiManager.h"
#import "MyAlertCenter.h"
#import "AudioManager.h"
#import "MyBTManager.h"

#import "MissionModel.h"
#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"

#import "LoadResourceTipView.h"
#define GSTVCELL @"GameStageTableViewCell"

@interface GameStageTableViewController () <MyBTManagerProtocol>

@property (strong, nonatomic) MissionlistApiManager *missionlistApiManager;

@property (strong,nonatomic) GameFileApiManager *gameFileApiManager;

@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;

@property (nonatomic,strong) MyBTManager *curBTManager;
//准备发送给蓝牙串口的指令数组
@property (nonatomic,strong) NSMutableArray *ordersArray;
//本地游戏指令保存，用于游戏滑块的初始化
@property (nonatomic,strong) GameOrderFile *gameOrderFile;
//音频下载、播放操作工具
@property (nonatomic,strong) AudioManager *curAudioManager;
//
@property (nonatomic,strong) MissionModel *curMissionModel;

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
    //
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


#pragma mark - tableview delegate
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
//        [GVUserDefaults standardUserDefaults].energy = [NSString stringWithFormat:@"%ld", energyint];
//        GameDetailViewController *vc = [[GameDetailViewController alloc] initWithGameId:((MissionModel *)self.dataSource[indexPath.row]).missionID];
//        [self.navigationController pushViewController:vc animated:YES];
        self.ordersArray = [NSMutableArray array];
        self.gameOrderFile = [[GameOrderFile alloc] init];
        self.curMissionModel = [[MissionModel alloc] init];
        
        GameFileApiManager *gameFileApiManager = [[GameFileApiManager alloc] initWithGameId:((MissionModel *)self.dataSource[indexPath.row]).missionID];
        [gameFileApiManager loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            if (errorType == ZHYAPIManagerErrorTypeSuccess){
                [self analyzeServiceData:responseData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self startGameClicked];
                });
            }else{
                NSLog(@"request error");
            }
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

#pragma mark - private
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
    NSInteger TNumber = [[GVUserDefaults standardUserDefaults].healthyBeans integerValue];
    if (TNumber >= 50) {
        [GVUserDefaults standardUserDefaults].energy = @"100";
        TNumber = TNumber - 50 ;
        [GVUserDefaults standardUserDefaults].healthyBeans = [NSString stringWithFormat:@"%ld",TNumber];
    }else{
        [[MyAlertCenter defaultCenter] postAlertWithMessage:@"缺健康豆"];
    }
    
}


- (void)alertSureButtonClick{
    NSLog(@"点击了确认按钮");
    [self buyEnergy];
}

- (void)alertCauseButtonClick{
    NSLog(@"点击了取消按钮");
}

#pragma mark - enter game
- (void)startGameClicked{
    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;
    self.curAudioManager = [AudioManager sharedInstance];
        if ([self.curBTManager isBluetoothLinked]){
            //蓝牙已连接，准备发送给蓝牙指令集
            [self.ordersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.curBTManager writeToPeripheral:(NSString *)obj];
            }];
            //指令集发送结束 指令
            [self.curBTManager writeToPeripheral:@"aa02010506"];
            [self.curBTManager readValueWithBlock:^(NSString *data) {
                NSLog(@"%@",data);
                if ([data containsString:@"aa02030104"]){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        LoadResourceTipView *tv = [[LoadResourceTipView alloc] initWithFrame:self.view.frame];
                        [self.view addSubview:tv];
    
                        [self.curAudioManager downloadAudioWithURL:[NSString stringWithFormat:@"http://shouzhi.yunzs.net/music/%@",self.curMissionModel.musicPath] fileName:self.curMissionModel.musicName downloadProgressBlock:^(CGFloat p) {
                            [tv updateProgress:p];
                        }  downloadReturnBlock:^(bool state, NSString * _Nonnull localPath) {
                            if (state == YES){
                                [self.curAudioManager prepareForAudioPlayer:localPath];
    
                                [tv removeFromSuperview];
                                MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
                                [self presentViewController:vc animated:YES completion:nil];
                            }else{
                                [self showErrorHUD:@"游戏音乐下载失败"];
                            }
                        }];
                    });
                }
            }];
        }else{
            UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未连接蓝牙，无法开始游戏，请连接蓝牙后尝试" preferredStyle:UIAlertControllerStyleAlert];
            [_alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:_alertController animated:YES completion:nil];
        }
//    MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
//    [self presentViewController:vc animated:YES completion:nil];
}


- (void)analyzeServiceData:(id)data{
    [self.curMissionModel yy_modelSetWithJSON:data[@"data"][0]];
    self.gameOrderFile.gameId = data[@"data"][0][@"id"];
    self.gameOrderFile.gameName = data[@"data"][0][@"name"];
    self.gameOrderFile.gameOrders = [NSMutableArray array];
    NSMutableArray *cArray = [NSMutableArray arrayWithArray:data[@"data"][0][@"instruction"]];
    [cArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = obj[@"instruction"];
        NSLog(@"index:%lu == %@",(unsigned long)idx,str);
        //保存到ordersArray，准备发送给蓝牙串口
        [self.ordersArray addObject:str];
        //解析各指令含义，保存到OrderModel
        OrderModel *orderModel = [[OrderModel alloc] init];
        orderModel.no = (int)idx;
        orderModel.fingerId = [[str substringWithRange:NSMakeRange(4, 2)] intValue];
        orderModel.startTime = [[str substringWithRange:NSMakeRange(6, 2)] floatValue]*60 +[[str substringWithRange:NSMakeRange(8, 2)] floatValue] +[[str substringWithRange:NSMakeRange(10, 2)] floatValue]/100;
        orderModel.duration = [[str substringWithRange:NSMakeRange(12, 2)] floatValue]*60 +[[str substringWithRange:NSMakeRange(14, 2)] floatValue] +[[str substringWithRange:NSMakeRange(16, 2)] floatValue]/100;
        orderModel.state = StateTypeDefault;
        NSLog(@"指令编号：%d手指id：%d开始时间：%.2f时长：%.2f",orderModel.no,orderModel.fingerId,orderModel.startTime,orderModel.duration);
        [self.gameOrderFile.gameOrders addObject:orderModel];
    }];
}
@end
