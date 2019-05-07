//
//  ZHYBaseNavigationController.m
//  ZHYFramework
//
//  Created by apple on 16/5/28.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYBaseNavigationController.h"
#import "AppMacro.h"

@implementation ZHYBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = NavigationBarTintColor;
    self.navigationBar.tintColor = NavigationTintColor;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0x636363)};
    self.navigationBar.barStyle = UIBarStyleBlack;
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    [self setBottomBorderColor:UIColorFromRGB(0xA7A7A7) height:0.5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 *  自动收回tabbar
 *  @param viewController
 *  @param animated
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

/**
 *  设置navigationbar 下底的边界
 *  @param color
 *  @param height
 */
- (void)setBottomBorderColor:(UIColor *)color height:(CGFloat)height {
    CGRect bottomBorderRect = CGRectMake(0, CGRectGetHeight(self.navigationBar.frame), CGRectGetWidth(self.navigationBar.frame), height);
    UIView *bottomBorder = [[UIView alloc] initWithFrame:bottomBorderRect];
    [bottomBorder setBackgroundColor:color];
    [self.navigationBar addSubview:bottomBorder];
}

@end
