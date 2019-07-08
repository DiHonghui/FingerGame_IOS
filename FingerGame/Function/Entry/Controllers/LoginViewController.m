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
@property (strong ,nonatomic) UILabel *forgotPassword;


@property (strong,nonatomic) UserLoginAPIManager *loginApimanager;
@end

@implementation LoginViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 1;
    [self.view insertSubview:imageView atIndex:0];
    UIImageView *logoView=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 80, SCREEN_WIDTH/3, SCREEN_WIDTH/3)];
    logoView.image=[UIImage imageNamed:@"登录页图的副本"];
    [self.view addSubview:logoView];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.forgotPassword];
    
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registButton];
    [self layoutSubviews];
    
}
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

-(void)layoutSubviews{
//    [self.logoImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(40);
//        make.width.equalTo(@180);
//        make.height.equalTo(@180);
//        make.centerX.equalTo(self.view.mas_centerX);
//    }];
//    self.logoImage.image = [UIImage imageNamed:@"健康豆.png"];
//    NSLog(@"logo 位置 %@",self.logoImage.bounds);
   
    [self.usernameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(280);
        make.width.equalTo(@240);
        make.height.equalTo(@40);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    self.usernameField.layer.cornerRadius = 6;
    
    
    [self.passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.centerX.equalTo(self.usernameField.mas_centerX);
        make.top.equalTo(self.usernameField.mas_bottom).offset(28);
    }];
    
    self.passwordField.layer.cornerRadius = 6;
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //make.right.equalTo(self.usernameField.mas_left).offset(100);
        make.centerY.equalTo(self.usernameField.mas_centerY);
        make.centerX.equalTo(self.usernameField.mas_centerX).offset(40);
    }];
    
    [self.passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.passwordField.mas_left).offset(-10);
        make.centerY.equalTo(self.passwordField.mas_centerY);
    }];
    
    [self.forgotPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordField.mas_bottom).offset(5);
        make.right.equalTo(self.passwordField.mas_right).offset(-5);
        make.width.equalTo(@60);
        make.height.equalTo(@20);
    }];
    
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.left.equalTo(self.usernameField.mas_left);
        make.top.equalTo(self.passwordField.mas_bottom).offset(58);
    }];
    [self.registButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.equalTo(self.usernameField.mas_width);
        make.height.equalTo(self.usernameField.mas_height);
        make.left.equalTo(self.usernameField.mas_left);
        make.bottom.equalTo(self.loginButton.mas_bottom).offset(58);
    }];
    self.loginButton.layer.cornerRadius = 6;
    self.registButton.layer.cornerRadius = 6;
    
}

#pragma mark - even response

- (void)loginbuttonClicked:(id)sender{
    
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
            [GVUserDefaults standardUserDefaults].experience = responseData[@"data"][@"experience"];

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
        _usernameField = [[UITextField alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/6, SCREEN_HEIGHT/2+20, SCREEN_WIDTH*2/3, 40)];
        _usernameField.placeholder = @"   请 输 入 用 户 名";
        _usernameField.backgroundColor = [UIColor whiteColor];
        _usernameField.returnKeyType = UIReturnKeyDone;
        _usernameField.delegate = self;
    }
    return _usernameField;
}
- (UITextField *)passwordField {
    if (!_passwordField){
        _passwordField = [[UITextField alloc] init];
        _passwordField.placeholder = @"   请 输 入 密 码";
        _passwordField.backgroundColor = [UIColor whiteColor];
        _passwordField.secureTextEntry = YES;
        _passwordField.returnKeyType = UIReturnKeyDone;
        _passwordField.delegate = self;
    }
    return _passwordField;
}
-(UILabel *)forgotPassword{
    if (!_forgotPassword) {
        _forgotPassword = [[UILabel alloc]init];
        _forgotPassword.text = @"忘记密码";
        _forgotPassword.textColor = [UIColor lightGrayColor];
        _forgotPassword.font = [UIFont systemFontOfSize:12];
        _forgotPassword.backgroundColor = [UIColor clearColor];
    }
    return _forgotPassword;
}

- (UIButton *)loginButton{
    if (!_loginButton) {
        _loginButton = [[UIButton alloc]init];
        _loginButton.backgroundColor = [UIColor blueColor];
        [_loginButton setTitle:@"登  录" forState:UIControlStateNormal];

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
        _registButton.backgroundColor=[UIColor orangeColor];
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
