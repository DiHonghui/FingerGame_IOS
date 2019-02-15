//
//  AppMacro.h
//  FingerGame
//
//  Created by lisy on 2019/1/21.
//  Copyright © 2019 lisy. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

// 基础背景色
#define BaseBackgroundColor UIColorFromRGB(0xffffff)
#define NavigationBarTintColor UIColorFromRGB(0xffffff)
#define NavigationTintColor UIColorFromRGB(0xffffff)
// 16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define RGBACOLOR(r,g,b,a)         [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGBCOLOR(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define BoldSystemFont(size)  [UIFont boldSystemFontOfSize:size]
#define SystemFont(size)      [UIFont systemFontOfSize:size]
#define isIOS7                [[UIDevice currentDevice].systemVersion doubleValue]>=7.0?YES:NO
#define SYSTEM_VERSION        [[[UIDevice currentDevice] systemVersion] floatValue]

#define STATUSBAR_HEIGHT      [[UIApplication sharedApplication] statusBarFrame].size.height
#define NAVBAR_HEIGHT         (44.f + ((SYSTEM_VERSION >= 7) ? STATUSBAR_HEIGHT : 0))
#define TabBar_HEIGHT          49

// 屏幕高度
#define SCREEN_HEIGHT         [[UIScreen mainScreen] bounds].size.height
// 屏幕宽度
#define SCREEN_WIDTH          [[UIScreen mainScreen] bounds].size.width
#define FULL_WIDTH            SCREEN_WIDTH
#define FULL_HEIGHT           (SCREEN_HEIGHT - ((SYSTEM_VERSION >= 7) ? 0 : STATUSBAR_HEIGHT))
#define CONTENT_HEIGHT        (FULL_HEIGHT - NAVBAR_HEIGHT)


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))
//各个手机型号开发尺寸
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6_6S_7_8 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P_6SP_7P_8P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

// 获取 View 的 frame 的属性
#define GetViewWidth(view)    view.frame.size.width
#define GetViewHeight(view)   view.frame.size.height
#define GetViewX(view)        view.frame.origin.x
#define GetViewY(view)        view.frame.origin.y

#define kKeyWindow [UIApplication sharedApplication].keyWindow

#endif /* AppMacro_h */
