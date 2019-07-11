//
//  FavoriteTVC_OFF.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/7/10.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "FavoriteTVC_OFF.h"
#import "StageTVCell_OFF.h"
#import "GameStageTeseTableViewCell.h"
#import "MainGameViewController.h"

#import "MJRefresh.h"
#import "MissionSimpleForList.h"
#import "YYModel.h"
#import "Masonry.h"
#import "AppDelegate.h"
#import "GVUserDefaults+Properties.h"
#import "HLXibAlertView.h"
#import "NSObject+ProgressHUD.h"

#import "MissionlistApiManager.h"
#import "GameFileApiManager.h"
#import "RechargeDiomondApiManager.h"
#import "MyAlertCenter.h"
#import "AudioManager.h"
#import "MyBTManager.h"
#import "MyCacheManager.h"
#import "OfflineManager.h"

#import "MissionModel.h"
#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"

#import "LoadResourceTipView.h"
#define GSTVCELL @"GameStageTableViewCell"
#define GSTTVCELL @"StageTVCell_OFF"

@interface FavoriteTVC_OFF ()

@property (strong, nonatomic) MissionlistApiManager *missionlistApiManager;

@property (strong,nonatomic) GameFileApiManager *gameFileApiManager;

@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;

@property (nonatomic,strong) MyBTManager *curBTManager;
@property (nonatomic,strong) MyCacheManager *cacheManager;

//准备发送给蓝牙串口的指令数组
@property (nonatomic,strong) NSMutableArray *ordersArray;
//本地游戏指令保存，用于游戏滑块的初始化
@property (nonatomic,strong) GameOrderFile *gameOrderFile;
//音频下载、播放操作工具
@property (nonatomic,strong) AudioManager *curAudioManager;
//
@property (nonatomic,strong) MissionModel *curMissionModel;

@property(strong,nonatomic) UIView *mybuttonView;

@property(strong,nonatomic) NSMutableArray* tempdataSource;

@property (nonatomic,strong) OfflineManager *offlineManager;

@end

@implementation FavoriteTVC_OFF

- (void)viewDidLoad {
    [super viewDidLoad];
    self.offlineManager = [OfflineManager sharedInstance];
    self.title = @"已收藏歌曲";
    UIColor *bgTVCColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Game_Background.png"]];
    [self.tableView setBackgroundColor:bgTVCColor];
    
    self.tableView.separatorColor = [UIColor clearColor];
    __weak typeof (self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [weakself loadData];
    // Do any additional setup after loading the view.
}

-(void)loadData{
    [self.tableView.mj_header endRefreshing];
    [self.dataSource removeAllObjects];
    NSLog(@"datasource 删除了数据");
    [self.offlineManager setOperatingTable:@"gameInfo_table"];
    for (int i=1; i<=4; i++){
        NSString *index = [NSString stringWithFormat:@"%d",i];
        id obj = [self.offlineManager getObjectWithKey:index];
        NSLog(@"%@",obj);
        //        MissionModel *m = [MissionModel yy_modelWithJSON:obj];
        MissionModel *m = [MissionModel new];
        if ([obj[@"like"] isEqualToString:@"1"]) {
            m.missionID = obj[@"missionID"];
            m.award = obj[@"award"];
            m.bestScore = obj[@"bestScore"];
            m.like = obj[@"like"];
            m.missionDifficulty = obj[@"missionDifficulty"];
            m.missionExperience = obj[@"missionExperience"];
            m.missionLevel = obj[@"missionLevel"];
            m.missionName = obj[@"missionName"];
            m.missionSmallLevel = obj[@"missionSmallLevel"];
            m.musicName = obj[@"musicName"];
            m.musicPath = obj[@"musicPath"];
            m.musicTime = obj[@"musicTime"];
            m.price = obj[@"price"];
            m.star = obj[@"star"];
            [self.dataSource addObject:m];
        }
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    //隐藏NavigationBar
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
    //返回显示几条数据
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    StageTVCell_OFF *cell = (StageTVCell_OFF *)[tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:GSTTVCELL bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GSTTVCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    MissionModel *missionModel = self.dataSource[indexPath.row];
    NSLog(@"datasource type is %@",self.dataSource);
    NSLog(@"收藏状态是%@",missionModel.like);
    [cell configureCell:missionModel];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.userInteractionEnabled = false;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger energyint = [[GVUserDefaults standardUserDefaults].energy integerValue ];
    if (energyint < 20) {
        [self alertViewWithXib];
    }else{
        energyint = energyint - 20;
        
        NSLog(@"GameBestScore:%@",((MissionModel *)self.dataSource[indexPath.row]).bestScore);
        
        self.ordersArray = [NSMutableArray array];
        self.gameOrderFile = [[GameOrderFile alloc] init];
        self.curMissionModel = [[MissionModel alloc] init];
        
        GameFileApiManager *gameFileApiManager = [[GameFileApiManager alloc] initWithGameId:((MissionModel *)self.dataSource[indexPath.row]).missionID UserId:[GVUserDefaults standardUserDefaults].userId];
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
        if ([self existsCacheForCurrentGame:self.gameOrderFile.gameId]){
            NSString *localPath = [self.cacheManager getStringWithKey:self.gameOrderFile.gameId];
            [self.curAudioManager prepareForAudioPlayer:localPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile AndMissionModel:self.curMissionModel];
                [self presentViewController:vc animated:YES completion:nil];
            });
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                LoadResourceTipView *tv = [[LoadResourceTipView alloc] initWithFrame:self.view.frame];
                [self.view addSubview:tv];
                
                [self.curAudioManager downloadAudioWithURL:[NSString stringWithFormat:@"http://shouzhi.yunzs.net/music/%@",self.curMissionModel.musicPath] fileName:self.curMissionModel.musicName downloadProgressBlock:^(CGFloat p) {
                    [tv updateProgress:p];
                }  downloadReturnBlock:^(bool state, NSString * _Nonnull localPath) {
                    if (state == YES){
                        [self.curAudioManager prepareForAudioPlayer:localPath];
                        [tv removeFromSuperview];
                        [self.cacheManager storeString:localPath WithKey:self.gameOrderFile.gameId];
                        MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile AndMissionModel:self.curMissionModel];
                        [self presentViewController:vc animated:YES completion:nil];
                    }else{
                        [self showErrorHUD:@"游戏音乐下载失败"];
                    }
                }];
            });
            
        }
    }else{
        UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未连接蓝牙，无法开始游戏，请连接蓝牙后尝试" preferredStyle:UIAlertControllerStyleAlert];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:_alertController animated:YES completion:nil];
    }
    //test no bluetooth
    //    if ([self existsCacheForCurrentGame:self.gameOrderFile.gameId]){
    //        NSString *localPath = [self.cacheManager getStringWithKey:self.gameOrderFile.gameId];
    //        [self.curAudioManager prepareForAudioPlayer:localPath];
    //        MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
    //        [self presentViewController:vc animated:YES completion:nil];
    //    }else{
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            LoadResourceTipView *tv = [[LoadResourceTipView alloc] initWithFrame:self.view.frame];
    //            [self.view addSubview:tv];
    //
    //            [self.curAudioManager downloadAudioWithURL:[NSString stringWithFormat:@"http://shouzhi.yunzs.net/music/%@",self.curMissionModel.musicPath] fileName:self.curMissionModel.musicName downloadProgressBlock:^(CGFloat p) {
    //                [tv updateProgress:p];
    //            }  downloadReturnBlock:^(bool state, NSString * _Nonnull localPath) {
    //                if (state == YES){
    //                    [self.curAudioManager prepareForAudioPlayer:localPath];
    //                    [tv removeFromSuperview];
    //                    [self.cacheManager storeString:localPath WithKey:self.gameOrderFile.gameId];
    //                    MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
    //                    [self presentViewController:vc animated:YES completion:nil];
    //                }else{
    //                    [self showErrorHUD:@"游戏音乐下载失败"];
    //                }
    //            }];
    //        });
    //    }
}



- (void)analyzeServiceData:(id)data{
    self.curMissionModel = [MissionModel yy_modelWithJSON:data[@"data"][0]];
    NSLog(@"EXP:%@ AWARD:%@ BESTSCORE:%@",self.curMissionModel.missionExperience,self.curMissionModel.award,self.curMissionModel.bestScore);
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


- (BOOL)existsCacheForCurrentGame:(NSString *)gameId{
    BOOL result = NO;
    _cacheManager = [MyCacheManager sharedInstance];
    [_cacheManager setOperatingTable:@"gameAudioPath_table"];
    NSLog(@"当前访问数据库表为%@",[_cacheManager getCurrentTable]);
    if ([_cacheManager getStringWithKey:gameId]){
        NSLog(@"%@  %@",gameId,[_cacheManager getStringWithKey:gameId]);
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL e = [fileManager fileExistsAtPath:[_cacheManager getStringWithKey:gameId]];
        NSLog(@"这个文件已经存在：%@",e?@"是的":@"不存在");
        if (e){
            long storeTime = [MyCacheManager dateConversionTimeStamp:[_cacheManager getCreatedTimeForKey:gameId]];
            long systemTime = [MyCacheManager dateConversionTimeStamp:[NSDate date]];
            //缓存超过两天
            if (systemTime-storeTime>=172800){
                result = NO;
                NSLog(@"outdate");
            }else
                result = YES;
        }else{
            result = NO;
        }
    }else{
        NSLog(@"Not found for gameId %@",gameId);
        result = NO;
    }
    return result;
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
- (void)alertSureButtonClick{
    NSLog(@"点击了确认按钮");
    
}

- (void)alertCauseButtonClick{
    NSLog(@"点击了取消按钮");
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

#pragma mark - screen
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
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
