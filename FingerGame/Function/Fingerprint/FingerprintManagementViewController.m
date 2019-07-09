//
//  FingerprintManagementViewController.m
//  FingerGame
//
//  Created by lisy on 2019/6/28.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "FingerprintManagementViewController.h"

#import "FpInfoModel.h"

#import "AppMacro.h"
#import "Masonry.h"
#import "NSObject+ProgressHUD.h"
#import "MyBTManager.h"
#import "FingerprintInfoApiManager.h"
#import "LoginFingerprintApiManager.h"

typedef NS_ENUM(NSInteger,FingerprintLoginState){
    LoginStateDefault = 0,
    LoginStateSingle,
    LoginStateTogether
};

@interface FingerprintManagementViewController () <MyBTManagerProtocol>

@property (nonatomic,strong) MyBTManager *myBTManager;

@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *machineId;
@property (nonatomic,strong) NSMutableArray *fpArray;

@property (nonatomic,strong) NSMutableArray *viewArray;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *loginAllView;
@property (nonatomic,strong) UILabel *loginAllLabel;
@property (nonatomic,strong) UILabel *tipLabel;

@property (nonatomic,assign) FingerprintLoginState loginState;

@property (nonatomic,assign) int curOperatingFinger;
@property (nonatomic,assign) NSString *curLoginLocation;

@property (nonatomic,strong) NSMutableArray *alreadyLoginArray;

@end

@implementation FingerprintManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imageView.image=[UIImage imageNamed:@"Game_Background"];
    imageView.alpha = 1;
    [self.view insertSubview:imageView atIndex:0];
    [self layoutMySubviews];
    [self loadData];
}

- (instancetype)initWithUserId:(NSString *)userId MachineId:(nonnull NSString *)machineId{
    if (self=[super init]) {
        self.userId = userId;
        self.machineId = machineId;
        self.myBTManager = [MyBTManager sharedInstance];
        self.myBTManager.delegate = self;
        self.loginState = LoginStateDefault;
        self.fpArray = [[NSMutableArray alloc] initWithCapacity:11];
    }
    return self;
}

- (void)layoutMySubviews{
//    [self initMyFingerprintAppearence];
    //
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH/8, SCREEN_HEIGHT/12)];
    backView.layer.cornerRadius = 15;
    backView.backgroundColor = UIColorFromRGB(0x03b5f5);
    backView.userInteractionEnabled = YES;
    [backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBack:)]];
    UILabel *backLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, SCREEN_WIDTH/8-4, SCREEN_HEIGHT/12-4)];
    backLabel.backgroundColor = [UIColor clearColor];
    backLabel.text = @"返回";
    backLabel.textColor = UIColorFromRGB(0xffffff);
    backLabel.textAlignment = NSTextAlignmentCenter;
    [backView addSubview:backLabel];
    [self.view addSubview:backView];
    //
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"指纹管理";
    _titleLabel.textColor = UIColorFromRGB(0xffffff);
    _titleLabel.font = [UIFont systemFontOfSize:40];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view  addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_top).offset(40);
    }];
    //
    _loginAllView = [[UIView alloc] init];
    _loginAllView.layer.cornerRadius = 15;
    _loginAllView.backgroundColor = UIColorFromRGB(0xff8746);
    _loginAllView.tag = 11;
    _loginAllView.userInteractionEnabled = YES;
    [_loginAllView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLoginAllFp:)]];
    _loginAllLabel = [[UILabel alloc] init];
    _loginAllLabel.backgroundColor = [UIColor clearColor];
    _loginAllLabel.text = @"同时录十指指纹";
    _loginAllLabel.textColor = UIColorFromRGB(0xffffff);
    _loginAllLabel.textAlignment = NSTextAlignmentCenter;
    _loginAllLabel.font = [UIFont systemFontOfSize:26];
    [_loginAllView addSubview:_loginAllLabel];
    [self.view addSubview:_loginAllView];
    [_loginAllView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_bottom).offset(-80);
        make.height.equalTo(@40);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.4);
    }];
    [_loginAllLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginAllView.mas_centerX);
        make.centerY.equalTo(self.loginAllView.mas_centerY);
    }];
    //
    _tipLabel = [[UILabel alloc] init];
    _tipLabel.text = @"说明：十指同时录指纹可同时录入双手的指纹";
    _tipLabel.textColor = UIColorFromRGB(0xffffff);
    _tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipLabel];
    [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_bottom).offset(-40);
    }];
}

- (void)initMyFingerprintAppearence{
    self.viewArray = [NSMutableArray array];
    NSLog(@"%lu",(unsigned long)[self.fpArray count]);
    [self.fpArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = [self viewWithName:((FpInfoModel *)obj).fingerName Index:((FpInfoModel *)obj).fingerId StoreLoaction:((FpInfoModel *)obj).storeLocation];
        [self.view addSubview:view];
        [self.viewArray addObject:view];
    }];
}

- (UIView *)viewWithName:(NSString *)name Index:(NSString *)index StoreLoaction:(NSString *)storeLocation{
    NSInteger i = [index integerValue];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10)*i, SCREEN_HEIGHT/4, SCREEN_WIDTH/10, SCREEN_HEIGHT/3)];
    v.tag = i;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_HEIGHT/12)];
    lb.text = name;
    lb.textColor = UIColorFromRGB(0xffffff);
    lb.textAlignment = NSTextAlignmentCenter;
    switch (i) {
        case 0:
        case 9:
            lb.backgroundColor = UIColorFromRGB(0xff5534);
            break;
        case 1:
        case 8:
            lb.backgroundColor = UIColorFromRGB(0xff8746);
            break;
        case 2:
        case 7:
            lb.backgroundColor = UIColorFromRGB(0xffda46);
            break;
        case 3:
        case 6:
            lb.backgroundColor = UIColorFromRGB(0x63b55b);
            break;
        case 4:
        case 5:
            lb.backgroundColor = UIColorFromRGB(0x4069de);
            break;
        default:
            break;
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(3, SCREEN_HEIGHT/12+3, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6)];
    iv.backgroundColor = [UIColor clearColor];
    
    UIView *lgView = [[UIView alloc] initWithFrame:CGRectMake(3, SCREEN_HEIGHT/12+SCREEN_WIDTH/10, SCREEN_WIDTH/10-6, SCREEN_HEIGHT/12)];
    lgView.layer.cornerRadius = 15;
    lgView.userInteractionEnabled = YES;
    [lgView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLogin:)]];
    lgView.tag = i;
    UILabel *lgLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, 2, SCREEN_WIDTH/10-8, SCREEN_HEIGHT/12-4)];
    lgLabel.backgroundColor = [UIColor clearColor];
    lgLabel.textColor = UIColorFromRGB(0xffffff);
    lgLabel.textAlignment = NSTextAlignmentCenter;
    
    if ([storeLocation isEqualToString:@"-1"]){
        iv.image = [UIImage imageNamed:@"Fingerprint_Default"];
        lgView.backgroundColor = UIColorFromRGB(0xff8746);
        lgLabel.text = @"补录";
    }
    else{
        iv.image = [UIImage imageNamed:@"Fingerprint_Finished"];
        lgView.backgroundColor = UIColorFromRGB(0x63b55b);
        lgLabel.text = @"重录";
    }
    
    [v addSubview:lb];
    [v addSubview:iv];
    [lgView addSubview:lgLabel];
    [v addSubview:lgView];
    return v;
}

- (UIView *)viewIncludeImageWithName:(NSString *)name Index:(NSString *)index Flag:(int)flag{
    NSInteger i = [index integerValue];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10)*i, SCREEN_HEIGHT/4, SCREEN_WIDTH/10, SCREEN_HEIGHT/3)];
    v.tag = i;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_HEIGHT/12)];
    lb.text = name;
    lb.textColor = UIColorFromRGB(0xffffff);
    lb.textAlignment = NSTextAlignmentCenter;
    switch (i) {
        case 0:
        case 9:
            lb.backgroundColor = UIColorFromRGB(0xff5534);
            break;
        case 1:
        case 8:
            lb.backgroundColor = UIColorFromRGB(0xff8746);
            break;
        case 2:
        case 7:
            lb.backgroundColor = UIColorFromRGB(0xffda46);
            break;
        case 3:
        case 6:
            lb.backgroundColor = UIColorFromRGB(0x63b55b);
            break;
        case 4:
        case 5:
            lb.backgroundColor = UIColorFromRGB(0x4069de);
            break;
        default:
            break;
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(3, SCREEN_HEIGHT/12+3, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6)];
    iv.backgroundColor = [UIColor clearColor];
    
    UIImageView *fIv = [[UIImageView alloc] init];
    
    if (flag == 0){
        iv.image = [UIImage imageNamed:@"Fingerprint_Default"];
        [fIv setImage:[UIImage imageNamed:@"LoginFP_Fail"]];
    }else{
        iv.image = [UIImage imageNamed:@"Fingerprint_Finished"];
        [fIv setImage:[UIImage imageNamed:@"LoginFP_OK"]];
    }
    
    [v addSubview:lb];
    [v addSubview:iv];
    [v addSubview:fIv];
    [fIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(v.mas_centerX);
        make.top.equalTo(iv.mas_bottom).offset(6);
        make.height.equalTo(@(SCREEN_HEIGHT/12));
        make.width.equalTo(@(SCREEN_HEIGHT/12));
    }];
    return v;
}

- (UIView *)viewBlankWithName:(NSString *)name Index:(NSString *)index{
    NSInteger i = [index integerValue];
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10)*i, SCREEN_HEIGHT/4, SCREEN_WIDTH/10, SCREEN_HEIGHT/3)];
    v.tag = i;
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/10, SCREEN_HEIGHT/12)];
    lb.text = name;
    lb.textColor = UIColorFromRGB(0xffffff);
    lb.textAlignment = NSTextAlignmentCenter;
    switch (i) {
        case 0:
        case 9:
            lb.backgroundColor = UIColorFromRGB(0xff5534);
            break;
        case 1:
        case 8:
            lb.backgroundColor = UIColorFromRGB(0xff8746);
            break;
        case 2:
        case 7:
            lb.backgroundColor = UIColorFromRGB(0xffda46);
            break;
        case 3:
        case 6:
            lb.backgroundColor = UIColorFromRGB(0x63b55b);
            break;
        case 4:
        case 5:
            lb.backgroundColor = UIColorFromRGB(0x4069de);
            break;
        default:
            break;
    }
    
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(3, SCREEN_HEIGHT/12+3, SCREEN_WIDTH/10-6, SCREEN_WIDTH/10-6)];
    iv.backgroundColor = [UIColor clearColor];
    iv.image = [UIImage imageNamed:@"Fingerprint_Default"];
    [v addSubview:lb];
    [v addSubview:iv];
    return v;
}

- (void)loadData{
    FingerprintInfoApiManager *manager = [[FingerprintInfoApiManager alloc] init];
    [manager loadDataWithParams:@{@"service":@"App.Fingerprint.GetFingerPrint",@"userId":self.userId,@"machineId":self.machineId} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        if (errorType == ZHYAPIManagerErrorTypeSuccess){
            NSLog(@"response == %@",responseData[@"data"]);
            if ([responseData[@"data"][@"code"] integerValue] == 0){
                NSLog(@"新的机器码");
                LoginFingerprintApiManager *m = [[LoginFingerprintApiManager alloc] init];
                NSDictionary *dic = @{@"service":@"App.Fingerprint.SetAllFingerPrint",@"userId":self.userId,@"machineId":self.machineId,@"f0":@"-1",@"f1":@"-1",@"f2":@"-1",@"f3":@"-1",@"f4":@"-1",@"f5":@"-1",@"f6":@"-1",@"f7":@"-1",@"f8":@"-1",@"f9":@"-1"};
                [m loadDataWithParams:dic CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
                    [self loadData];
                }];
            }
            else{
                if (self.fpArray) {
                    [self.fpArray removeAllObjects];
                    //
                    FpInfoModel *fp1 = [[FpInfoModel alloc] init];
                    fp1.fingerId = @"0"; fp1.fingerName = @"小拇指"; fp1.storeLocation = responseData[@"data"][@"info"][@"f0"];
                    [self.fpArray addObject:fp1];
                    FpInfoModel *fp2 = [[FpInfoModel alloc] init];
                    fp2.fingerId = @"1"; fp2.fingerName = @"无名指"; fp2.storeLocation = responseData[@"data"][@"info"][@"f1"];
                    [self.fpArray addObject:fp2];
                    FpInfoModel *fp3 = [[FpInfoModel alloc] init];
                    fp3.fingerId = @"2"; fp3.fingerName = @"中指"; fp3.storeLocation = responseData[@"data"][@"info"][@"f2"];
                    [self.fpArray addObject:fp3];
                    FpInfoModel *fp4 = [[FpInfoModel alloc] init];
                    fp4.fingerId = @"3"; fp4.fingerName = @"食指"; fp4.storeLocation = responseData[@"data"][@"info"][@"f3"];
                    [self.fpArray addObject:fp4];
                    FpInfoModel *fp5 = [[FpInfoModel alloc] init];
                    fp5.fingerId = @"4"; fp5.fingerName = @"大拇指"; fp5.storeLocation = responseData[@"data"][@"info"][@"f4"];
                    [self.fpArray addObject:fp5];
                    FpInfoModel *fp6 = [[FpInfoModel alloc] init];
                    fp6.fingerId = @"5"; fp6.fingerName = @"大拇指"; fp6.storeLocation = responseData[@"data"][@"info"][@"f5"];
                    [self.fpArray addObject:fp6];
                    FpInfoModel *fp7 = [[FpInfoModel alloc] init];
                    fp7.fingerId = @"6"; fp7.fingerName = @"食指"; fp7.storeLocation = responseData[@"data"][@"info"][@"f6"];
                    [self.fpArray addObject:fp7];
                    FpInfoModel *fp8 = [[FpInfoModel alloc] init];
                    fp8.fingerId = @"7"; fp8.fingerName = @"中指"; fp8.storeLocation = responseData[@"data"][@"info"][@"f7"];
                    [self.fpArray addObject:fp8];
                    FpInfoModel *fp9 = [[FpInfoModel alloc] init];
                    fp9.fingerId = @"8"; fp9.fingerName = @"无名指"; fp9.storeLocation = responseData[@"data"][@"info"][@"f8"];
                    [self.fpArray addObject:fp9];
                    FpInfoModel *fp10 = [[FpInfoModel alloc] init];
                    fp10.fingerId = @"9"; fp10.fingerName = @"小拇指"; fp10.storeLocation = responseData[@"data"][@"info"][@"f9"];
                    [self.fpArray addObject:fp10];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self initMyFingerprintAppearence];
                    });
                }
            }
        }else{
            NSLog(@"%@",responseData[@"msg"]);
            if (self.fpArray) {
                [self.fpArray removeAllObjects];
                FpInfoModel *fp1 = [[FpInfoModel alloc] init];
                fp1.fingerId = @"0"; fp1.fingerName = @"小拇指"; fp1.storeLocation = @"-1";
                [self.fpArray addObject:fp1];
                FpInfoModel *fp2 = [[FpInfoModel alloc] init];
                fp2.fingerId = @"1"; fp2.fingerName = @"无名指"; fp2.storeLocation = @"-1";
                [self.fpArray addObject:fp2];
                FpInfoModel *fp3 = [[FpInfoModel alloc] init];
                fp3.fingerId = @"2"; fp3.fingerName = @"中指"; fp3.storeLocation = @"-1";
                [self.fpArray addObject:fp3];
                FpInfoModel *fp4 = [[FpInfoModel alloc] init];
                fp4.fingerId = @"3"; fp4.fingerName = @"食指"; fp4.storeLocation = @"-1";
                [self.fpArray addObject:fp4];
                FpInfoModel *fp5 = [[FpInfoModel alloc] init];
                fp5.fingerId = @"4"; fp5.fingerName = @"大拇指"; fp5.storeLocation = @"-1";
                [self.fpArray addObject:fp5];
                FpInfoModel *fp6 = [[FpInfoModel alloc] init];
                fp6.fingerId = @"5"; fp6.fingerName = @"大拇指"; fp6.storeLocation = @"-1";
                [self.fpArray addObject:fp6];
                FpInfoModel *fp7 = [[FpInfoModel alloc] init];
                fp7.fingerId = @"6"; fp7.fingerName = @"食指"; fp7.storeLocation = @"-1";
                [self.fpArray addObject:fp7];
                FpInfoModel *fp8 = [[FpInfoModel alloc] init];
                fp8.fingerId = @"7"; fp8.fingerName = @"中指"; fp8.storeLocation = @"-1";
                [self.fpArray addObject:fp8];
                FpInfoModel *fp9 = [[FpInfoModel alloc] init];
                fp9.fingerId = @"8"; fp9.fingerName = @"无名指"; fp9.storeLocation = @"-1";
                [self.fpArray addObject:fp9];
                FpInfoModel *fp10 = [[FpInfoModel alloc] init];
                fp10.fingerId = @"9"; fp10.fingerName = @"小拇指"; fp10.storeLocation = @"-1";
                [self.fpArray addObject:fp10];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initMyFingerprintAppearence];
                });
            }
        }
    }];
}

- (void)uploadFpToServerWithId:(NSString *)fpId Location:(NSString *)location{
    LoginFingerprintApiManager *manager = [[LoginFingerprintApiManager alloc] init];
    [manager loadDataWithParams:@{@"service":@"App.Fingerprint.SetFingerPrint",@"userId":self.userId,@"machineId":self.machineId,@"fingerId":fpId,@"fingerValue":location} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        NSLog(@"%@",responseData);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }];
}

- (void)uploadTenFpTogether{
    NSLog(@"%lu",(unsigned long)[self.alreadyLoginArray count]);
    __block NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setValue:@"hello" forKey:@"10"];
    NSLog(@"%@",[dic valueForKey:@"10"]);
    [self.alreadyLoginArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FpInfoModel *m = (FpInfoModel *)obj;
        //[self uploadFpToServerWithId:m.fingerId Location:m.storeLocation];
        [dic setValue:m.storeLocation forKey:[NSString stringWithFormat:@"f%@",m.fingerId]];
    }];
    [dic setValue:@"-1" forKey:@"f8"];
    [dic setValue:@"-1" forKey:@"f9"];
    [dic setValue:@"App.Fingerprint.SetAllFingerPrint" forKey:@"service"];
    [dic setValue:self.userId forKey:@"userId"];
    [dic setValue:self.machineId forKey:@"machineId"];
    LoginFingerprintApiManager *manager = [[LoginFingerprintApiManager alloc] init];
    [manager loadDataWithParams:dic CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
        NSLog(@"%@",responseData);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadData];
        });
    }];
}

#pragma mark - event
- (void)tapLogin:(UIGestureRecognizer *)gr{
    [self showProgress];
    NSLog(@"%ld   %@",(long)gr.view.tag,((FpInfoModel*)[self.fpArray objectAtIndex:(gr.view.tag)]).storeLocation);
    FpInfoModel *model = (FpInfoModel*)[self.fpArray objectAtIndex:(gr.view.tag)];
    if ( [model.storeLocation isEqualToString:@"-1"] ){
        NSLog(@"tap 补录");
        if ([self.myBTManager isBluetoothLinked]){
            [self.myBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%@0%@ff",model.fingerId,model.fingerId]];
            self.loginState = LoginStateSingle;
            self.curOperatingFinger = (int)gr.view.tag;
            self.curLoginLocation = model.fingerId;
        }
    }else{
        NSLog(@"tap 重录");
        if ([self.myBTManager isBluetoothLinked]){
            [self.myBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%@0%@ff",model.fingerId,model.storeLocation]];
            self.loginState = LoginStateSingle;
            self.curOperatingFinger = (int)gr.view.tag;
            self.curLoginLocation = model.storeLocation;
        }
    }
}

- (void)tapLoginAllFp:(UIGestureRecognizer *)gr{
    if (gr.view.tag == 11){
        [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *v = (UIView *)obj;
            [v removeFromSuperview];
            FpInfoModel *model = (FpInfoModel*)[self.fpArray objectAtIndex:idx];
            v = [self viewBlankWithName:model.fingerName Index:model.fingerId];
            [self.view addSubview:v];
            [self.viewArray setObject:v atIndexedSubscript:idx];
        }];
        //
        NSLog(@"tap 一起录入");
        self.alreadyLoginArray = [NSMutableArray array];
        if ([self.myBTManager isBluetoothLinked]){
            [self.myBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%@0%@ff",@"0",@"0"]];
            self.loginState = LoginStateTogether;
            self.curOperatingFinger = 0;
            self.curLoginLocation = @"0";
            self.loginAllLabel.text = @"录入中...";
            self.loginAllView.tag = 10;
            [self showProgress];
        }
    }
    if (gr.view.tag == 12){
        NSLog(@"tap 保存");
        [self.viewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *v = (UIView *)obj;
            [v removeFromSuperview];
        }];
        self.loginAllLabel.text = @"同时录十指指纹";
        self.loginAllView.tag = 11;
        [self uploadTenFpTogether];
    }

}

- (void)tapBack:(UIGestureRecognizer *)gr{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - MyBTManagerDelegate
////                返回录入指纹指令
////                0x02：第一次按指纹成功；0x03：第一次按指纹失败
////                0x04：第二次按指纹成功；0x05：第二次按指纹失败
////                0x07：合并指纹成功；    0x08：合并指纹失败
////                0x09：录入指纹成功：    0x0a: 录入指纹失败
////                     起始位        长度        指令组ID        录入成功或者失败        校验位
////                字节    1          2            3                 4                5
////                内容    0xaa        0x02        0x03             见右           3-4累加和校验
- (void)receiveDataFromBLE:(NSString *)sdata {
    NSLog(@"代理人收到指令：%@",sdata);
    if (self.loginState == LoginStateSingle){
        if ([sdata containsString:@"aa0203090c"]){
            NSLog(@"当前手指%d指纹录入成功",self.curOperatingFinger);
            self.loginState = LoginStateDefault;
            [self uploadFpToServerWithId:[NSString stringWithFormat:@"%d",self.curOperatingFinger] Location:self.curLoginLocation];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgress];
                [self showHUDText:[NSString stringWithFormat:@"手指%d指纹录入成功",self.curOperatingFinger]];
            });
        }
        if ([sdata containsString:@"aa02030e11"]){
            NSLog(@"当前手指%d指纹录入失败",self.curOperatingFinger);
            self.loginState = LoginStateDefault;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideProgress];
                [self showHUDText:[NSString stringWithFormat:@"手指%d指纹录入失败",self.curOperatingFinger]];
            });
        }
    }else{
        if (self.loginState == LoginStateTogether){
            if ([sdata containsString:@"aa0203090c"]){
                NSLog(@"当前手指%d指纹录入成功",self.curOperatingFinger);
                FpInfoModel *m = [[FpInfoModel alloc] init];
                m.fingerId = [NSString stringWithFormat:@"%d",self.curOperatingFinger];
                m.storeLocation = self.curLoginLocation;
                [self.alreadyLoginArray addObject:m];
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *v = (UIView *)[self.viewArray objectAtIndex:self.curOperatingFinger];
                    [v removeFromSuperview];
                    FpInfoModel *model = (FpInfoModel*)[self.fpArray objectAtIndex:self.curOperatingFinger];
                    v = [self viewIncludeImageWithName:model.fingerName Index:model.fingerId Flag:1];
                    [self.view addSubview:v];
                    [self.viewArray setObject:v atIndexedSubscript:self.curOperatingFinger];
                    
                    if (self.curOperatingFinger == 7){
                        self.loginState = LoginStateDefault;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self hideProgress];
                            [self.loginAllLabel setText:@"保存"];
                            self.loginAllView.tag = 12;
                        });
                    }
                    else {
                        self.curOperatingFinger ++;
                        self.curLoginLocation = [NSString stringWithFormat:@"%d",self.curOperatingFinger];
                        [self.myBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%d0%@ff",self.curOperatingFinger,self.curLoginLocation]];
                    }
                });
            }
            else{
                if ([sdata containsString:@"aa02030e11"]){
                    NSLog(@"当前手指%d指纹录入失败",self.curOperatingFinger);
                    FpInfoModel *m = [[FpInfoModel alloc] init];
                    m.fingerId = [NSString stringWithFormat:@"%d",self.curOperatingFinger];
                    m.storeLocation = @"-1";
                    [self.alreadyLoginArray addObject:m];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        UIView *v = (UIView *)[self.viewArray objectAtIndex:self.curOperatingFinger];
                        [v removeFromSuperview];
                        FpInfoModel *model = (FpInfoModel*)[self.fpArray objectAtIndex:self.curOperatingFinger];
                        v = [self viewIncludeImageWithName:model.fingerName Index:model.fingerId Flag:0];
                        [self.view addSubview:v];
                        [self.viewArray setObject:v atIndexedSubscript:self.curOperatingFinger];
                        
                        if (self.curOperatingFinger == 7){
                            self.loginState = LoginStateDefault;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self hideProgress];
                                [self.loginAllLabel setText:@"保存"];
                                self.loginAllView.tag = 12;
                            });
                        }
                        else {
                            self.curOperatingFinger ++;
                            self.curLoginLocation = [NSString stringWithFormat:@"%d",self.curOperatingFinger];
                            [self.myBTManager writeToPeripheral:[NSString stringWithFormat:@"aa02020%d0%@ff",self.curOperatingFinger,self.curLoginLocation]];
                        }
                    });
                }
            }
        }else{
            NSLog(@"当前不是指纹录入状态");
        }
    }
}


#pragma mark - 强制横屏（只能model视图有效）
//生命周期在viewdidload之后，在viewwillappear之前
- (BOOL)shouldAutorotate
{
    //是否支持转屏
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //支持哪些转屏方向
    return UIInterfaceOrientationMaskLandscape;
}
//进入界面直接旋转的方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}
// 是否隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
