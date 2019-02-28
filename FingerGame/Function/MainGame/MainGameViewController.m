//
//  MainGameViewController.m
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "MainGameViewController.h"

#import "GameSet.h"
#import "GameSceneView.h"
#import "StartAnimView.h"
#import "GameStaticsView.h"
#import "BottomLeftView.h"
#import "BottomRightView.h"

@interface MainGameViewController ()

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

@end

@implementation MainGameViewController
{
    CADisplayLink *displayLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self buildMainView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"enter viewWillAppear");
    
    [self startGame];
}



- (void)startScroll{
    WeakSelf;
    [_operateArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //遍历操作数组中的每个scene
        dispatch_async(dispatch_get_main_queue(), ^{
            GameSceneView *scene = (GameSceneView *)obj;
            CGRect frame = scene.frame;
            frame.origin.y += GameSpeed;
            if (!*stop){
                scene.frame = frame;
            }
            //方块下边框到达屏幕底部后的操作
            if (scene.frame.origin.y+scene.frame.size.height >= SCREEN_HEIGHT-[BottomLeftView heightForView]){
                scene.backgroundColor = [UIColor greenColor];
            }
            //方块上边框到达屏幕底部后的操作
            if (scene.frame.origin.y >= SCREEN_HEIGHT-[BottomLeftView heightForView]){
                self.score += 1;
                [self.gameStaticsView updateScore:self.score];
                scene.completeType = CompleteTypeSuccess;
                scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
                scene.backgroundColor = [UIColor blueColor];
                if (self.score == 20){
                    [self endGame];
                }
                    
            }
            //
        });
    }];
}

//搭建游戏主界面
- (void)buildMainView{
    NSLog(@"enter buildMainGameView!");
    
    _sceneCount = 10;
    _operateArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //frame 记录初始化每个scene的frame 点击错误之后可以回复scene的frame
    _frameArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    WeakSelf;
    for (int i=0; i<9; i++){
        UIView *judeView = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-9)/10*(i+1)+i*1, [GameStaticsView heightForView], 1, SCREEN_HEIGHT-[GameStaticsView heightForView]-[BottomLeftView heightForView])];
        judeView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:judeView];
    }
    for (int i=0; i<_sceneCount; i++){
        GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(i*(SCREEN_WIDTH+1)/10, i*10+[GameStaticsView heightForView], (SCREEN_WIDTH-9)/10, SCREEN_HEIGHT/10)];
        newScene.completeType = CompleteTypeMissed;
        newScene.tag = i; //scene的编号
        //初始化的scene添加到数组中
        [_frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
        [_operateArray addObject:newScene];
        
        [self.view addSubview:newScene];
    }
    
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

//开始游戏（从倒计时开始）
- (void)startGame{
    _score = 0;
    [self.gameStaticsView updateScore:self.score];
    //用CADisplayLink刷新，频率快，动画不会有明显掉帧
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
    StartAnimView *startAnimView = [StartAnimView shareInstance];
    [self.view addSubview:startAnimView];
    [startAnimView showWithAnimNum:3 CompleteBlock:^{
        NSLog(@"start displaylink");
        [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
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
    }]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"重新开始" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"点击重新开始");
        [self startGame];
    }]];

    [self presentViewController:_alertController animated:YES completion:nil];
}

@end
