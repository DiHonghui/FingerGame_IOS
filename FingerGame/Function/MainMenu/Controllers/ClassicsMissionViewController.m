//
//  ClassicsMissionViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/6.
//  Copyright © 2019年 lisy. All rights reserved.
//
#import "MainGameViewController.h"
#import "ClassicsMissionViewController.h"
#import "ClassicStageTableViewCell.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "Masonry.h"
#import "GVUserDefaults+Properties.h"
#import "CostValueTableViewCell.h"
#import "MyAlertCenter.h"
#import "HLXibAlertView.h"
#import "RechargeDiomondApiManager.h"
#import "NSObject+ProgressHUD.h"

@interface ClassicsMissionViewController ()
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *energyAdd;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *diamondAdd;
//@property (weak, nonatomic) IBOutlet UIBarButtonItem *healthyBeansAdd;
//@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
//@property (weak, nonatomic) IBOutlet UIToolbar *itemToolBar;mj
//@property (weak, nonatomic) IBOutlet UITableView *InTableView;
@property (strong,nonatomic) RechargeDiomondApiManager *rechargeApiManager;
@property(strong,nonatomic) UIView *mybuttonView;


@end

@implementation ClassicsMissionViewController

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:@"frame"];
}

- (void)viewDidLoad {
    _mybuttonView = [[UIView alloc]initWithFrame:CGRectMake(0.0, 0, SCREEN_WIDTH, 60)];
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"顶栏.png"]];
    [_mybuttonView setBackgroundColor:bgColor];
    //能够点击
    _mybuttonView.userInteractionEnabled = YES;
    [self.tableView addSubview:self.mybuttonView];
    //添加点击手势事件
    [_mybuttonView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
    
    [super viewDidLoad];
    UIColor *bgTVCColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"Game_Background.png"]];
    [self.tableView setBackgroundColor:bgTVCColor];
    self.tableView.alpha = 1;
    UIView *view1 = [self costViewWithImage:@"昵称.png" tag:0 string:@"name" add:false];
    UIView *view2 = [self costViewWithImage:@"体力.png" tag:1 string:[GVUserDefaults standardUserDefaults].energy add:true];
    UIView *view3 = [self costViewWithImage:@"健康豆.png" tag:2 string:[GVUserDefaults standardUserDefaults].healthyBeans add:true];
    UIView *view4 = [self costViewWithImage:@"钻石小.png" tag:3 string:[GVUserDefaults standardUserDefaults].diamond add:true];
    
    [self.mybuttonView addSubview:view1];
    [self.mybuttonView addSubview:view2];
    [self.mybuttonView addSubview:view3];
    [self.mybuttonView addSubview:view4];
    
    self.title=@"精品列表";
    __weak typeof (self) weakself = self;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.mybuttonView.bounds), 0.0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0.0, 0.0, CGRectGetHeight(self.mybuttonView.bounds), 0.0);
    
    [self.tableView addObserver:self
                     forKeyPath:@"frame"
                        options:0
                        context:NULL];
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tableView.mj_header =[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    [weakself loadData];
    [self.tableView.mj_header beginRefreshing];
}

-(void)loadData{
    //[self.dataSource removeAllObjects];
//    self.energyAdd.title = [GVUserDefaults standardUserDefaults].energy;
//    self.diamondAdd.title = [GVUserDefaults standardUserDefaults].diamond;
//    self.healthyBeansAdd.title = [GVUserDefaults standardUserDefaults].healthyBeans;
//    self.levelLabel.text = [GVUserDefaults standardUserDefaults].level;
    //[self.tableView addSubview:_itemToolBar];
    //[self.tableView addSubview:_InTableView];
    [self.tableView reloadData];
    
}

-(UIView *)costViewWithImage:(NSString *)image tag:(int)tag string:(NSString *)title add:(Boolean )add{
    
    CGFloat viewWidth = SCREEN_WIDTH*4/17;
    NSLog(@"屏幕尺寸为，宽 %f ，高 %f",SCREEN_WIDTH,SCREEN_HEIGHT);
    CGFloat ViewHeight = 60;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(5+tag*viewWidth, 0, viewWidth, ViewHeight)];
    view.tag = tag;
    UILabel *titleBglb = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, viewWidth-5, ViewHeight-35)];
    titleBglb.backgroundColor = UIColorFromRGB(0x5aafe0);
    titleBglb.layer.cornerRadius = 10;
    titleBglb.layer.masksToBounds = YES;
    [view addSubview:titleBglb];
    if (add) {
        UIImageView *uiv2 = [[UIImageView alloc]initWithFrame:CGRectMake(viewWidth-12, 38, 10, 10)];
        uiv2.image = [UIImage imageNamed:@"加号"];
        [view addSubview:uiv2];
        UIButton *addbutton = [[UIButton alloc]initWithFrame:(CGRect)CGRectMake(viewWidth-12, 43, 10, 10)];
        [view addSubview:addbutton];
    }else{
        
    }
    
    UILabel *titlelb = [[UILabel alloc]initWithFrame:CGRectMake(35, 30, viewWidth-37, ViewHeight-35)];
    titlelb.textColor = [UIColor whiteColor];
    titlelb.font = [UIFont systemFontOfSize:11];
    titlelb.text = title;
    [view addSubview:titlelb];
    
    UIImageView *uiv = [[UIImageView alloc]initWithFrame:CGRectMake(0, 25, 30, 30)];
    uiv.image = [UIImage imageNamed:image];
    [view addSubview:uiv];
    
    view.userInteractionEnabled = YES;
    [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addValue:)]];
    
    return view;
}

-(void)addValue:(UITapGestureRecognizer *)gr{
    UIView *view = gr.view;
    switch (view.tag) {
        case 1:
            [self buyEnergy];
            break;
        case 3:
            [self buyDiomond];
            
        default:
            break;
    }
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
    //NSLog(@"dataSource count = @%@",self.dataSource);
    //return [self.dataSource count];
    //返回显示几条数据
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }else if (indexPath.section==1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
        return 60;
    }
    else if (indexPath == 1){
        return 370;
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
