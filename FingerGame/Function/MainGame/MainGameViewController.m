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

@interface MainGameViewController ()<MyBTManagerProtocol>

//方块的数量（指令的个数）
@property (nonatomic,assign) NSInteger sceneCount;
//操作的方块数组
@property (nonatomic,strong) NSMutableArray *operateArray;
//初始每个Scene Frame的数组
@property (nonatomic,strong) NSMutableArray *frameArray;
//当前正确点击的次数
@property (nonatomic,assign) NSInteger successClick;
//当前分数
@property (nonatomic,assign) float score;

@property (nonatomic,strong) GameStaticsView *gameStaticsView;
@property (nonatomic,strong) BottomLeftView *bottomLeftView;
@property (nonatomic,strong) BottomRightView *bottomRightView;

@property (nonatomic,strong) GameOrderFile *gameOrderFile;
//蓝牙字符串的缓存
@property (nonatomic,strong) NSString *cacheString;
//蓝牙操作工具
@property (nonatomic,strong) MyBTManager *curBTManager;

@end

@implementation MainGameViewController
{
    CADisplayLink *displayLink;
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
    
    [self buildMainView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;
    self.cacheString = @"";
    [self startGame];
}

//搭建游戏主界面
- (void)buildMainView{
    NSLog(@"开始搭建游戏界面!滑块数量：%ld",(long)_sceneCount);
    _operateArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //frame 记录初始化每个scene的frame 点击错误之后可以回复scene的frame
    _frameArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //绘制黑色泳道
    for (int i=0; i<9; i++){
        UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-9)/10*(i+1)+i*1, [GameStaticsView heightForView], 1, SCREEN_HEIGHT-[GameStaticsView heightForView]-[BottomLeftView heightForView])];
        judeView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:judeView];
    }
    //绘制判定线
    UIView *judgeView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-[BottomLeftView heightForView]-20, SCREEN_WIDTH, 1)];
    judgeView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:judgeView];
    //生成初始化滑块并绘制
    float showHeight = SCREEN_HEIGHT-[GameStaticsView heightForView]-[BottomLeftView heightForView];
    [self.gameOrderFile.gameOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        int no = ((OrderModel*)obj).no;
        int fingerId = ((OrderModel*)obj).fingerId;
        float startTime = ((OrderModel*)obj).startTime;
        float duration = ((OrderModel*)obj).duration;
        NSLog(@"屏幕高度：%.2f",SCREEN_HEIGHT);
        NSLog(@"指令编号：%d手指id：%d开始时间：%.2f时长：%.2f",no,fingerId,startTime,duration);
        NSLog(@"滑块高度：%.2f",duration*GameSpeed*60-showHeight);
        GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(fingerId*(SCREEN_WIDTH+1)/10, SCREEN_HEIGHT-[BottomLeftView heightForView]-20-duration*GameSpeed*60-startTime*GameSpeed*60, (SCREEN_WIDTH-9)/10, duration*GameSpeed*60)];
        newScene.completeType = CompleteTypeDefault;
        newScene.tag = no; //scene的编号
        //初始化的scene添加到数组中
        [self.frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
        [self.operateArray addObject:newScene];
        
        [self.view addSubview:newScene];
    }];
    //绘制界面上下方信息提示面板
    _gameStaticsView = [[GameStaticsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GameStaticsView heightForView])];
    [self.view addSubview:_gameStaticsView];
    [_gameStaticsView configWithGameName:@"手指操" Score:0.0];
    
    _bottomLeftView = [[BottomLeftView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-[BottomLeftView heightForView], (SCREEN_WIDTH-1)/2, [BottomLeftView heightForView])];
    [self.view addSubview:_bottomLeftView];
    [_bottomLeftView configView];
    
    _bottomRightView = [[BottomRightView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+1)/2, SCREEN_HEIGHT-[BottomLeftView heightForView], (SCREEN_WIDTH-1)/2, [BottomRightView heightForView])];
    [self.view addSubview:_bottomRightView];
    [_bottomRightView configView];
    
}

#pragma mark - Event
//开始游戏（从倒计时开始）
- (void)startGame{
    _score = 0;
    [self.gameStaticsView updateScore:self.score];
    //用CADisplayLink刷新，频率快，动画不会有明显掉帧
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
    StartAnimView *startAnimView = [StartAnimView shareInstance];
    [self.view addSubview:startAnimView];
    [startAnimView showWithAnimNum:3 CompleteBlock:^{
//        [self.curBTManager writeToPeripheral:kGameStartOrder];
//        [self.curBTManager readValueWithBlock:^(NSString *data) {
//            NSLog(@"%@",data);
//            if ([data containsString:@"aa02030609"]){
//                NSLog(@"开始游戏！");
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSLog(@"-----------");
//                    [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
//                });
//            }else{
//                NSLog(@"未接收到蓝牙计时结束指令，无法正常游戏");
//            }
//        }];
        
        //only view test
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"-----------");
            [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        });
        
    }];
}

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
            if (scene.frame.origin.y >= SCREEN_HEIGHT-[BottomLeftView heightForView]-20){
                if (scene.completeType != CompleteTypeSuccess){
                    scene.backgroundColor = [UIColor redColor];
                    scene.completeType = CompleteTypeFailure;
                }
                scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
                scene.completeType = CompleteTypeCompleted;
                scene.hidden = YES;
                self.score += 1;
                [self.gameStaticsView updateScore:self.score];
                if (self.score == self.sceneCount){
                    [self endGame];
                }
            }
            //
        });
    }];
}

//游戏结束
- (void)endGame{
    [displayLink invalidate];
    //UIAlertController init
    NSString *titleString = @"游戏结束";
    NSString *messageString = [NSString stringWithFormat:@"本次得分：%.f\n",self.score];
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击返回");
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击重新开始");
        [self restartGame];
    }]];
    
    [self presentViewController:_alertController animated:YES completion:nil];
}

//重新开始游戏
- (void)restartGame{
    [self.operateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            GameSceneView *scene = (GameSceneView *)obj;
            scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
            scene.completeType = CompleteTypeDefault;
            scene.backgroundColor = [UIColor blueColor];
        });
    }];
    _score = 0;
    [self.gameStaticsView updateScore:self.score];
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
    StartAnimView *startAnimView = [StartAnimView shareInstance];
    [self.view addSubview:startAnimView];
    [startAnimView showWithAnimNum:3 CompleteBlock:^{
        NSLog(@"start displaylink");
        [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }];
}

#pragma mark - Private Methods
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
                            NSLog(@"按键抬起指令，手指id为%d，抬起时间符合指令序列下标为%d的指令区间",returnId,((OrderModel*)obj).no);
                            GameSceneView *scene = (GameSceneView *)[self.operateArray objectAtIndex:((OrderModel*)obj).no];
                            if (scene.completeType == CompleteTypeTouched){
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    scene.completeType = CompleteTypeSuccess;
                                    scene.backgroundColor = [UIColor greenColor];
                                    NSLog(@"抬起成功");
                                });
                            }
                            
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
                            if (scene.completeType == CompleteTypeDefault){
                                scene.completeType = CompleteTypeTouched;
                                scene.backgroundColor = [UIColor yellowColor];
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
#pragma mark - MyBTManagerDelegate

- (void)receiveDataFromBLE:(NSString *)sdata{
    NSLog(@"代理人收到了数据： %@",sdata);
    [self seperateDataString:sdata];
}

@end
