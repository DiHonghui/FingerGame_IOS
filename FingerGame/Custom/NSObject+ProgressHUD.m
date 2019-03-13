//
//  NSObject+ProgressHUD.m
//  SZC
//
//  Created by lisy on 2018/8/27.
//  Copyright © 2018年 易用联友. All rights reserved.
//

#import "NSObject+ProgressHUD.h"
#import "MBProgressHUD.h"
#import <SVProgressHUD/SVProgressHUD.h>

@implementation NSObject (ProgressHUD)

- (void)alert:(NSString*)msg {
    UIAlertView *alertView=[[UIAlertView alloc]
                            initWithTitle:nil message:msg delegate:nil
                            cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

-(void)showNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=YES;
}

-(void)hideNetworkIndicator{
    UIApplication *app=[UIApplication sharedApplication];
    app.networkActivityIndicatorVisible=NO;
}

-(void)showProgress {
    [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
}

-(void)hideProgress {
    [MBProgressHUD hideHUDForView:kKeyWindow animated:YES];
}

- (void)showErrorHUD:(NSString *)error{
    [SVProgressHUD showErrorWithStatus:error];
}


- (void)toast:(NSString *)text {
    [self toast:text duration:2];
}

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
    hud.detailsLabelFont = [UIFont systemFontOfSize:14];
    hud.detailsLabelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:duration];
}

-(void)showHUDText:(NSString*)text{
    [self toast:text];
}

-(void)runInMainQueue:(void (^)())queue{
    dispatch_async(dispatch_get_main_queue(), queue);
}

-(void)runInGlobalQueue:(void (^)())queue{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), queue);
}

-(void)runAfterSecs:(float)secs block:(void (^)())block{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, secs*NSEC_PER_SEC), dispatch_get_main_queue(), block);
}
@end
