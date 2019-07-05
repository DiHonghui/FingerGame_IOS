//
//  ClassicStageViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/6/4.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ClassicStageViewController.h"
#import "ClassicStageTableViewCell.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "GVUserDefaults+Properties.h"
#import "CostValueTableViewCell.h"
#import "MyAlertCenter.h"
#import "HLXibAlertView.h"
#import "RechargeDiomondApiManager.h"

@interface ClassicStageViewController ()
@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;
@end

@implementation ClassicStageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"精品列表";
    __weak typeof (self) weakself = self;
    //self.tableView.scrollEnabled = NO;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [weakself loadData];
    [self.tableView.mj_header beginRefreshing];
    
    //self.tableView.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    [self.tableView reloadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //NSLog(@"dataSource count = @%@",self.dataSource);
    //return [self.dataSource count];
    //返回显示几条数据
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        CostValueTableViewCell *cell = (CostValueTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CostValueTableViewCell"];
        if (!cell) {
            UINib* nib = [UINib nibWithNibName:@"CostValueTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"CostValueTableViewCell"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"CostValueTableViewCell"];
        }
        [cell configureCell];
        cell.user_delegate = self;
        return cell;
    }
    ClassicStageTableViewCell *cell = (ClassicStageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ClassicStageTableViewCell"];
    if (!cell) {
        UINib* nib = [UINib nibWithNibName:@"ClassicStageTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:@"ClassicStageTableViewCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"ClassicStageTableViewCell"];
    }
    //MissionModel *missionModel = self.dataSource[indexPath.row];
    //[cell configureCell:missionModel];
    [cell configureCell];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return;
    }
    
    NSInteger lNumber = [[GVUserDefaults standardUserDefaults].diamond integerValue];
    if (lNumber <= 5) {
        [self alertViewWithXib];
    }else{
        lNumber = lNumber-5;
        [GVUserDefaults standardUserDefaults].diamond = [NSString stringWithFormat:@"%ld",lNumber];
        //    GameDetailViewController *vc = [[GameDetailViewController alloc] initWithGameId:((MissionModel *)self.dataSource[indexPath.row]).missionID];
        //    [self.navigationController pushViewController:vc animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        return 90;
    }
    return 90;
}

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
    UIAlertAction *addDiomond5 = [UIAlertAction actionWithTitle:@"消耗健康豆补满体力" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"通过代理充补满体力");
        [self chargeEnergy];
        
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

-(void)chargeDiomond:(NSInteger *)number{
    if (number!=0) {
        NSLog(@"触发充值按钮");
        NSString* sNumber = [NSString stringWithFormat:@"%ld", number];
        [self.rechargeApiManager loadDataWithParams:@{@"user_id":[GVUserDefaults standardUserDefaults].userId,@"amount":sNumber,@"service":@"App.User.Recharge"} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            //NSLog(@"%@", responseData[@"data"][@"message"]);
        }];
        NSLog(@"update sucess");
        
    }
}

-(void)chargeEnergy{
    [GVUserDefaults standardUserDefaults].energy = @"100";
}

- (void)alertViewWithXib{
    
    [HLXibAlertView alertWithTittle:@"钻石不足" message:@"请购买钻石" block:^(NSInteger index) {
        if (index == XibAlertBlockSureButtonClick) {
            [self alertSureButtonClick];
        }else{
            [self alertCauseButtonClick];
        }
    }];
}

- (void)alertSureButtonClick{
    NSLog(@"点击了确认按钮");
    [self buyDiomond];
}

- (void)alertCauseButtonClick{
    NSLog(@"点击了取消按钮");
}

-(RechargeDiomondApiManager*) rechargeApiManager{
    if (!_rechargeApiManager) {
        _rechargeApiManager = [[RechargeDiomondApiManager alloc]init];
    }
    return _rechargeApiManager;
}



@end
