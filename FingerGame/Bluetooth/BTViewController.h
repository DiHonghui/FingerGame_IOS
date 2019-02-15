//
//  BTViewController.h
//  SZC
//
//  Created by lisy on 2018/8/13.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEInfo.h"
#import "DetailViewController.h"

@interface BTViewController : UITableViewController<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *centralMgr;
@property (nonatomic, strong) NSMutableArray *arrayBLE;

@end
