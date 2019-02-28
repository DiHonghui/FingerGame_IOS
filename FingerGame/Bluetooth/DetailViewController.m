//
//  DetailViewController.m
//  SZC
//
//  Created by lisy on 2018/8/19.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import "DetailViewController.h"
#import "AppMacro.h"
#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface DetailViewController ()<MyBTManagerProtocol>


@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    UIButton *writeBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    writeBT.frame = CGRectMake(20, 100, 280, 40);
    writeBT.backgroundColor = [UIColor blueColor];
    [writeBT setTitle:@"写数据" forState:UIControlStateNormal];
    [writeBT addTarget:self action:@selector(writeBTClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:writeBT];
    UIButton *readBT = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    readBT.frame = CGRectMake(20, 160, 280, 40);
    readBT.backgroundColor = [UIColor greenColor];
    [readBT setTitle:@"读数据" forState:UIControlStateNormal];
    [readBT addTarget:self action:@selector(readBTClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:readBT];
    _myManager = [MyBTManager sharedInstance];
    _myManager.delegate =self;
    
}

//界面退出
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"enter viewwilldisappear");;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response
- (void)writeBTClick {
    [_myManager writeToPeripheral:@"ab"];
}

- (void)readBTClick {
    [_myManager readValue];
}

#pragma mark - MyBTManagerDelegate
- (void)receiveDataFromBLE:(NSString *)sdata{
    NSLog(@"代理人收到了数据： %@",sdata);
}

@end
