//
//  UploadAvatarViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/5.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "UploadAvatarViewController.h"
#import "GVUserDefaults+Properties.h"

@interface UploadAvatarViewController ()
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneNumber;
@property (weak, nonatomic) IBOutlet UILabel *healthyBeans;
@property (weak, nonatomic) IBOutlet UILabel *diamond;

@end

@implementation UploadAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadData{
    self.username.text = [GVUserDefaults standardUserDefaults].userName;
    self.userPhoneNumber.text = [GVUserDefaults standardUserDefaults].phoneNumber;
    self.diamond.text = [GVUserDefaults standardUserDefaults].diamond;
    self.healthyBeans.text = [GVUserDefaults standardUserDefaults].healthyBeans;
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
