//
//  GameStageTableViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/1.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTableViewController.h"
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

@interface GameStageTableViewController () <MyBTManagerProtocol>

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



@end

@implementation GameStageTableViewController

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"frame"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加顶部视图
    _mybuttonView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, 60)];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"顶栏.png"]];
    [_mybuttonView setBackgroundColor:bgColor];
    //能够点击
    _mybuttonView.userInteractionEnabled = YES;
    [self.tableView addSubview:self.mybuttonView];
    //添加点击手势事件
    [_mybuttonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
    
    //self.title = @"游戏列表";
    UIColor *bgTVCColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Game_Background.png"]];
    [self.tableView setBackgroundColor:bgTVCColor];
    
    self.tableView.alpha = 1;
    UIView *view1 = [self costViewWithImage:@"昵称.png" tag:0 string:@"name" add:false];
    UIView *view2 = [self costViewWithImage:@"体力.png" tag:1 string:[GVUserDefaults standardUserDefaults].energy add:true];
    UIView *view3 = [self costViewWithImage:@"健康豆.png" tag:2 string:[GVUserDefaults standardUserDefaults].healthyBeans add:true];
    UIView *view4 = [self costViewWithImage:@"钻石小.png" tag:3 string:[GVUserDefaults standardUserDefaults].diamond add:true];
    
    [self.mybuttonView addSubview:view1];
    [self.mybuttonView addSubview:view2];
    [self.mybuttonView addSubview:view3];
    [self.mybuttonView addSubview:view4];
    __weak typeof (self) weakself = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.mybuttonView.bounds), 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.mybuttonView.bounds), 0.0);
    
    [self.tableView addObserver:self
                     forKeyPath:@"frame"
                        options:0
                        context:NULL];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        [self.tableView reloadData];
    }];
    [weakself loadData];
    [self.tableView reloadData];
    
    
    //
}

-(UIView *)costViewWithImage:(NSString *)image tag:(int)tag string:(NSString *)title add:(Boolean )add{
    
    CGFloat viewWidth = SCREEN_WIDTH*4/17;
    NSLog(@"屏幕尺寸为，宽 %f ，高 %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    CGFloat ViewHeight = 60;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5+tag*(viewWidth+5), 0, viewWidth, ViewHeight)];
    view.tag = tag;
    UILabel *titleBglb = [[UILabel alloc]initWithFrame:CGRectMake(5, 20, viewWidth-5, ViewHeight-35)];
    titleBglb.backgroundColor = UIColorFromRGB(0x5aafe0);
    titleBglb.layer.cornerRadius = 10;
    titleBglb.layer.masksToBounds = YES;
    [view addSubview:titleBglb];
    if (add) {
        UIImageView *uiv2 = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth-12, 28, 10, 10)];
        uiv2.image = [UIImage imageNamed:@"加号"];
        [view addSubview:uiv2];
        UIButton *addbutton = [[UIButton alloc]initWithFrame:(CGRect)CGRectMake(viewWidth-12, 33, 10, 10)];
        [view addSubview:addbutton];
    }else{
        UIProgressView *proView = [[UIProgressView alloc]initWithFrame:CGRectMake(5, 52, viewWidth-10, 2)];
        proView.progressViewStyle = UIProgressViewStyleBar;
        proView.progress = ([[GVUserDefaults standardUserDefaults].experience intValue]/100);
        NSLog(@"经验值%@",[GVUserDefaults standardUserDefaults].experience);
        // 设置走过的颜色
        proView.progressTintColor = [UIColor orangeColor];
        
        // 设置未走过的颜色
        proView.trackTintColor = [UIColor lightGrayColor];
        [view addSubview:proView];
    }
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(35, 20, viewWidth-37, ViewHeight-35)];
    titlelb.textColor = [UIColor whiteColor];
    titlelb.font = [UIFont systemFontOfSize:11];
    titlelb.text = title;
    [view addSubview:titlelb];
    
    UIImageView *uiv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 30, 30)];
    uiv.image = [UIImage imageNamed:image];
    [view addSubview:uiv];
    
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addValue:)]];
    
    return view;
}

-(void)addValue:(UITapGestureRecognizer *)gr{
    UIView *view = gr.view;
    switch (view.tag) {
        case 1:
            [self buyEnergy];
            break;
        case 3:
            [self buyDiomond];
            
        default:
            break;
    }
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
                [self.dataSource addObject:modelForList];
                
            }
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    NSLog(@"view will appear");
    [super viewWillAppear:animated];
    //隐藏NavigationBar
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void) viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [super viewWillDisappear:animated];
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
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
            if ([self.dataSource count]!=0) {
                _tempdataSource = [self.dataSource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {

                    MissionModel *mission1 = obj1;

                    MissionModel *mission2 = obj2;

                    NSInteger mission1Level = [mission1.missionLevel integerValue];

                    NSInteger mission2Level = [mission2.missionLevel integerValue];

                    if (mission1Level>mission2Level) {
                        return NSOrderedDescending;//降序
                    }else if (mission1Level<mission2Level)
                    {
                        return NSOrderedAscending;//升序
                    }else
                    {
                        return NSOrderedSame;//相等
                    }

                }];
            }
        return cell;
    }
    
    GameStageTeseTableViewCell *cell = (GameStageTeseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:GSTTVCELL bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:GSTTVCELL];
        cell = [tableView dequeueReusableCellWithIdentifier:GSTTVCELL];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MissionModel *missionModel = _tempdataSource[indexPath.row];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 60;
    }
    if (indexPath.row>=[self.dataSource count]) {
        return 0;
    }
    return 90;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self adjustFloatingViewFrame];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        [self adjustFloatingViewFrame];
    }
}

- (void)adjustFloatingViewFrame
{
    CGRect newFrame = self.mybuttonView.frame;
    
    newFrame.origin.x = 0;
    newFrame.origin.y = self.tableView.contentOffset.y ;
    
    self.mybuttonView.frame = newFrame;
    [self.tableView bringSubviewToFront:self.mybuttonView];
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

#pragma mark - screen
- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

@end
