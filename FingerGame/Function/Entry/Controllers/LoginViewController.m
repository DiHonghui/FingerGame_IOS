//
//  LoginViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/2/24.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Masonry/Masonry.h"
#import "AppMacro.h"
#import "GVUserDefaults+Properties.h"
#import "RegistViewController.h"
#import "UserLoginApiManager.h"
#import "MyAlertCenter.h"
#import "AFNetworkReachabilityManager.h"


@interface LoginViewController () <UITextFieldDelegate>

@property (strong,nonatomic)UITextField *usernameField;
@property (strong,nonatomic)UITextField *passwordField;

@property (strong,nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *registButton;

@property (strong, nonatomic) UILabel *usernameLabel;
@property (strong, nonatomic) UILabel *passwordLabel;

@property (strong,nonatomic) UserLoginAPIManager *loginApimanager;
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xEFEFEF);
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.passwordLabel];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registButton];
    [self layoutSubviews];
    
}

-(void)layoutSubviews{
    
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(@200);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).with.offset(200);
    }];
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.centerX.equalTo(self.usernameField.mas_centerX);
        make.top.equalTo(self.usernameField.mas_bottom).offset(28);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.usernameField.mas_left).offset(-10);
        make.centerY.equalTo(self.usernameField.mas_centerY);
    }];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.passwordField.mas_left).offset(-10);
        make.centerY.equalTo(self.passwordField.mas_centerY);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.left.equalTo(self.usernameField.mas_left);
        make.top.equalTo(self.passwordField.mas_bottom).offset(38);
    }];
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.left.equalTo(self.usernameField.mas_left);
        make.bottom.equalTo(self.loginButton.mas_bottom).offset(58);
    }];
    
}

#pragma mark - even response

- (void)loginbuttonClicked:(id)sender{
    
//    NSString *userNameTemp = @"12345";
//    NSString *passwardTemp = @"12345";
//    if ([userNameTemp isEqualToString:self.usernameField.text]&[passwardTemp isEqualToString:self.passwordField.text]){
//        NSLog(@"Entry game");
//        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//        //[delegate toMainGame];
//
//    }else{
//        NSLog(@"userName or passward error");
//    }
//    self.loginApimanager = [[UserLoginAPIManager alloc]initWithUserNameAndPassword:@"test" password:@"test123"];
    self.loginApimanager = [[UserLoginAPIManager alloc]initWithUserNameAndPassword:self.usernameField.text password:self.passwordField.text];
    [self.loginApimanager loadDataCompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
//        if (errorType == ZHYAPIManagerErrorTypeSuccess) {
        NSString *temp = [[NSString alloc]init];
        temp = responseData[@"data"];
        NSLog(@"error = %@",temp);
            if ([temp isKindOfClass:[NSNumber class]]) {
                [[MyAlertCenter defaultCenter] postAlertWithMessage:@"用户名或密码错误"];
                return;
            }
            [[MyAlertCenter defaultCenter] postAlertWithMessage:@"登陆成功"];
            [GVUserDefaults standardUserDefaults].userId = responseData[@"data"][@"id"];
            [GVUserDefaults standardUserDefaults].userPwd = responseData[@"data"][@"password"];
            [GVUserDefaults standardUserDefaults].userName = responseData[@"data"][@"name"];
            [GVUserDefaults standardUserDefaults].energy = responseData[@"data"][@"energy"];
            [GVUserDefaults standardUserDefaults].healthyBeans = responseData[@"data"][@"healthyBeans"];
            [GVUserDefaults standardUserDefaults].diamond = responseData[@"data"][@"diamond"];
            [GVUserDefaults standardUserDefaults].level = responseData[@"data"][@"level"];
            [GVUserDefaults standardUserDefaults].avatar = responseData[@"data"][@"avatar"];
            NSLog(@"用户ID = %@",[GVUserDefaults standardUserDefaults].userId);
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            [delegate toMain];
            
//        }
//        else{
//            NSLog(@"登录失败");
//        }
    }];

    
}
- (UITextField *)usernameField {
    if (!_usernameField){
        _usernameField = [[UITextField alloc] init];
        _usernameField.placeholder = @"用户名";
        
        _usernameField.returnKeyType = UIReturnKeyDone;
        _usernameField.delegate = self;
    }
    return _usernameField;
}
- (UITextField *)passwordField {
    if (!_passwordField){
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"密码";
        _passwordField.secureTextEntry = YES;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
    }
    return _passwordField;
}
- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        _loginButton.backgroundColor= [UIColor darkGrayColor];
        [_loginButton addTarget:self action:@selector(loginbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

- (UIButton *)registButton{
    if (!_registButton) {
        _registButton = [[UIButton alloc]init];
        //_registButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_registButton setTitle:@"没有账号，点此注册" forState:UIControlStateNormal];
        //_registButton.layer.cornerRadius = 20;
        _registButton.layer.masksToBounds = YES;
        //_registButton.layer.borderWidth = 2.0;
        //_registButton.layer.borderColor = UIColorFromRGB(0x1EB19E).CGColor;
        [_registButton setTintColor:UIColorFromRGB(0x1EB19E)];
        _registButton.backgroundColor=[UIColor lightGrayColor];
        //[_registButton setBackgroundColor:UIColorFromRGB(0xffffff)];
        [_registButton addTarget:self action:@selector(regist:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registButton;
}

-(void)regist:(id)sender{
    RegistViewController *rv = [[RegistViewController alloc]init];
    [self.navigationController pushViewController:rv animated:YES];
}

@end
