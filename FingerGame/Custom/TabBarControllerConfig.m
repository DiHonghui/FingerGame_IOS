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
        _tabBarController.tabBar.backgroundColor = [UIColor clearColor];
        
        GameStageTableViewController *tvc1 = [[GameStageTableViewController alloc]init];
        ZHYBaseNavigationController *nc1 = [[ZHYBaseNavigationController alloc] initWithRootViewController:tvc1];
        nc1.tabBarItem.title = @"游戏列表";
        //nc1.tabBarItem.selectedImage = [[SmallTools imageResize:[UIImage imageNamed:selected] andResizeTo:CGSizeMake(25, 25)] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imagehome = [UIImage imageNamed:@"底个首页"];
        UIImage *imageHome = [self imageResize:imagehome andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        
        imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc1.tabBarItem setSelectedImage:imageHome];
        [nc1.tabBarItem setImage:imageHome];
        ClassicStageViewController *ctvc = [[ClassicStageViewController alloc]init];
        ZHYBaseNavigationController *nc2 = [[ZHYBaseNavigationController alloc]initWithRootViewController:ctvc];
        nc2.tabBarItem.title=@"精品列表";
        UIImage *imagestar = [UIImage imageNamed:@"底个精品"];
        UIImage *imageStar = [self imageResize:imagestar andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        imageStar = [imageStar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc2.tabBarItem setSelectedImage:imageStar];
        [nc2.tabBarItem setImage:imageStar];
        
        PCViewController *pvc1 = [[PCViewController alloc]init];
        ZHYBaseNavigationController *nc3 = [[ZHYBaseNavigationController alloc] initWithRootViewController:pvc1];
        nc3.tabBarItem.title=@"个人中心";
        UIImage *imageperson = [UIImage imageNamed:@"底个人中心"];
        UIImage *imagePerson = [self imageResize:imageperson andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        imagePerson = [imagePerson imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc3.tabBarItem setSelectedImage:imagePerson];
        [nc3.tabBarItem setImage:imagePerson];
        
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

- (UIImage *)imageResize:(UIImage*)img andResizeTo:(CGSize)newSize {
    CGFloat scale = [[UIScreen mainScreen]scale];
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
