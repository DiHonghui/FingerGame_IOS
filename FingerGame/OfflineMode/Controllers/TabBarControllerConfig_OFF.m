//
//  TabBarControllerConfig_OFF.m
//  FingerGame
//
//  Created by lisy on 2019/7/9.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "TabBarControllerConfig_OFF.h"

#import "AppMacro.h"
#import "ZHYBaseNavigationController.h"
#import "GameStageTVC_OFF.h"
#import "ClassicStageViewController.h"
#import "PersonalCenterVC_OFF.h"

@interface TabBarControllerConfig_OFF()
@property (strong, nonatomic, readwrite) UITabBarController *tabBarController;

@end
@implementation TabBarControllerConfig_OFF

- (UITabBarController *)tabBarController{
    if (!_tabBarController) {
        _tabBarController = [[UITabBarController alloc] init];
        _tabBarController.tabBar.tintColor = UIColorFromRGB(0xCC8D4A);
        _tabBarController.tabBar.backgroundColor = [UIColor clearColor];
        
        GameStageTVC_OFF *tvc1 = [[GameStageTVC_OFF alloc]init];
        ZHYBaseNavigationController *nc1 = [[ZHYBaseNavigationController alloc] initWithRootViewController:tvc1];
        UIImage *imagehome = [UIImage imageNamed:@"底个首页"];
        UIImage *imageHome = [self imageResize:imagehome andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        
        imageHome = [imageHome imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc1.tabBarItem setSelectedImage:imageHome];
        [nc1.tabBarItem setImage:imageHome];
        
        ClassicStageViewController *ctvc = [[ClassicStageViewController alloc]init];
        ZHYBaseNavigationController *nc2 = [[ZHYBaseNavigationController alloc]initWithRootViewController:ctvc];
        UIImage *imagestar = [UIImage imageNamed:@"底个精品"];
        UIImage *imageStar = [self imageResize:imagestar andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        imageStar = [imageStar imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc2.tabBarItem setSelectedImage:imageStar];
        [nc2.tabBarItem setImage:imageStar];
        
        PersonalCenterVC_OFF *pvc1 = [[PersonalCenterVC_OFF alloc]init];
        ZHYBaseNavigationController *nc3 = [[ZHYBaseNavigationController alloc] initWithRootViewController:pvc1];
        UIImage *imageperson = [UIImage imageNamed:@"底个人中心"];
        UIImage *imagePerson = [self imageResize:imageperson andResizeTo:CGSizeMake(SCREEN_WIDTH/3, SCREEN_WIDTH*3/20)];
        imagePerson = [imagePerson imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [nc3.tabBarItem setSelectedImage:imagePerson];
        [nc3.tabBarItem setImage:imagePerson];
        
        [_tabBarController setViewControllers:@[nc1, nc2, nc3]];
        
    }
    return _tabBarController;
}

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

