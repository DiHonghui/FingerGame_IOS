//
//  PCViewController.m
//  FingerGame
//
//  Created by lisy on 2019/6/24.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "PCViewController.h"

#import "GVUserDefaults+Properties.h"
#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"
#import "Masonry.h"

#import "MyBTManager.h"
#import "BTViewController.h"
#import "FingerprintListTableViewController.h"
#import "FavoritesTableViewController.h"

@interface PCViewController ()

//蓝牙操作工具
@property (nonatomic,strong) MyBTManager *curBTManager;

@end

@implementation PCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"view did load");
    // Do any additional setup after loading the view.
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 1;
    [self.view insertSubview:imageView atIndex:0];
    
    self.curBTManager = [MyBTManager sharedInstance];
    [self layoutMySubviews];
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

#pragma mark - private methods
- (void)layoutMySubviews{
    //
    UIImageView *avaterIv = [[UIImageView alloc] initWithFrame:CGRectMake(15, 65, 70, 70)];
    avaterIv.image = [UIImage imageNamed:@"Avater_Default"];
    avaterIv.layer.cornerRadius = 35;
    [self.view addSubview:avaterIv];
    //
    UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 80, 20)];
    nameLB.textAlignment = NSTextAlignmentLeft;
    nameLB.textColor = [UIColor whiteColor];
    nameLB.text = [GVUserDefaults standardUserDefaults].userName;
    [self.view addSubview:nameLB];
    UILabel *levelLB = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 80, 20)];
    levelLB.textAlignment = NSTextAlignmentLeft;
    levelLB.textColor = [UIColor whiteColor];
    levelLB.text = [NSString stringWithFormat:@"等级 %@",[GVUserDefaults standardUserDefaults].level];
    [self.view addSubview:levelLB];
    UIImageView *editIv = [[UIImageView alloc] initWithFrame:CGRectMake(190, 70, 20, 20)];
    editIv.image = [UIImage imageNamed:@"Edit"];
    [self.view addSubview:editIv];
    //
    UIView *whiteBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, SCREEN_WIDTH, 60)];
    whiteBgView.backgroundColor = [UIColor whiteColor];
    whiteBgView.alpha = 0.3;
    [self.view addSubview:whiteBgView];
    UIView *w1 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 150, 1, 60)];
    w1.backgroundColor = [UIColor whiteColor];
    w1.alpha = 0.7;
    [self.view addSubview:w1];
    UIView *w2 = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 150, 1, 60)];
    w2.backgroundColor = [UIColor whiteColor];
    w2.alpha = 0.7;
    [self.view addSubview:w2];
    //
    UILabel *energyLB = [[UILabel alloc] init];
    energyLB.textAlignment = NSTextAlignmentCenter;
    energyLB.text = @"体力";
    energyLB.textColor = UIColorFromRGB(0xff0000);
    UILabel *energyLB2 = [[UILabel alloc] init];
    energyLB2.textAlignment = NSTextAlignmentCenter;
    energyLB2.text = [GVUserDefaults standardUserDefaults].energy;
    energyLB2.textColor = [UIColor whiteColor];
    UILabel *beansLB = [[UILabel alloc] init];
    beansLB.textAlignment = NSTextAlignmentCenter;
    beansLB.text = @"健康豆";
    beansLB.textColor = UIColorFromRGB(0xd89700);
    UILabel *beansLB2 = [[UILabel alloc] init];
    beansLB2.textAlignment = NSTextAlignmentCenter;
    beansLB2.text = [GVUserDefaults standardUserDefaults].healthyBeans;
    beansLB2.textColor = [UIColor whiteColor];
    UILabel *diamondLB = [[UILabel alloc] init];
    diamondLB.textAlignment = NSTextAlignmentCenter;
    diamondLB.text = @"钻石";
    diamondLB.textColor = UIColorFromRGB(0x9558e8);
    UILabel *diamondLB2 = [[UILabel alloc] init];
    diamondLB2.textAlignment = NSTextAlignmentCenter;
    diamondLB2.text = [GVUserDefaults standardUserDefaults].diamond;
    diamondLB2.textColor = [UIColor whiteColor];
    [self.view addSubview:energyLB];
    [self.view addSubview:energyLB2];
    [self.view addSubview:beansLB];
    [self.view addSubview:beansLB2];
    [self.view addSubview:diamondLB];
    [self.view addSubview:diamondLB2];
    [energyLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(SCREEN_WIDTH/6);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [energyLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_left).offset(SCREEN_WIDTH/6);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [beansLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [beansLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [diamondLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-SCREEN_WIDTH/6);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(-15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    [diamondLB2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_right).offset(-SCREEN_WIDTH/6);
        make.centerY.equalTo(whiteBgView.mas_centerY).offset(15);
        make.height.equalTo(@30);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    //
    UIView *view1 = [self diyViewTitle:@"指纹设置" tag:0 access:YES];
    [self.view addSubview:view1];
    UIView *view2 = [self diyViewTitle:@"我的收藏" tag:1 access:YES];
    [self.view addSubview:view2];
    UIView *view3 = [self diyViewTitle:@"设置" tag:2 access:YES];
    [self.view addSubview:view3];
    UIView *view4 = [self diyViewTitle:@"关于我们" tag:3 access:YES];
    [self.view addSubview:view4];
    UIView *view5 = [self diyViewTitle:@"游戏教程" tag:4 access:YES];
    [self.view addSubview:view5];
    UIView *view6 = [self diyViewTitle:@"退出登录" tag:5 access:NO];
    [self.view addSubview:view6];
}

- (UIView *)diyViewTitle:(NSString *)title tag:(int)tag access:(BOOL)access{
    CGFloat viewWidth = SCREEN_WIDTH - 20;
    CGFloat viewHeight = 40;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 220+tag*(40+10), viewWidth, viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    view.tag = tag;
    view.layer.cornerRadius = 10;
    UILabel *titleLb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 110, 20)];
    titleLb.text = title;
    titleLb.textColor = UIColorFromRGB(0x375c72);
    titleLb.font = [UIFont systemFontOfSize:16];
    [view addSubview:titleLb];
    UIImageView *iv = [[UIImageView alloc] init];
    iv.image = [UIImage imageNamed:@"Goto"];
    if (access){
        [view addSubview:iv];
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(view.mas_right).offset(-10);
            make.top.equalTo(view.mas_top).offset(10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
    return view;
}

- (void)singleTap:(UITapGestureRecognizer *)gr{
    UIView *view = gr.view;
    switch (view.tag) {
        case 0:
            NSLog(@"Tap 0");
            if ([self.curBTManager isBluetoothLinked]){
                FingerprintListTableViewController *vc = [[FingerprintListTableViewController alloc] initWithUserId:[GVUserDefaults standardUserDefaults].userId];
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您尚未连接蓝牙，无法录入指纹，请连接蓝牙后尝试" preferredStyle:UIAlertControllerStyleAlert];
                [_alertController addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }]];
                [_alertController addAction:[UIAlertAction actionWithTitle:@"去连接" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    BTViewController *btvc = [[BTViewController alloc] init];
                    [self.navigationController pushViewController:btvc animated:YES];
                }]];
                [self presentViewController:_alertController animated:YES completion:nil];
            }
            break;
        case 1:
            NSLog(@"Tap 1");
            break;
        case 2:
            NSLog(@"Tap 2");
            break;
        case 3:
            NSLog(@"Tap 3");
            break;
        case 4:
            NSLog(@"Tap 4");
            break;
        case 5:
            NSLog(@"Tap 5");
            {
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate toLogin];
            }
            break;
        default:break;
    }
}

@end