//
//  MainGameVC_OFF.m
//  FingerGame
//
//  Created by lisy on 2019/7/9.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "MainGameVC_OFF.h"

#import "GameSceneView.h"
#import "StartAnimView.h"
#import "GameStaticsView.h"
#import "BottomLeftView.h"
#import "BottomRightView.h"
#import "SettlementView.h"
#import "PauseMenuView.h"
#import "LoadResourceTipView.h"

#import "AudioManager.h"
#import "MyCacheManager.h"
#import "OfflineManager.h"

#import "YYModel.h"
#import "AppMacro.h"
#import "NSObject+ProgressHUD.h"
#import "GVUserDefaults+Properties.h"

@interface MainGameVC_OFF () <MyBTManagerProtocol,GameStaticsViewProtocol,SettlementViewProtocol,PauseMenuViewProtocol>

//方块的数量（指令的个数）
@property (nonatomic,assign) NSInteger sceneCount;
//操作的方块数组
@property (nonatomic,strong) NSMutableArray *operateArray;
//初始每个Scene Frame的数组
@property (nonatomic,strong) NSMutableArray *frameArray;
//当前正确点击的次数 当前错误点击次数
@property (nonatomic,assign) NSInteger successClick;
@property (nonatomic,assign) NSInteger failureClick;
//当前指纹识别正确数（附加分）
@property (nonatomic,assign) NSInteger fpSuccessCount;
//当前分数
@property (nonatomic,assign) float score;
@property (nonatomic,assign) int stars;

@property (nonatomic,strong) GameStaticsView *gameStaticsView;
@property (nonatomic,strong) BottomLeftView *bottomLeftView;
@property (nonatomic,strong) BottomRightView *bottomRightView;
@property (nonatomic,strong) SettlementView *settlementView;
@property (nonatomic,strong) PauseMenuView *pauseMenuView;

@property (nonatomic,strong) GameOrderFile *gameOrderFile;
//蓝牙字符串的缓存
@property (nonatomic,strong) NSString *cacheString;
//蓝牙操作工具
@property (nonatomic,strong) MyBTManager *curBTManager;
//游戏音乐处理工具
@property (nonatomic,strong) AudioManager *curAudioManager;
@property (nonatomic,strong) MyCacheManager *cacheManager;
//当前游戏的游戏详情
@property (nonatomic,strong) MissionModel *curMissionModel;
//准备发送给蓝牙串口的指令数组
@property (nonatomic,strong) NSMutableArray *ordersArray;

@property (nonatomic,strong) UIView *pauseView;
@property (nonatomic,strong) UILabel *pauseLabel;

@property (nonatomic,strong) NSString *curLevel;
@property (nonatomic,strong) NSString *curSmallLevel;
@property (nonatomic,strong) NSString *nextLevel;
@property (nonatomic,strong) NSString *nextSmallLevel;

@property (nonatomic,assign) BOOL isPaused;

@property (nonatomic,strong) OfflineManager *offlineManager;

@end

@implementation MainGameVC_OFF
{
    __block CADisplayLink *displayLink;
}

- (id)initWithGameOrderFile:(GameOrderFile *)gameOrderFile AndMissionModel:(MissionModel *)missionModel{
    self = [super init];
    if (self){
        self.curMissionModel = missionModel;
        self.gameOrderFile = gameOrderFile;
        self.sceneCount = [gameOrderFile.gameOrders count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self buildMainView];
    self.cacheString = @"";
    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;
    self.curAudioManager = [AudioManager sharedInstance];
    self.offlineManager = [OfflineManager sharedInstance];
    
    [self startGame];
}

//搭建游戏主界面
- (void)buildMainView{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 0.4;
    [self.view insertSubview:imageView atIndex:0];
    NSLog(@"开始搭建游戏界面!滑块数量：%ld",(long)_sceneCount);
    _operateArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //frame 记录初始化每个scene的frame 点击错误之后可以回复scene的frame
    _frameArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //绘制泳道
    for (int i=0; i<9; i++){
        if (i>=0 && i<4){
            UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/10*(i+1)+i*1, 0, 1, SCREEN_HEIGHT-[BottomLeftView heightForView])];
            judeView.backgroundColor = UIColorFromRGB(0x7ea3de);
            [self.view addSubview:judeView];
        }else{
            if (i>=5 && i<9){
                UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/10*(i+1)+i*1+11, 0, 1, SCREEN_HEIGHT-[BottomLeftView heightForView])];
                judeView.backgroundColor = UIColorFromRGB(0x7ea3de);
                [self.view addSubview:judeView];
            }else{
                UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-20)/10*(i+1)+i*1, 0, 12, SCREEN_HEIGHT)];
                judeView.backgroundColor = UIColorFromRGB(0x7ea3de);
                [self.view addSubview:judeView];
            }
        }
    }
    //生成初始化滑块并绘制
    [self.gameOrderFile.gameOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int no = ((OrderModel*)obj).no;
        int fingerId = ((OrderModel*)obj).fingerId;
        float startTime = ((OrderModel*)obj).startTime;
        float duration = ((OrderModel*)obj).duration;
        NSLog(@"指令编号：%d手指id：%d开始时间：%.2f时长：%.2f",no,fingerId,startTime,duration);
        if (fingerId>=0 && fingerId<5){
            GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(fingerId*(SCREEN_WIDTH/10-1), SCREEN_HEIGHT-[BottomLeftView heightForView]-15-duration*GameSpeed*60-startTime*GameSpeed*60, (SCREEN_WIDTH-20)/10, duration*GameSpeed*60)];
            newScene.completeType = CompleteTypeDefault;
            newScene.tag = no; //scene的编号
            //初始化的scene添加到数组中
            [self.frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
            [self.operateArray addObject:newScene];
            
            newScene.userInteractionEnabled = YES;
            [newScene addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScene:)]];
            
            [self.view addSubview:newScene];
        }else{
            GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(fingerId*(SCREEN_WIDTH/10-1)+11, SCREEN_HEIGHT-[BottomLeftView heightForView]-15-duration*GameSpeed*60-startTime*GameSpeed*60, (SCREEN_WIDTH-20)/10, duration*GameSpeed*60)];
            newScene.completeType = CompleteTypeDefault;
            newScene.tag = no; //scene的编号
            //初始化的scene添加到数组中
            [self.frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
            [self.operateArray addObject:newScene];
            
            newScene.userInteractionEnabled = YES;
            [newScene addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScene:)]];
            
            [self.view addSubview:newScene];
        }
    }];
    //绘制判定线
    UIImageView *judgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-[BottomLeftView heightForView]-15, SCREEN_WIDTH, 15)];
    [judgeView setImage:[UIImage imageNamed:@"Game_Judgeline"]];
    judgeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:judgeView];
    //绘制界面下方信息提示面板
    _bottomLeftView = [[BottomLeftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-[BottomLeftView heightForView], (SCREEN_WIDTH-12)/2, [BottomLeftView heightForView])];
    [self.view addSubview:_bottomLeftView];
    [_bottomLeftView configView];
    
    _bottomRightView = [[BottomRightView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+12)/2, SCREEN_HEIGHT-[BottomLeftView heightForView], (SCREEN_WIDTH-12)/2, [BottomRightView heightForView])];
    [self.view addSubview:_bottomRightView];
    [_bottomRightView configView];
    //暂停按钮
    _pauseView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*7/8-15, 20, SCREEN_WIDTH/8, 50)];
    _pauseView.backgroundColor = UIColorFromRGB(0x03b5f5);
    _pauseView.layer.cornerRadius = 15;
    _pauseView.layer.borderWidth = 0.1;
    _pauseView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
    _pauseView.userInteractionEnabled = YES;
    [_pauseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPause:)]];
    _pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SCREEN_WIDTH/8-10, 40)];
    _pauseLabel.backgroundColor = [UIColor clearColor];
    _pauseLabel.text = @"暂停";
    _pauseLabel.textColor = UIColorFromRGB(0xffffff);
    _pauseLabel.font = [UIFont fontWithName:@"微软雅黑" size:40];
    _pauseLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_pauseView];
    [_pauseView addSubview:_pauseLabel];
    _pauseView.hidden = YES;
}

#pragma mark - Event
- (void)startScroll{
    [_operateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //遍历操作数组中的每个scene
        dispatch_async(dispatch_get_main_queue(), ^{
            GameSceneView *scene = (GameSceneView *)obj;
            if (scene.completeType != CompleteTypeCompleted){
                CGRect frame = scene.frame;
                frame.origin.y += GameSpeed;
                if (!*stop){
                    scene.frame = frame;
                }
            }
            //方块上边框到达判定线后的操作
            if (scene.frame.origin.y >= SCREEN_HEIGHT-[BottomLeftView heightForView]-15+AllowedDelay*GameSpeed*60){
                if (scene.completeType != CompleteTypeSuccess && scene.completeType != CompleteTypeFailure && scene.completeType != CompleteTypeCompleted){
                    scene.backgroundColor = [UIColor redColor];
                    scene.completeType = CompleteTypeFailure;
                    self.failureClick += 1;
                    NSLog(@"scene:%ld success:%ld failure:%ld",(long)scene.tag,(long)self.successClick,(long)self.failureClick);
                }
            }
            if (scene.frame.origin.y >= SCREEN_HEIGHT-[BottomLeftView heightForView]-15+AllowedDelay*GameSpeed*60){
                scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
                scene.hidden = YES;
                scene.completeType = CompleteTypeCompleted;
            }
        });
        
        if (self.successClick+self.failureClick==self.sceneCount){
            [self endGame];
            *stop = YES;
        }
        
    }];
}

- (void)initGameStatistics{
    self.score = 0;
    self.successClick = 0;
    self.failureClick = 0;
    self.fpSuccessCount = 0;
    self.isPaused = YES;
}

//开始游戏（从倒计时开始）
- (void)startGame{
    [self.curAudioManager prepareForAudioPlayerWithDataSet:self.curMissionModel.missionID];
    [self initGameStatistics];
    _gameStaticsView = [[GameStaticsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _gameStaticsView.delegate = self;
    [self.view addSubview:_gameStaticsView];
    NSLog(@"当前游戏历史最高分：%@",self.curMissionModel.bestScore);
    if (!self.curMissionModel.bestScore || [self.curMissionModel.bestScore isEqual:[NSNull null]]){
        [_gameStaticsView configWithBestscore:0];
    }else{
        [_gameStaticsView configWithBestscore:[self.curMissionModel.bestScore floatValue]];
    }
}

//游戏结束
- (void)endGame{
    self.isPaused = YES;
    _pauseView.hidden = YES;
    [self.curAudioManager pauseAudio];
    [displayLink invalidate];
    [self showSettlement];
}
//结算处理
- (void)showSettlement{
    //根据规则计算游戏得分
    float completeRate = (float)self.successClick/(float)self.sceneCount;
    if (completeRate >= 0 && completeRate < 0.3) self.stars = 0;
    if (completeRate >= 0.3 && completeRate < 0.6) self.stars = 1;
    if (completeRate >=0.6 && completeRate < 0.9) self.stars = 2;
    if (completeRate >=0.9 && completeRate <= 1.0) self.stars = 3;
    float getExp = completeRate * [self.curMissionModel.missionExperience floatValue];
    float getBeans = completeRate * [self.curMissionModel.award floatValue];
    [self uploadGotAwards:getBeans];
    //最高分判断
    float getScore = completeRate * 100 + self.fpSuccessCount * 2;
    getScore = (getScore>=100)?100:getScore;
    if (getScore > [self.curMissionModel.bestScore floatValue]) [self uploadNewBestScore:getScore];
    //上传用户经验等级
    int finalExp = getExp + [[GVUserDefaults standardUserDefaults].experience intValue];
    int finalLevel = [[GVUserDefaults standardUserDefaults].level intValue];
    NSLog(@"计算后的经验和等级：%d  %d",finalExp,finalLevel);
    if (finalExp>=100) {
        finalExp = finalExp - 100;
        finalLevel ++;
    }
    [self uploadUserLevel:finalLevel EXP:finalExp];
    //显示结算弹窗
    NSLog(@"END %.2f  %d %d %d %.2f",completeRate,self.successClick,self.failureClick,self.sceneCount,getScore);
    _settlementView = [[SettlementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_settlementView];
    _settlementView.delegate = self;
    [_settlementView configWithScore:getScore Stars:self.stars Beans:getBeans Exp:getExp];
}
//上传用户获得的奖励数据
- (void)uploadGotAwards:(float)beans{
    [self.offlineManager setOperatingTable:@"user_table"];
    int cbeans = [[self.offlineManager getStringWithKey:@"healthyBeans"] intValue];
    cbeans += beans;
    [self.offlineManager storeString:[NSString stringWithFormat:@"%d",cbeans] WithKey:@"healthyBeans"];
    NSLog(@"%@",[self.offlineManager getStringWithKey:@"healthyBeans"]);
    NSLog(@"上传游戏奖励成功");
}
//上传新的最高分
- (void)uploadNewBestScore:(float)score{
    [self.offlineManager setOperatingTable:@"gameInfo_table"];
    NSDictionary *dic = @{@"missionID":self.curMissionModel.missionID,
                          @"missionName":self.curMissionModel.missionName,
                          @"missionLevel":self.curMissionModel.missionLevel,
                          @"missionExperience":self.curMissionModel.missionExperience,
                          @"missionDifficulty":self.curMissionModel.missionDifficulty,
                          @"musicName":self.curMissionModel.musicName,
                          @"musicPath":self.curMissionModel.musicPath,
                          @"musicTime":self.curMissionModel.musicTime,
                          @"star":self.curMissionModel.star,
                          @"price":self.curMissionModel.price,
                          @"award":self.curMissionModel.award,
                          @"bestScore":[NSString stringWithFormat:@"%.f",score],
                          @"like":self.curMissionModel.like,
                          @"missionSmallLevel":self.curMissionModel.missionSmallLevel};
    NSLog(@"%@",dic);
    [self.offlineManager storeObject:dic WithKey:self.curMissionModel.missionID];
    self.curMissionModel.bestScore = [NSString stringWithFormat:@"%.f",score];
    NSLog(@"上传新的最高分成功");
}
//上传经验值 等级
- (void)uploadUserLevel:(int)lv EXP:(int)exp{
    [self.offlineManager setOperatingTable:@"user_table"];
    [self.offlineManager storeString:[NSString stringWithFormat:@"%d",lv] WithKey:@"level"];
    [self.offlineManager storeString:[NSString stringWithFormat:@"%d",exp] WithKey:@"experience"];
    NSLog(@"%@",[self.offlineManager getStringWithKey:@"healthyBeans"]);
    NSLog(@"更新用户经验等级成功");
}
//重新开始游戏
- (void)restartGame{
    [self.curBTManager writeToPeripheral:kGameEndOrder];
    [self.operateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GameSceneView *scene = (GameSceneView *)obj;
            scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
            scene.completeType = CompleteTypeDefault;
            scene.backgroundColor = [UIColor blackColor];
            scene.hidden = NO;
        });
    }];
    [self.curAudioManager restartAudio];
    [self startGame];
}

- (void)pauseGame{
    NSLog(@"Pause Game");
    self.isPaused = YES;
    _pauseView.hidden = YES;
    [self.curBTManager writeToPeripheral:kGamePauseOrder];
    [self.curAudioManager pauseAudio];
    [displayLink setPaused:YES];
}

- (void)continueGame{
    NSLog(@"Continue Game");
    self.isPaused = NO;
    _pauseView.hidden = NO;
    [self.curBTManager writeToPeripheral:kGameContinueOrder];
    [self.curAudioManager playAudio];
    [displayLink setPaused:NO];
}
//
- (void)tapScene:(UIGestureRecognizer *)gesture{
    __weak GameSceneView *targetView = (GameSceneView *)gesture.view;
    NSLog(@"==%ld",(long)targetView.tag);
    if (targetView.frame.origin.y <= SCREEN_HEIGHT-[BottomLeftView heightForView]-15 && targetView.frame.size.height+targetView.frame.origin.y >= SCREEN_HEIGHT-[BottomLeftView heightForView]-15){
        if (targetView.completeType != CompleteTypeSuccess){
            targetView.backgroundColor = [UIColor greenColor];
            targetView.completeType = CompleteTypeSuccess;
            self.successClick +=1;
            NSLog(@"Touched Success");
        }
    }
}

- (void)tapPause:(UIGestureRecognizer *)gr{
    NSLog(@"Tap Pause");
    _pauseMenuView = [[PauseMenuView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_pauseMenuView];
    _pauseMenuView.delegate = self;
    [self pauseGame];
}

#pragma mark - Private Methods
//16进制字符串转10进制浮点数
- (float)hexToDec:(NSString*)hexString{
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([hexString UTF8String],0,16)];
    return [temp10 floatValue];
}

- (void)analyzeReturnOrder:(NSString *)order{
    if (self.isPaused){
        NSLog(@"游戏状态为暂停，不解析蓝牙指令");
    }
    else{
        //处理返回按键指令
        if ([order hasPrefix:@"aa05"]){//aa0501 aa050b aa0503
            NSString *typeString = [order substringWithRange:NSMakeRange(4, 2)];
            NSString *idString = [order substringWithRange:NSMakeRange(6, 2)];
            NSString *string1 = [order substringWithRange:NSMakeRange(8, 2)];
            NSString *string2 = [order substringWithRange:NSMakeRange(10, 2)];
            NSString *string3 = [order substringWithRange:NSMakeRange(12, 2)];
            int returnId = [idString intValue];
            float returnTime = [self hexToDec:string1]*60 + [self hexToDec:string2] + [self hexToDec:string3]/100;
            //分不同指令类型和滑块当前状态进行比对
            if ([typeString isEqualToString:@"0b"]){
                NSLog(@"这是一条按键抬起指令,手指id为%d ,抬起时间点为%.2f",returnId,returnTime);
                if (self.gameOrderFile){
                    [self.gameOrderFile.gameOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ( ((OrderModel*)obj).fingerId == returnId ){
                            if ( returnTime >= ((OrderModel*)obj).startTime+((OrderModel*)obj).duration-AllowedDelay && returnTime <= ((OrderModel*)obj).startTime+((OrderModel*)obj).duration+AllowedDelay ){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSLog(@"按键抬起指令，手指id为%d，抬起时间符合指令序列下标为%d的指令区间",returnId,((OrderModel*)obj).no);
                                    GameSceneView *scene = (GameSceneView *)[self.operateArray objectAtIndex:((OrderModel*)obj).no];
                                    NSLog(@"type%ld",(long)scene.completeType);
                                    if (scene.completeType == CompleteTypeTouched){
                                        scene.completeType = CompleteTypeSuccess;
                                        scene.backgroundColor = [UIColor greenColor];
                                        NSLog(@"抬起成功");
                                        self.successClick += 1;
                                    }
                                });
                            }
                        }
                    }];
                }
            }
            if ([typeString isEqualToString:@"01"]){
                NSLog(@"这是一条按键按下指令,手指id为%d ,按下时间点为%.2f",returnId,returnTime);
                if (self.gameOrderFile){
                    [self.gameOrderFile.gameOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ( ((OrderModel*)obj).fingerId == returnId && returnTime >= ((OrderModel*)obj).startTime-AllowedDelay && returnTime <= ((OrderModel*)obj).startTime+AllowedDelay ){
                            dispatch_async(dispatch_get_main_queue(), ^{
                                NSLog(@"按键按下指令，手指id为%d，按下时间符合指令序列下标为%d的指令区间",returnId,((OrderModel*)obj).no);
                                GameSceneView *scene = (GameSceneView *)[self.operateArray objectAtIndex:((OrderModel*)obj).no];
                                NSLog(@"type%ld",(long)scene.completeType);
                                if (scene.completeType == CompleteTypeDefault){
                                    scene.completeType = CompleteTypeTouched;
                                    scene.backgroundColor = [UIColor yellowColor];
                                    NSLog(@"type%ld",(long)scene.completeType);
                                    NSLog(@"按下成功");
                                }
                            });
                        }
                    }];
                }
            }
            if ([typeString isEqualToString:@"03"]){
                NSLog(@"这是一条指纹识别指令，指纹对应手指id为%d",returnId);
                self.fpSuccessCount ++;
            }
        }else{
            NSLog(@"该指令不是按键按下或者抬起指令");
        }
    }
}

//处理游戏过程中蓝牙返回的按键指令
- (void)seperateDataString:(NSString *)dataString{
    self.cacheString = [self.cacheString stringByAppendingString:dataString];
    NSArray *array = [self.cacheString componentsSeparatedByString:@"aa"];
    NSLog(@"%lu",(unsigned long)[array count]);
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *cStr = (NSString*)obj;
        NSLog(@"%lu:%@",(unsigned long)idx,cStr);
        if (idx == [array count]-1){
            if ([cStr length] == 14){
                [self analyzeReturnOrder:[NSString stringWithFormat:@"aa%@",cStr]];
                self.cacheString = @"";
            }else{
                self.cacheString = [NSString stringWithFormat:@"aa%@",cStr];
            }
        }
        else{
            if ([cStr length] == 14){
                [self analyzeReturnOrder:[NSString stringWithFormat:@"aa%@",cStr]];
            }
        }
    }];
}

#pragma mark - GameStaticsViewDelegate
- (void)clickedStartButton{
    [_gameStaticsView removeFromSuperview];
    _pauseView.hidden = NO;
    //用CADisplayLink刷新，频率快，动画不会有明显掉帧
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
    StartAnimView *startAnimView = [StartAnimView shareInstance];
    [self.view addSubview:startAnimView];
    [startAnimView showWithAnimNum:3 CompleteBlock:^{
        [self.curBTManager writeToPeripheral:kGameStartOrder];
        [self.curBTManager readValueWithBlock:^(NSString *data) {
            NSLog(@"%@",data);
            if ([data containsString:@"aa02030609"]){
                NSLog(@"开始游戏！");
                self.isPaused = NO;
                [self.curAudioManager playAudio];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"-----------");
                    [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                });
            }else{
                NSLog(@"未接收到蓝牙计时结束指令，无法正常游戏");
            }
        }];
    }];
}

#pragma mark - PauseMenuViewDelegate
- (void)clickedContinueButton{
    [_pauseMenuView removeFromSuperview];
    [self continueGame];
}

- (void)clickedRedoButton{
    [_pauseMenuView removeFromSuperview];
    [self restartGame];
}

- (void)clickedEndButton{
    [self.curAudioManager exitPlaying];
    [self.curBTManager writeToPeripheral:kGameEndOrder];
    [_pauseMenuView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SettlementViewDelegate
- (void)clickedBackButton{
    [self.curAudioManager exitPlaying];
    [self.curBTManager writeToPeripheral:kGameEndOrder];
    [_settlementView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickedRestartButton{
    [_settlementView removeFromSuperview];
    [self restartGame];
}

- (void)clickedNextGameButton{
    [_settlementView removeFromSuperview];
    [self prepareForNextGame:self.gameOrderFile.gameId];
}

#pragma mark - Test Next Game
- (void)prepareForNextGame:(NSString *)gameId{
    NSLog(@"准备访问下一关的信息");
    [self.offlineManager setOperatingTable:@"gameInfo_table"];
    if ([gameId isEqualToString:@"4"]){
        [self showErrorHUD:@"不存在下一关了,即将返回首页"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
        });
    }else{
        NSString *nextGameId = [NSString stringWithFormat:@"%d",[gameId intValue]+1 ];
        id obj = [self.offlineManager getObjectWithKey:nextGameId];
        NSLog(@"nextGameInfo: %@",obj);
        MissionModel *m = [MissionModel new];
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
        self.curMissionModel = m;
        
        [self.offlineManager setOperatingTable:@"gameOrders_table"];
        NSObject *data = [self.offlineManager getObjectWithKey:self.curMissionModel.missionID];
        [self analyzeServiceData:data];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.settlementView removeFromSuperview];
            [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        });
        
        //开始下一个游戏
        //蓝牙已连接，准备发送给蓝牙指令集
        [self.ordersArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.curBTManager writeToPeripheral:(NSString *)obj];
        }];
        //指令集发送结束 指令
        [self.curBTManager writeToPeripheral:@"aa02010506"];
        //
        //[self.curAudioManager prepareForAudioPlayer:self.curMissionModel.musicPath];
        [self buildNextGameMainView];
        
    }
}

- (void)analyzeServiceData:(id)data{
    NSLog(@"EXP:%@ AWARD:%@ BESTSCORE:%@",self.curMissionModel.missionExperience,self.curMissionModel.award,self.curMissionModel.bestScore);
    self.gameOrderFile.gameId = self.curMissionModel.missionID;
    self.gameOrderFile.gameName = self.curMissionModel.missionName;
    self.gameOrderFile.gameOrders = [NSMutableArray array];
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@",obj];
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

- (void)buildNextGameMainView{
    self.sceneCount = [self.gameOrderFile.gameOrders count];
    self.cacheString = @"";
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        imageView.image=[UIImage imageNamed:@"Game_Background"];
        imageView.alpha = 0.4;
        [self.view insertSubview:imageView atIndex:0];
        [self buildMainView];
        [self startGame];
    });
}

#pragma mark - MyBTManagerDelegate
- (void)receiveDataFromBLE:(NSString *)sdata{
    NSLog(@"代理人收到了数据： %@",sdata);
    [self seperateDataString:sdata];
}

#pragma mark - 强制横屏（只能model视图有效）
//生命周期在viewdidload之后，在viewwillappear之前
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}
//进入界面直接旋转的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
// 是否隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
