//
//  FavoritesTableViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/7/8.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "FavoritesTableViewController.h"
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

#import "MissionModel.h"
#import "OrderModel.h"
#import "GameOrderFile.h"
#import "MissionModel.h"

#import "LoadResourceTipView.h"
#define GSTVCELL @"GameStageTableViewCell"
#define GSTTVCELL @"GameStageTeseTableViewCell"

@interface FavoritesTableViewController()<MyBTManagerProtocol>

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

@property(strong,nonatomic)NSMutableArray* dataSource;



@end

@implementation FavoritesTableViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIColor *bgTVCColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Game_Background.png"]];
    [self.tableView setBackgroundColor:bgTVCColor];
    self.title = @"收藏列表";
    __weak typeof (self) weakself = self;
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
    //返回显示几条数据
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
            if ([modelForList.like isEqualToString:@"1"]) {
                [self.dataSource addObject:modelForList];
            }
            
        }
    }];
    
    [self.tableView reloadData];
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GameStageTeseTableViewCell *cell = (GameStageTeseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:GSTTVCELL bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GSTTVCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
    }
    MissionModel *missionModel = _tempdataSource[indexPath.row];
    [cell configureCell:missionModel];
    cell.delegate = self;
    return cell;
}

@end
