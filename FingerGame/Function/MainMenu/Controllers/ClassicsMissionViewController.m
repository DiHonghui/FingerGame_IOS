//
//  ClassicsMissionViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/6.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ClassicsMissionViewController.h"
#import "MJRefresh.h"
#import "YYModel.h"
#import "AppDelegate.h"
#import "GVUserDefaults+Properties.h"

@interface ClassicsMissionViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *energyAdd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *diamondAdd;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *healthyBeansAdd;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIToolbar *itemToolBar;

@end

@implementation ClassicsMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"精品列表";
    __weak typeof (self) weakself = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        
    }];
    self.tableView.userInteractionEnabled = YES;
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    self.energyAdd.title = [GVUserDefaults standardUserDefaults].energy;
    self.diamondAdd.title = [GVUserDefaults standardUserDefaults].diamond;
    self.healthyBeansAdd.title = [GVUserDefaults standardUserDefaults].healthyBeans;
    self.levelLabel.text = [GVUserDefaults standardUserDefaults].level;
    [self.tableView addSubview:_itemToolBar];
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

@end
