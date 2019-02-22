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

@end

@implementation MainGameViewController
{
    CADisplayLink *displayLink;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _score = 0.0;
    
    [self buildMainView];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"enter viewWillAppear");
    //用CADisplayLink刷新，频率快，动画不会有明显掉帧
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(startScroll)];
    
    StartAnimView *startAnimView = [StartAnimView shareInstance];
    [self.view addSubview:startAnimView];
    [startAnimView showWithAnimNum:3 CompleteBlock:^{
        NSLog(@"start displaylink");
        [self->displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }];
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
            //方块到达屏幕底部后的操作
            if (scene.frame.origin.y >= SCREEN_HEIGHT){
                self.score += 1;
                NSLog(@"%zd -- %.f",idx,self.score);
                scene.frame = [[self.frameArray objectAtIndex:idx] CGRectValue];
            }
            
        });
    }];
}

- (void)buildMainView{
    NSLog(@"enter buildMainGameView!");
    _sceneCount = 10;
    _operateArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    //frame 记录初始化每个scene的frame 点击错误之后可以回复scene的frame
    _frameArray = [[NSMutableArray alloc] initWithCapacity:_sceneCount];
    WeakSelf;
    for (int i=0; i<_sceneCount; i++){
        GameSceneView *newScene = [[GameSceneView alloc] initWithFrame:CGRectMake(i*20, i*10, SCREEN_WIDTH/10, SCREEN_HEIGHT/10)];
        newScene.completeType = CompleteTypeMissed;
        newScene.tag = i; //scene的编号
        //初始化的scene添加到数组中
        [_frameArray addObject:[NSValue valueWithCGRect:newScene.frame]];
        [_operateArray addObject:newScene];
        
        [self.view addSubview:newScene];
    }
}

@end
