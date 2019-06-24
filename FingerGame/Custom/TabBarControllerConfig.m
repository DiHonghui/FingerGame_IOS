//
//  TabBarControllerConfig.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/28.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "AppMacro.h"
#import "ClassicStageViewController.h"
#import "TabBarControllerConfig.h"
#import "GameStageTableViewController.h"
#import "GameDetailViewController.h"
#import "PersonalPageViewController.h"
#import "ZHYBaseNavigationController.h"
#import "ClassicsMissionViewController.h"
#import "PCViewController.h"

@interface TabBarControllerConfig()
@property (strong, nonatomic, readwrite) UITabBarController *tabBarController;

@end
@implementation TabBarControllerConfig

- (UITabBarController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.tabBar.tintColor = UIColorFromRGB(0xCC8D4A);
        
        GameStageTableViewController *tvc1 = [[GameStageTableViewController alloc]init];
        ZHYBaseNavigationController *nc1 = [[ZHYBaseNavigationController alloc] initWithRootViewController:tvc1];
        nc1.tabBarItem.title = @"游戏列表";
        
        ClassicStageViewController *ctvc = [[ClassicStageViewController alloc]init];
        ZHYBaseNavigationController *nc2 = [[ZHYBaseNavigationController alloc]initWithRootViewController:ctvc];
        nc2.tabBarItem.title=@"精品列表";
        
        PCViewController *pvc1 = [[PCViewController alloc]init];
        ZHYBaseNavigationController *nc3 = [[ZHYBaseNavigationController alloc] initWithRootViewController:pvc1];
        nc3.tabBarItem.title=@"个人中心";
        
        [_tabBarController setViewControllers:@[nc1, nc2, nc3]];
        
    }
    return _tabBarController;
}

/*
 下面这段还没大概理解，刷新用？
 */

//- (void)setUpTabBarItemBadgesForControllers:(NSArray<UIViewController *> *)viewControllers {
//    for (UIViewController *viewController in viewControllers) {
//        if ([viewController respondsToSelector:@selector(refresh)]) {
//            [viewController performSelector:@selector(refresh)];
//        }
//    }
//}
@end
