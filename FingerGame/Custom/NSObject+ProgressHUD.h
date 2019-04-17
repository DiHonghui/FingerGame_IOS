//
//  NSObject+ProgressHUD.h
//  SZC
//
//  Created by lisy on 2018/8/27.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppMacro.h"

@interface NSObject (ProgressHUD)

- (void)showNetworkIndicator;

- (void)hideNetworkIndicator;

- (void)showProgress;

- (void)hideProgress;

- (void)alert:(NSString *)msg;

- (void)showErrorHUD:(NSString *)error;

- (void)runInMainQueue:(void (^)(void))queue;

- (void)runInGlobalQueue:(void (^)(void))queue;

- (void)runAfterSecs:(float)secs block:(void (^)(void))block;

- (void)showHUDText:(NSString *)text;

- (void)toast:(NSString *)text;

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration;

@end
