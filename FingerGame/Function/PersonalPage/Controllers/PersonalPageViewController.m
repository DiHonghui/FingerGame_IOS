//
//  PersonalPageViewController.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/27.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "PersonalPageViewController.h"
#import "GVUserDefaults+Properties.h"
#import "BasicTableViewCell.h"
#import "PersonalInfoBasicTableViewCell.h"
#import "NSObject+ProgressHUD.h"
#import "AppDelegate.h"
#import "OptionsViewController.h"
#import "UploadAvatarViewController.h"
#import "FavoritesTableViewController.h"

@interface PersonalPageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginout;

@property(nonatomic,strong)PersonalInfoBasicTableViewCell *personInfoCell;

@end

@implementation PersonalPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)loadData{
    //[self showProgress];
    [self.tableView reloadData];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return [PersonalInfoBasicTableViewCell heightForcell];
    }
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (!_personInfoCell) {
            UINib* nib = [UINib nibWithNibName:@"PersonalInfoBasicTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:@"PersonalInfoBasicTableViewCell"];
            _personInfoCell = [tableView dequeueReusableCellWithIdentifier:@"PersonalInfoBasicTableViewCell"];
        }
        return self.personInfoCell;
    }
//
    if (indexPath.section == 1) {
        BasicTableViewCell *cell = [[BasicTableViewCell alloc] init];
        if (indexPath.row == 0) {
            if (cell) {
                UINib* nib = [UINib nibWithNibName:@"BasicTableViewCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:@"BasicTableViewCell1"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"BasicTableViewCell1"];
            }
            [cell setSubTitle:@"音乐"];
            return cell;
        }
        if (indexPath.row == 1) {
            if (cell) {
                UINib* nib = [UINib nibWithNibName:@"BasicTableViewCell" bundle:nil];
                [tableView registerNib:nib forCellReuseIdentifier:@"BasicTableViewCell2"];
                cell = [tableView dequeueReusableCellWithIdentifier:@"BasicTableViewCell2"];
            }
            [cell setSubTitle:@"通知"];
        }
        
//        if (indexPath.row == 3) {
//            [cell setCellImage:[UIImage imageNamed:@"personal_charge"] Title:@"收入明细"];
//        }
        return cell;
    }
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"我的收藏";
        cell.textLabel.font = SystemFont(14);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.textLabel.text = @"游戏教程";
        cell.textLabel.font = SystemFont(14);
        cell.textLabel.textColor = UIColorFromRGB(0x666666);
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"设置";
    cell.textLabel.font = SystemFont(14);
    cell.textLabel.textColor = UIColorFromRGB(0x666666);
    cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        UploadAvatarViewController *upvc = [[UploadAvatarViewController alloc]init];
        [self.navigationController pushViewController:upvc animated:YES];
    }
    if (indexPath.section == 2) {
        FavoritesTableViewController *ftvc = [[FavoritesTableViewController alloc]init];
        [self.navigationController pushViewController:ftvc animated:YES];
    }
    if (indexPath.section == 4) {
        OptionsViewController *opvc = [[OptionsViewController alloc]init];
        [self.navigationController pushViewController:opvc animated:YES];
    }
}

- (IBAction)Loginout:(id)sender {
    //todo
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate toLogin];
}
@end
