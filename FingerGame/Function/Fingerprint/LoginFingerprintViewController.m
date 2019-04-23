//
//  LoginFingerprintViewController.m
//  FingerGame
//
//  Created by lisy on 2019/4/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "LoginFingerprintViewController.h"
#import "BTViewController.h"

#import "CustomTableViewCell.h"

#import "FingerprintModel.h"

#import "MyBTManager.h"
#import "NSObject+ProgressHUD.h"
#import <YYCache/YYCache.h>

@interface LoginFingerprintViewController () <MyBTManagerProtocol>

@property (nonatomic,strong) NSString *curUserId;
//记录当前正操作的手指序号fingerId
@property (nonatomic,strong) NSString *fingerIdWaitLogin;
@property (nonatomic,strong) NSString *locationWaitLogin;
//存放tableview数据源
@property (nonatomic,strong) NSMutableArray *showDataArray;
//蓝牙操作工具
@property (nonatomic,strong) MyBTManager *curBTManager;
//YYcache manager
@property (nonatomic,strong) YYCache *curCache;
@end

@implementation LoginFingerprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"指纹";
    
    self.curBTManager = [MyBTManager sharedInstance];
    self.curBTManager.delegate = self;
    
    self.curCache = [YYCache cacheWithName:[NSString stringWithFormat:@"FingerprintCacheForUser:%@",self.curUserId]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (instancetype)initWithUserId:(NSString *)userId{
    self = [super init];
    if (self){
        self.curUserId = userId;
    }
    return self;
}
#pragma mark - private methods

- (void)loadData {
    [self.showDataArray removeAllObjects];
    for (int i=0; i<10; i++){
        NSString *fingerIdString = [NSString stringWithFormat:@"%d",i];
        if ([self.curCache containsObjectForKey:fingerIdString]){
            FingerprintModel *model = (FingerprintModel*)[self.curCache objectForKey:fingerIdString];
            [self.showDataArray addObject:@{@"fingerId":model.fingerId,@"state":@"已录入"}];
        }else{
            [self.showDataArray addObject:@{@"fingerId":fingerIdString,@"state":@"未录入"}];
        }
    }
    [self.tableView reloadData];
}

- (CustomTableViewCell *)setCell:(CustomTableViewCell *)cell WithName:(NSString *)fname IndexPath:(NSIndexPath *)indexPath{
    if ([self.showDataArray[indexPath.row][@"state"] isEqualToString:@"未录入"]){
        [cell setCellImage:[UIImage imageNamed:@""] Title:fname Subtitle:self.showDataArray[indexPath.row][@"fingerId"] Thirdtitle:self.showDataArray[indexPath.row][@"state"] ];
    }else{
        [cell setCellImage:[UIImage imageNamed:@""] Title:fname Subtitle:self.showDataArray[indexPath.row][@"fingerId"] Thirdtitle:self.showDataArray[indexPath.row][@"state"] TipColor:[UIColor greenColor]];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark - event

- (void)enterFingerprint:(NSString *)fingerId {
    NSString *titleString = @"提示";
    NSString *messageString = [NSString stringWithFormat:@"您将要开始录入指纹：%@\n",fingerId];
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"录入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.fingerIdWaitLogin = fingerId;
//        if (self.curBTManager){
//            [self.curBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%@0000",fingerId]];
//        }
        FingerprintModel *model = [FingerprintModel new];
        model.userId = self.curUserId;
        model.fingerId = fingerId;
        model.storeLocation = @"00";
        [self.curCache setObject:model forKey:model.fingerId];
        [self showHUDText:@"录入成功"];
        [self loadData];
    }]];
    [self presentViewController:_alertController animated:YES completion:nil];
}

- (void)reenterFingerprint:(NSString *)fingerId{
    NSString *titleString = @"提示";
    NSString *messageString = [NSString stringWithFormat:@"您已录入该手指的指纹：%@\n",fingerId];
    UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

    }]];
    [_alertController addAction:[UIAlertAction actionWithTitle:@"重新录入" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.fingerIdWaitLogin = fingerId;
        //        if (self.curBTManager){
        //            [self.curBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%@0000",fingerId]];
        //        }
        FingerprintModel *model = [FingerprintModel new];
        model.userId = self.curUserId;
        model.fingerId = fingerId;
        model.storeLocation = @"00";
        [self.curCache setObject:model forKey:model.fingerId];
        [self showHUDText:@"录入成功"];
        [self loadData];
    }]];
    [self presentViewController:_alertController animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell = [self setCell:cell WithName:@"左手小手指" IndexPath:indexPath];
            break;
        case 1:
            cell = [self setCell:cell WithName:@"左手无名指" IndexPath:indexPath];
            break;
        case 2:
            cell = [self setCell:cell WithName:@"左手中指" IndexPath:indexPath];
            break;
        case 3:
            cell = [self setCell:cell WithName:@"左手食指" IndexPath:indexPath];
            break;
        case 4:
            cell = [self setCell:cell WithName:@"左手拇指" IndexPath:indexPath];
            break;
        case 5:
            cell = [self setCell:cell WithName:@"右手拇指" IndexPath:indexPath];
            break;
        case 6:
            cell = [self setCell:cell WithName:@"右手食指" IndexPath:indexPath];
            break;
        case 7:
            cell = [self setCell:cell WithName:@"右手中指" IndexPath:indexPath];
            break;
        case 8:
            cell = [self setCell:cell WithName:@"右手无名指" IndexPath:indexPath];
            break;
        case 9:
            cell = [self setCell:cell WithName:@"右手小手指" IndexPath:indexPath];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.showDataArray[indexPath.row][@"state"] isEqualToString:@"未录入"]){
        [self enterFingerprint:self.showDataArray[indexPath.row][@"fingerId"]];
    }else{
        [self reenterFingerprint:self.showDataArray[indexPath.row][@"fingerId"]];
    }
}

#pragma mark - MyBTManagerDelegate
////                返回录入指纹指令
////                0x02：第一次按指纹成功；0x03：第一次按指纹失败
////                0x04：第二次按指纹成功；0x05：第二次按指纹失败
////                0x07：合并指纹成功；    0x08：合并指纹失败
////                0x09：录入指纹成功：    0x0a: 录入指纹失败
////                     起始位        长度        指令组ID        录入成功或者失败        校验位
////                字节    1          2            3                 4                5
////                内容    0xaa        0x02        0x03             见右           3-4累加和校验
- (void)receiveDataFromBLE:(NSString *)sdata{
    if ([sdata containsString:@"aa0203090c"]){
        NSLog(@"指纹录入成功");
    }
    if ([sdata containsString:@"aa02030e11"]){
        NSLog(@"指纹录入失败");
    }
}

#pragma mark - set & get

- (NSMutableArray *)showDataArray{
    if (!_showDataArray){
        _showDataArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _showDataArray;
}

@end
