//
//  FingerprintListTableViewController.m
//  FingerGame
//
//  Created by lisy on 2019/5/5.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "FingerprintListTableViewController.h"
#import "LoginFingerprintViewController.h"

#import "FPAccountModel.h"

#import "CustomTableViewCell.h"
#import "NSObject+ProgressHUD.h"
#import <YYCache/YYCache.h>

@interface FingerprintListTableViewController ()

@property (nonatomic,strong) NSString *curUserId;
//存放tableview数据源
@property (nonatomic,strong) NSMutableArray *dataSource;
//YYcache manager
@property (nonatomic,strong) YYCache *curCache;

@end

@implementation FingerprintListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"指纹列表";
    self.curCache = [YYCache cacheWithName:[NSString stringWithFormat:@"FingerprintCacheForUserId-%@",self.curUserId]];
    //
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加指纹" style:(UIBarButtonItemStyleDone) target:self action:@selector(addFPAccount:)];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIColor blueColor] forKey:NSForegroundColorAttributeName];
    [buttonItem setTitleTextAttributes:dic forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (instancetype)initWithUserId:(NSString *)userId{
    if (self = [super init]){
        self.curUserId = userId;
    }
    return self;
}

#pragma mark - private methods
- (void)loadData{
    [self.dataSource removeAllObjects];
    for (int i=0; i<8; i++){
        NSString *fpAccountIdString = [NSString stringWithFormat:@"%d",i];
        NSString *key = [NSString stringWithFormat:@"FPAccountId-%@",fpAccountIdString];
        if ([self.curCache containsObjectForKey:key]){
            FPAccountModel *model = (FPAccountModel*)[self.curCache objectForKey:key];
            [self.dataSource addObject:@{@"fpAccountId":model.fpAccountId,@"fpAccountName":model.fpAccountName}];
        }
    }
    [self.tableView reloadData];
}

#pragma mark - event

- (void)addFPAccount:(id)sender {
    if ([self.dataSource count] < 8){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"新建" message:@"请输入指纹集名称" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //获取第1个输入框
            UITextField *textField = alertController.textFields.firstObject;
            if (![textField.text isEqualToString:@""]){
                for (int i=0; i<8; i++){
                NSString *accountIdString = [NSString stringWithFormat:@"%d",i];
                NSString *key = [NSString stringWithFormat:@"FPAccountId-%@",accountIdString];
                if (![self.curCache containsObjectForKey:key]){
                    FPAccountModel *model = [[FPAccountModel alloc] init];
                    model.fpAccountId = accountIdString;
                    model.fpAccountName = textField.text;
                    model.userId = self.curUserId;
                    [self.curCache setObject:model forKey:key];
                    break;
                }
            }
            [self showHUDText:@"新建成功"];
            [self loadData];
            }else{
                [self showHUDText:@"新建指纹集名称不能为空"];
            }
        }]];
        //定义第一个输入框
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"在此输入";
        }];
        [self presentViewController:alertController animated:YES completion:nil];
    }else{
        [self showHUDText:@"1个用户最多创建8个指纹集"];
    }
}

- (void)lpGR:(UILongPressGestureRecognizer *)lpGR {
    CGPoint point = [lpGR locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    if (lpGR.state == UIGestureRecognizerStateBegan) {//手势开始
        if(indexPath != nil){
            NSLog(@"点击的是第%ld行",indexPath.row);
        }
    }
    if (lpGR.state == UIGestureRecognizerStateEnded) {//手势结束
        NSString *titleString = @"提示";
        NSString *messageString = @"确认删除该指纹吗？";
        UIAlertController *_alertController = [UIAlertController alertControllerWithTitle:titleString message:messageString preferredStyle:UIAlertControllerStyleAlert];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [_alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *key = [NSString stringWithFormat:@"FPAccountId-%@",self.dataSource[indexPath.row][@"fpAccountId"]];
            [self.curCache removeObjectForKey:key];
            for (int i=0; i<10; i++){
                NSString *fingerIdString = [NSString stringWithFormat:@"%d",i];
                NSString *key = [NSString stringWithFormat:@"FPAccountId%@-%@",self.dataSource[indexPath.row][@"fpAccountId"],fingerIdString];
                if ([self.curCache containsObjectForKey:key])
                    [self.curCache removeObjectForKey:key];
            }
            [self showHUDText:@"删除成功"];
            [self loadData];
        }]];
        [self presentViewController:_alertController animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [[CustomTableViewCell alloc] init];
    [cell setCellImage:[UIImage imageNamed:@""] Title:self.dataSource[indexPath.row][@"fpAccountName"] Subtitle:@"" Thirdtitle:@""];
    
    UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpGR:)];
    longPressGR.minimumPressDuration = 1;
    [cell addGestureRecognizer:longPressGR];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LoginFingerprintViewController *vc = [[LoginFingerprintViewController alloc] initWithUserId:self.curUserId FPAccountId:self.dataSource[indexPath.row][@"fpAccountId"] FPAccountName:self.dataSource[indexPath.row][@"fpAccountName"]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - set & get
- (NSMutableArray *)dataSource{
    if (!_dataSource){
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
