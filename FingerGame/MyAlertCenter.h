//
//  MyAlertCenter.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/20.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface MyAlert : UIView

-(id)init;
- (void) setMessageText:(NSString *)message;
@end



@interface MyAlertCenter : NSObject{
    
    MyAlert *myAlertView;//alertView
    BOOL active;//当前是否在用
    
    
}

+ (MyAlertCenter *) defaultCenter;//单例 生成alert控制器
- (void) postAlertWithMessage:(NSString*)message;//弹出文字

@end

