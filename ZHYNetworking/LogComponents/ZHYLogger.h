//
//  ZHYLogger.h
//  ZHYNetworking
//
//  Created by apple on 16/5/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYService.h"
#import "ZHYURLResponse.h"


@interface ZHYLogger : NSObject

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName service:(ZHYService *)service requestParams:(id)requestParams httpMethod:(NSString *)httpMethod;

+ (void)logDebugInfoWithResponse:(NSHTTPURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error;

+ (void)logDebugInfoWithCachedResponse:(ZHYURLResponse *)response methodName:(NSString *)methodName serviceIdentifier:(ZHYService *)service;


+ (instancetype)sharedInstance;

@end
