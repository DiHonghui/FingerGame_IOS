//
//  OrderModel.h
//  FingerGame
//
//  Created by lisy on 2019/3/7.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,StateType){
    StateTypeDefault = 0,
    StateTypeSuccess,
    StateTypeFailure
};

@interface OrderModel : NSObject
//原始指令
@property (nonatomic,strong) NSString *origin;
//指令在指令集中的编号
@property (nonatomic,assign) int no;
//手指ID
@property (nonatomic,assign) int fingerId;
//开始时间 秒
@property (nonatomic,assign) float startTime;
//时长限制 秒
@property (nonatomic,assign) float duration;
//处理状态
@property (nonatomic,assign) StateType state;

@end
