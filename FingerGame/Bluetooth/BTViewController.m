//
//  BTViewController.m
//  SZC
//
//  Created by lisy on 2018/8/13.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import "BTViewController.h"
#import "AppMacro.h"
#import "MyBTManager.h"

@interface BTViewController ()
@property (nonatomic,strong) NSMutableArray *arrayBLE;
@property (nonatomic,strong) MyBTManager *myBTManager;
@end

@implementation BTViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title=@"蓝牙搜索";

    self.arrayBLE = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"enter viewwillappear");
    [self showTable];
}

- (void)showTable{
    self.myBTManager = [MyBTManager sharedInstance];
    self.navigationItem.title = @"正在搜索蓝牙，请稍后...";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BLEInfo *thisBLEInfo=[self.arrayBLE objectAtIndex:indexPath.row];
    [self.myBTManager connectPeripheral:thisBLEInfo.discoveredPeripheral finish:^(BOOL state) {
        if (state == YES){
            [self.myBTManager readValue];
            DetailViewController *dvc = [[DetailViewController alloc] init];
            [self.navigationController pushViewController:dvc animated:YES];
        }
        else{
            NSLog(@"已连接，但未找到可读写特征");
        }
    }];
}
@end


