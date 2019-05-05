//
//  GameDetailViewController.m
//  FingerGame
//
//  Created by lisy on 2019/2/28.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameDetailViewController.h"

#import "BTViewController.h"
#import "MainGameViewController.h"
#import "FingerprintListTableViewController.h"

#import "GameFileApiManager.h"
#import "AudioManager.h"

#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"

#import "NSObject+ProgressHUD.h"
#import <YYModel/YYModel.h>

@interface GameDetailViewController () <MyBTManagerProtocol>
//界面元素
@property (nonatomic,strong) UILabel *gameNameLb;
@property (nonatomic,strong) UIButton *linkBleBtn;
@property (nonatomic,strong) UIButton *startGameBtn;
@property (nonatomic,strong) UILabel *bleStateLb;
@property (nonatomic,strong) UIButton *downloadAudioBtn;
@property (nonatomic,strong) UIButton *fingerprintBtn;
//蓝牙连接状态
@property (nonatomic,assign) BOOL bleState;
//蓝牙操作工具
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

@implementation GameDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"游戏详情";
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;
    
    self.curAudioManager = [AudioManager sharedInstance];
    
    self.ordersArray = [NSMutableArray array];
    self.gameOrderFile = [[GameOrderFile alloc] init];
    self.curMissionModel = [[MissionModel alloc] init];
    
    GameFileApiManager *gameFileApiManager = [[GameFileApiManager alloc] initWithGameId:@"1"];
    [gameFileApiManager loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        if (errorType == ZHYAPIManagerErrorTypeSuccess){
            [self analyzeServiceData:responseData];
        }else{
            NSLog(@"request error");
        }
    }];
    
}

#pragma mark - Object Methods
- (id)initWithGameName:(NSString *)gameName{
    self = [super init];
    self.gameNameLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, SCREEN_WIDTH, 20)];
    self.gameNameLb.backgroundColor = [UIColor blackColor];
    self.gameNameLb.textColor = [UIColor whiteColor];
    self.gameNameLb.textAlignment = NSTextAlignmentCenter;
    self.gameNameLb.text = [NSString stringWithFormat:@"游戏名称：%@",gameName];
    
    self.bleStateLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, 20)];
    self.bleStateLb.backgroundColor = [UIColor blueColor];
    self.bleStateLb.textColor = [UIColor yellowColor];
    self.bleStateLb.textAlignment = NSTextAlignmentCenter;
    self.bleStateLb.text = [NSString stringWithFormat:@"蓝牙连接状态：未连接"];
    
    self.linkBleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 150, 100, 80)];
    self.linkBleBtn.backgroundColor = [UIColor blackColor];
    [self.linkBleBtn setTitle:@"蓝牙连接" forState:UIControlStateNormal];
    [self.linkBleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.linkBleBtn addTarget:self action:@selector(linkBleBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.startGameBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 250, 100, 80)];
    self.startGameBtn.backgroundColor = [UIColor blackColor];
    [self.startGameBtn setTitle:@"开始游戏" forState:UIControlStateNormal];
    [self.startGameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.startGameBtn addTarget:self action:@selector(startGameBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.downloadAudioBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 100, 80)];
    self.downloadAudioBtn.backgroundColor = [UIColor blueColor];
    [self.downloadAudioBtn setTitle:@"下载游戏音乐" forState:UIControlStateNormal];
    [self.downloadAudioBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.downloadAudioBtn addTarget:self action:@selector(downloadAudioBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.fingerprintBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 250, 100, 80)];
    self.fingerprintBtn.backgroundColor = [UIColor blueColor];
    [self.fingerprintBtn setTitle:@"指纹录入" forState:UIControlStateNormal];
    [self.fingerprintBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.fingerprintBtn addTarget:self action:@selector(fingerprintBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.gameNameLb];
    [self.view addSubview:self.bleStateLb];
    [self.view addSubview:self.linkBleBtn];
    [self.view addSubview:self.startGameBtn];
    [self.view addSubview:self.downloadAudioBtn];
    [self.view addSubview:self.fingerprintBtn];
    
    _bleState = NO;
    
    return self;
}

#pragma mark - Private Methods

- (void)linkBleBtnClicked:(id)sender{
    BTViewController *vc = [[BTViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)downloadAudioBtnClicked:(id)sender{
    [self.curAudioManager downloadAudioWithURL:[NSString stringWithFormat:@"http://shouzhi.yunzs.net/music/%@",self.curMissionModel.musicPath] fileName:self.curMissionModel.musicName downloadReturnBlock:^(bool state, NSString * _Nonnull localPath) {
        if (state == YES){
            [self showHUDText:@"游戏音乐下载成功"];
            [self.curAudioManager prepareForAudioPlayer:localPath];
        }else{
            [self showErrorHUD:@"游戏音乐下载失败"];
        }
    }];
}

- (void)fingerprintBtnClicked:(id)sender{
    FingerprintListTableViewController *vc = [[FingerprintListTableViewController alloc] initWithUserId:@"1"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startGameBtnClicked:(id)sender{
//    if (_bleState){
//        //蓝牙已连接，准备发送给蓝牙指令集
//        [self.ordersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            [self.curBTManager writeToPeripheral:(NSString *)obj];
//        }];
//        //指令集发送结束 指令
//        [self.curBTManager writeToPeripheral:@"aa02010506"];
//        //
//        [self.curBTManager readValueWithBlock:^(NSString *data) {
//            NSLog(@"%@",data);
//            if ([data containsString:@"aa02030104"]){
//                //enter game view
//                MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
//                [self presentViewController:vc animated:YES completion:nil];
//            }
//        }];
//    }else{
//        UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未连接蓝牙，无法开始游戏，请连接蓝牙后尝试" preferredStyle:UIAlertControllerStyleAlert];
//        [_alertController addAction:[UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self dismissViewControllerAnimated:YES completion:nil];
//        }]];
//        [self presentViewController:_alertController animated:YES completion:nil];
//    }
    //only view test
    MainGameViewController *vc = [[MainGameViewController alloc] initWithGameOrderFile:self.gameOrderFile];
    [self presentViewController:vc animated:YES completion:nil];
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

#pragma mark - MyBTManagerDelegate

- (void)receiveBLELinkState:(BOOL)state{
    if (state == YES){
        self.bleStateLb.textColor = [UIColor greenColor];
        self.bleStateLb.text = [NSString stringWithFormat:@"蓝牙连接状态：已连接"];
        self.bleState = YES;
    }else{
        self.bleStateLb.textColor = [UIColor yellowColor];
        self.bleStateLb.text = [NSString stringWithFormat:@"蓝牙连接状态：未连接"];
        self.bleState = NO;
    }
}

@end
