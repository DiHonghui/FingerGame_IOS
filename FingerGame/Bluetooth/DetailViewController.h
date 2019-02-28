//
//  DetailViewController.h
//  SZC
//
//  Created by lisy on 2018/8/19.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "MyBTManager.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) MyBTManager *myManager;

@end
