//
//  MainGameViewController.m
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "MainGameViewController.h"

#import "GameSceneView.h"
#import "StartAnimView.h"
#import "GameStaticsView.h"
#import "BottomLeftView.h"
#import "BottomRightView.h"
#import "SettlementView.h"
#import "PauseMenuView.h"

#import "AudioManager.h"

#import "AppMacro.h"

@interface MainGameViewController ()<MyBTManagerProtocol,GameStaticsViewProtocol,SettlementViewProtocol,PauseMenuViewProtocol>

//方块的数量（指令的个数）
@property (nonatomic,assign) NSInteger sceneCount;
//操作的方块数组
@property (nonatomic,strong) NSMutableArray *operateArray;
//初始每个Scene Frame的数组
@property (nonatomic,strong) NSMutableArray *frameArray;
//当前正确点击的次数 当前错误点击次数
@property (nonatomic,assign) NSInteger successClick;
@property (nonatomic,assign) NSInteger failureClick;
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

@property (nonatomic,strong) UIView *pauseView;
@property (nonatomic,strong) UILabel *pauseLabel;

@end

@implementation MainGameViewController
{
    __block CADisplayLink *displayLink;
}

- (id)initWithGameOrderFile:(GameOrderFile *)gameOrderFile{
    self = [super init];
    if (self){
        self.gameOrderFile = gameOrderFile;
        self.sceneCount = [gameOrderFile.gameOrders count];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidthLandscape, ScreenHeightLandscape)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 0.4;
    [self.view insertSubview:imageView atIndex:0];
    
    
    [self buildMainView];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.cacheString = @"";
    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;

    self.curAudioManager = [AudioManager sharedInstance];
    
    [self startGame];
}

//搭建游戏主界面
- (void)buildMainView{
    NSLog(@"开始搭建游戏界面!滑块数量：%ld",(long)_sceneCount);
    _operateArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //frame 记录初始化每个scene的frame 点击错误之后可以回复scene的frame
    _frameArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //绘制泳道
    for (int i=0; i<9; i++){
        if (i>=0 && i<4){
            UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidthLandscape-20)/10*(i+1)+i*1, 0, 1, ScreenHeightLandscape-[BottomLeftView heightForView])];
            judeView.backgroundColor = UIColorFromRGB(0x7ea3de);
            [self.view addSubview:judeView];
        }else{
            if (i>=5 && i<9){
                UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidthLandscape-20)/10*(i+1)+i*1+11, 0, 1, ScreenHeightLandscape-[BottomLeftView heightForView])];
                judeView.backgroundColor = UIColorFromRGB(0x7ea3de);
                [self.view addSubview:judeView];
            }else{
                UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidthLandscape-20)/10*(i+1)+i*1, 0, 12, ScreenHeightLandscape)];
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
            GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(fingerId*(ScreenWidthLandscape/10-1), ScreenHeightLandscape-[BottomLeftView heightForView]-15-duration*GameSpeed*60-startTime*GameSpeed*60, (ScreenWidthLandscape-20)/10, duration*GameSpeed*60)];
            newScene.completeType = CompleteTypeDefault;
            newScene.tag = no; //scene的编号
            //初始化的scene添加到数组中
            [self.frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
            [self.operateArray addObject:newScene];
            
            newScene.userInteractionEnabled = YES;
            [newScene addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScene:)]];
            
            [self.view addSubview:newScene];
        }else{
            GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(fingerId*(ScreenWidthLandscape/10-1)+11, ScreenHeightLandscape-[BottomLeftView heightForView]-15-duration*GameSpeed*60-startTime*GameSpeed*60, (ScreenWidthLandscape-20)/10, duration*GameSpeed*60)];
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
    UIImageView *judgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, ScreenHeightLandscape-[BottomLeftView heightForView]-15, ScreenWidthLandscape, 15)];
    [judgeView setImage:[UIImage imageNamed:@"Game_Judgeline"]];
    judgeView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:judgeView];
    //绘制界面下方信息提示面板
    _bottomLeftView = [[BottomLeftView alloc] initWithFrame:CGRectMake(0, ScreenHeightLandscape-[BottomLeftView heightForView], (ScreenWidthLandscape-12)/2, [BottomLeftView heightForView])];
    [self.view addSubview:_bottomLeftView];
    [_bottomLeftView configView];
    
    _bottomRightView = [[BottomRightView alloc] initWithFrame:CGRectMake((ScreenWidthLandscape+12)/2, ScreenHeightLandscape-[BottomLeftView heightForView], (ScreenWidthLandscape-12)/2, [BottomRightView heightForView])];
    [self.view addSubview:_bottomRightView];
    [_bottomRightView configView];
    //暂停按钮
    _pauseView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidthLandscape*7/8-15, 20, ScreenWidthLandscape/8, 50)];
    _pauseView.backgroundColor = UIColorFromRGB(0x03b5f5);
    _pauseView.layer.cornerRadius = 15;
    _pauseView.layer.borderWidth = 0.1;
    _pauseView.layer.borderColor = [UIColorFromRGB(0xffffff) CGColor];
    _pauseView.userInteractionEnabled = YES;
    [_pauseView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPause:)]];
    _pauseLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, ScreenWidthLandscape/8-10, 40)];
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
            if (scene.frame.origin.y >= ScreenWidthLandscape-[BottomLeftView heightForView]-(15-AllowedDelay*GameSpeed*60)){
                if (scene.completeType != CompleteTypeSuccess && scene.completeType != CompleteTypeFailure && scene.completeType != CompleteTypeCompleted){
                    scene.backgroundColor = [UIColor redColor];
                    scene.completeType = CompleteTypeFailure;
                    self.failureClick += 1;
                    NSLog(@"scene:%ld success:%.f failure:%ld",(long)scene.tag,self.score,(long)self.failureClick);
                }
            }
            if (scene.frame.origin.y >= ScreenWidthLandscape-[BottomLeftView heightForView]){
                scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
                scene.hidden = YES;
                scene.completeType = CompleteTypeCompleted;
            }
        });
        
        if (self.score>=18 || self.failureClick>=10 || self.score+self.failureClick==self.sceneCount){
            [self endGame];
            *stop = YES;
        }
        
    }];
}

//开始游戏（从倒计时开始）
- (void)startGame{
    _gameStaticsView = [[GameStaticsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _gameStaticsView.delegate = self;
    [self.view addSubview:_gameStaticsView];
    [_gameStaticsView configWithBestscore:60];
}

//游戏结束
- (void)endGame{
    _pauseView.hidden = YES;
    [self.curAudioManager pauseAudio];
    [displayLink invalidate];
    [self showSettlement];
}

//重新开始游戏
- (void)restartGame{
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
    _pauseView.hidden = YES;
    [self.curAudioManager pauseAudio];
    [displayLink setPaused:YES];
//    if ([self.curBTManager isBluetoothLinked]) {
//        [self.curBTManager writeToPeripheral:kGamePauseOrder];
//    }
}

- (void)continueGame{
    NSLog(@"Continue Game");
    _pauseView.hidden = NO;
    [self.curAudioManager playAudio];
    [displayLink setPaused:NO];
}
//
- (void)tapScene:(UIGestureRecognizer *)gesture{
    __weak GameSceneView *targetView = (GameSceneView *)gesture.view;
    NSLog(@"==%ld",(long)targetView.tag);
    if (targetView.frame.origin.y <= ScreenWidthLandscape-[BottomLeftView heightForView]-25 && targetView.frame.size.height+targetView.frame.origin.y >= ScreenWidthLandscape-[BottomLeftView heightForView]-25) {
        if (targetView.completeType != CompleteTypeSuccess){
            targetView.backgroundColor = [UIColor greenColor];
            targetView.completeType = CompleteTypeSuccess;
            self.score +=1;
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
//结算处理
- (void)showSettlement{
    float completeRate = self.score/self.sceneCount;
    if (completeRate >= 0 && completeRate < 0.3) self.stars = 0;
    if (completeRate >= 0.3 && completeRate < 0.6) self.stars = 1;
    if (completeRate >=0.6 && completeRate < 0.9) self.stars = 2;
    if (completeRate >=0.9 && completeRate <= 1.0) self.stars = 3;
    float getExp = self.stars * 10;
    float getBeans = self.stars * 10;
    float getScore = completeRate * 100;
    NSLog(@"END %.2f  %d",completeRate,self.stars);
    _settlementView = [[SettlementView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:_settlementView];
    _settlementView.delegate = self;
    [_settlementView configWithScore:getScore Stars:self.stars Beans:getBeans Exp:getExp];
}
//16进制字符串转10进制浮点数
- (float)hexToDec:(NSString*)hexString{
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([hexString UTF8String],0,16)];
    return [temp10 floatValue];
}

- (void)analyzeReturnOrder:(NSString *)order{
    //处理返回按键指令
    if ([order hasPrefix:@"aa05"]){//aa0501 aa050b
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
                                }
                            });
                        }
                    }
                }];
            }
        }
        else{
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
    }else{
        NSLog(@"该指令不是按键按下或者抬起指令");
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
    self.score = 0;
    self.successClick = 0;
    self.failureClick = 0;
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"-----------");
                    [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
                });
            }else{
                NSLog(@"未接收到蓝牙计时结束指令，无法正常游戏");
            }
        }];
        //only view test
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"-----------");
            [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
        [self.curAudioManager playAudio];
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
    [_pauseMenuView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - SettlementViewDelegate
- (void)clickedBackButton{
    [self.curAudioManager exitPlaying];
    [_settlementView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickedRestartButton{
    [_settlementView removeFromSuperview];
    [self restartGame];
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
    return YES;
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
