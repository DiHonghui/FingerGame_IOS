//
//  ZHYURLResponse.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYNetworkingConfiguration.h"

@interface ZHYURLResponse : NSObject

@property (nonatomic, assign, readonly) ZHYURLResponseStatus status;
@property (nonatomic, copy, readonly) id content;
@property (nonatomic, copy, readonly) NSData *responseData;
@property (nonatomic, assign, readonly) NSInteger requestId;
@property (strong, nonatomic, readonly) NSURLRequest *request;
@property (nonatomic, assign, readonly) BOOL isCache;
@property (nonatomic, copy) NSDictionary *requestParams;

- (instancetype)initWithRequestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error;

/**
 *  读取缓存时用这个构造函数
 *  @param data
 *  @return
 */
- (instancetype)initWithData:(NSData *)data;

@end
