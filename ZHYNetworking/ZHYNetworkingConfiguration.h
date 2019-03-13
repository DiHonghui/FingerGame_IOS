//
//  ZHYNetworkingConfiguration.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#ifndef ZHYNetworkingConfiguration_h
#define ZHYNetworkingConfiguration_h

typedef NS_ENUM(NSInteger, ZHYAppType) {
    ZHYAppTypeSoftwareService,
};

//作为底层，请求是否成功只考虑是否成功收到服务器反馈。至于签名是否正确，返回的数据是否完整，由上层的RTApiBaseManager来决定。
typedef NS_ENUM(NSUInteger, ZHYURLResponseStatus){
    ZHYURLResponseStatusSuccess,
    ZHYURLResponseStatusErrorTimeout,
    ZHYURLResponseStatusErrorNoNetwork // 默认除了超时以外的错误都是无网络错误。
};

static NSUInteger kZHYCacheCountLimit = 1000; // 最多1000条cache

static BOOL KIsOnline = YES;

static NSString *KOnlineApiBaseUrl = @"http://shouzhi.yiyon.com.cn/";
static NSString *KOfflineApiBaseUrl = @"http://shouzhi.yiyon.com.cn/";

static NSString *kOnlineUploadBaseUrl = @"";
static NSString *kOfflineUploadBaseUrl = @"";

static NSString *kRealOnlineUploadBaseUrl = @"";

#endif /* ZHYNetworkingConfiguration_h */
