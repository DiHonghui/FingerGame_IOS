//
//  RegistViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/3.
//  Copyright © 2019年 lisy. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "RegistViewController.h"
#import "AppDelegate.h"
#import "Masonry/Masonry.h"
#import "AppMacro.h"
#import "GVUserDefaults.h"
#import "UserRegistAPIManager.h"
#import "GVUserDefaults+Properties.h"


@interface RegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userPassword;
@property (weak, nonatomic) IBOutlet UIButton *getCheckNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;

@property(weak,nonatomic) UserRegistAPIManager* userRegistApiManger;

@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)registClick:(id)sender {
    if (![self.userName.text isEqualToString:@""]&&![self.userPassword.text isEqualToString:@""]&&![self.userPhoneNumber.text isEqualToString:@""]) {
        self.userRegistApiManger = [[UserRegistAPIManager alloc]initWithUserInfo:self.userName.text password:self.userPassword.text userPhoneNumber:self.userPhoneNumber.text];
        [self.userRegistApiManger loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            //        if (errorType == ZHYAPIManagerErrorTypeSuccess) {
            if ([responseData[@"data"] isEqualToString:@"该用户名已注册"]) {
                NSLog(@"注册失败，用户名已注册");
                return;
            }
            NSLog(@"登陆成功");
            [GVUserDefaults standardUserDefaults].userId = responseData[@"data"][@"id"];
            [GVUserDefaults standardUserDefaults].userPwd = responseData[@"data"][@"password"];
            [GVUserDefaults standardUserDefaults].userName = responseData[@"data"][@"name"];
            NSLog(@"用户ID = %@",[GVUserDefaults standardUserDefaults].userId);
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate toMain2];
        
        //AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[delegate toMainGame];
        }];
}
}
- (IBAction)getCheckNumber:(id)sender {
    __block int timeout = 59;//倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{//设置界面的按钮显示 根据自己需求设置
                [self.getCheckNumberButton setTitle:@"发送验证码" forState:UIControlStateNormal];
                self.getCheckNumberButton.userInteractionEnabled = YES;
            });
        }else{
            //int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.getCheckNumberButton setTitle:[NSString stringWithFormat:@"%@秒后重发",strTime] forState:UIControlStateNormal];
                self.getCheckNumberButton.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
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
