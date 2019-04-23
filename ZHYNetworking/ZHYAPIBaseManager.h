//
//  ZHYAPIBaseManager.h
//  ZHYNetworking
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYURLResponse.h"
@class ZHYAPIBaseManager;

/*
 当产品要求返回数据不正确或者为空的时候显示一套UI，请求超时和网络不通的时候显示另一套UI时，使用这个enum来决定使用哪种UI。（安居客PAD就有这样的需求，sigh～）
 你不应该在回调数据验证函数里面设置这些值，事实上，在任何派生的子类里面你都不应该自己设置manager的这个状态，baseManager已经帮你搞定了。
 强行修改manager的这个状态有可能会造成程序流程的改变，容易造成混乱。
 */
typedef NS_ENUM (NSUInteger, ZHYAPIManagerErrorType){
    ZHYAPIManagerErrorTypeDefault,       //没有产生过API请求，这个是manager的默认状态。
    ZHYAPIManagerErrorTypeSuccess,       //API请求成功且返回数据正确，此时manager的数据是可以直接拿来使用的。
    ZHYAPIManagerErrorTypeNoContent,     //API请求成功但返回数据不正确。如果回调数据验证函数返回值为NO，manager的状态就会是这个。
    ZHYAPIManagerErrorTypeParamsError,   //参数错误，此时manager不会调用API，因为参数验证是在调用API之前做的。
    ZHYAPIManagerErrorTypeTimeout,       //请求超时。RTApiProxy设置的是20秒超时，具体超时时间的设置请自己去看RTApiProxy的相关代码。
    ZHYAPIManagerErrorTypeNoNetWork      //网络不通。在调用API之前会判断一下当前网络是否通畅，这个也是在调用API之前验证的，和上面超时的状态是有区别的。
};


typedef NS_ENUM (NSUInteger, ZHYAPIManagerRequestType){
    ZHYAPIManagerRequestTypeGet,
    ZHYAPIManagerRequestTypePost,
    ZHYAPIManagerRequestTypeRestGet,
    ZHYAPIManagerRequestTypeRestPost
};


typedef void (^ZHYAPIManagerCompleteHandle)(id responseData, ZHYAPIManagerErrorType errorType);


/*************************************************************************************************/
/*                                ZHYAPIManagerParamSourceDelegate                                */
/*************************************************************************************************/
//让manager能够获取调用API所需要的数据
@protocol ZHYAPIManagerParamSourceDelegate <NSObject>
@required
- (NSDictionary *)paramsForApi:(ZHYAPIBaseManager *)manager;
@end

/*************************************************************************************************/
/*                                     ZHYAPIManagerValidator                                     */
/*************************************************************************************************/

/**
 *  验证器，用于验证API的返回或者调用API的参数是否正确,一般由APIManager代理
 */
@protocol ZHYAPIManagerValidator <NSObject>

@required
/**
 *  对请求得到的数据进行验证
 *  @param manager
 *  @param data
 *  @return
 */
- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data;

/**
 *  发起联网请求时，对请求的参数做确认
 *  @param manager
 *  @param data
 *  @return  返回NO时联网请求取消
 */
- (BOOL)manager:(ZHYAPIBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data;
@end


/*************************************************************************************************/
/*                                         ZHYAPIManager                                          */
/*************************************************************************************************/
/*
 ZHYAPIBaseManager的派生类必须符合这些protocal
 */
@protocol ZHYAPIManager <NSObject>

@required
- (NSString *)methodName; // 方法名
- (ZHYAPIManagerRequestType)requestType; // 请求类型

@optional
- (NSString *)serviceType; // 服务器名
- (void)cleanData;
- (NSDictionary *)reformParams:(NSDictionary *)params;
- (NSTimeInterval)outdateTimeSeconds; //设置缓存时间，默认为0

@end






@interface ZHYAPIBaseManager : NSObject


@property (nonatomic, weak) id<ZHYAPIManagerParamSourceDelegate> paramSource;
@property (nonatomic, weak) NSObject<ZHYAPIManager> *child; //里面会调用到NSObject的方法，所以这里不用id
@property (weak, nonatomic) id<ZHYAPIManagerValidator> validator;

/**
 *  检测网络
 */
@property (assign, nonatomic, readonly) BOOL isReachable;

@property (assign, nonatomic, readonly) BOOL isLoading;

/**
 *  开始加载数据
 */
- (NSInteger)loadDataCompleteHandle:(ZHYAPIManagerCompleteHandle)completeHandle;

- (NSInteger)loadDataWithParams:(NSDictionary *)params CompleteHandle:(ZHYAPIManagerCompleteHandle)completeHandle;
/**
 *  取消所有网络请求,一般用这个,不用根据Id取消
 */
- (void)cancelAllRequests;
- (void)cancelRequestWithRequestId:(NSInteger)requestID;

- (NSString *)serviceType; // 服务器名
- (NSTimeInterval)outdateTimeSeconds;


@end

@interface ZHYAPIBaseManager (HUDProgress)

- (void)showNetworkIndicator;

- (void)hideNetworkIndicator;

- (void)showProgress;

- (void)hideProgress;

- (void)showHUDText:(NSString *)text;

- (void)toast:(NSString *)text;

- (void)toast:(NSString *)text duration:(NSTimeInterval)duration;

@end
