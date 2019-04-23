//
//  LoginByPhoneNumberViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/5.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "LoginByPhoneNumberViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Masonry/Masonry.h"
#import "AppMacro.h"
#import "GVUserDefaults.h"

@interface LoginByPhoneNumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UITextField *checkNumber;
@property (weak, nonatomic) IBOutlet UIButton *getCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *loginByPhoneNumberButton;

@end

@implementation LoginByPhoneNumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getCheckNumber:(id)sender {
    
}
- (IBAction)loginByPhone:(id)sender {
    if (![self.userPhoneNumber.text isEqualToString:@""]&&![self.checkNumber.text isEqualToString:@""]) {
        AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //[delegate toMainGame];
    }
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
