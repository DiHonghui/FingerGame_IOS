//
//  BTViewController.m
//  SZC
//
//  Created by lisy on 2018/8/13.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import "BTViewController.h"
#import "AppMacro.h"
#import "NSObject+ProgressHUD.h"
#import "MyBTManager.h"
#import "BLEInfo.h"

@interface BTViewController ()

@property (nonatomic,strong) NSMutableArray *arrayBLE;
@property (nonatomic,strong) MyBTManager *myBTManager;
@end

@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title=@"蓝牙搜索";
    UIColor *bgColor = [UIColor colorWithPatternImage: [UIImage imageNamed:@"顶栏.png"]];
    self.navigationController.navigationBar.barTintColor = bgColor;
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 0.4;
    [self.view insertSubview:imageView atIndex:0];
    
    self.arrayBLE = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"enter viewwillappear");
    [self showTable];
}

- (void)showTable{
    self.myBTManager = [MyBTManager sharedInstance];
    self.navigationItem.title = @"正在搜索蓝牙，请稍后...";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.arrayBLE = [self.myBTManager getSurroundedBLEDevices];
        self.navigationItem.title = @"选择一个蓝牙进行连接";
        [self.arrayBLE enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BLEInfo *cInfo = (BLEInfo *)obj;
            NSLog(@"设备信息：%@",cInfo.rssi);
        }];
        [self.tableView reloadData];
    });
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return _arrayBLE.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    // Add a detail view accessory
    BLEInfo *thisBLEInfo=[self.arrayBLE objectAtIndex:indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",thisBLEInfo.discoveredPeripheral.name,thisBLEInfo.rssi];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"UUID:%@",thisBLEInfo.discoveredPeripheral.identifier.UUIDString];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.navigationItem.title = @"正在连接中，请稍后...";
    //[self showProgress];
    BLEInfo *thisBLEInfo=[self.arrayBLE objectAtIndex:indexPath.row];
    [self.myBTManager connectPeripheral:thisBLEInfo.discoveredPeripheral finish:^(BOOL state) {
        //[self hideProgress];
        if (state == YES){
            //[self showHUDText:@"连接成功"];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"pop %@",[NSThread currentThread]);
                [self.navigationController popViewControllerAnimated:YES];
            });
           
        }
        else{
            //[self showErrorHUD:@"连接失败"];
            self.navigationItem.title = @"已连接，但未找到可读写特征";
            NSLog(@"已连接，但未找到可读写特征");
        }
    }];
}
@end


