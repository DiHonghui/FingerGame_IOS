//
//  ZHYURLResponse.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "ZHYURLResponse.h"
#import "NSURLRequest+Properties.h"

@interface ZHYURLResponse ()

@property (nonatomic, assign, readwrite) ZHYURLResponseStatus status;
@property (nonatomic, copy, readwrite) id content;
@property (nonatomic, copy, readwrite) NSData *responseData;
@property (nonatomic, assign, readwrite) NSInteger requestId;
@property (strong, nonatomic, readwrite) NSURLRequest *request;
@property (nonatomic, assign, readwrite) BOOL isCache;

@end

@implementation ZHYURLResponse

- (instancetype)initWithRequestId:(NSNumber *)requestId request:(NSURLRequest *)request responseData:(NSData *)responseData error:(NSError *)error{
    self = [super init];
    if (self) {
        if (responseData) {
            self.content = [NSJSONSerialization JSONObjectWithData:responseData
                                                           options:NSJSONReadingMutableContainers
                                                             error:NULL];
        }else{
            self.content = nil;
        }
        self.status = [self responseStatusWithError:error];
        self.requestId = [requestId integerValue];
        self.responseData = responseData;
        self.request = request;
        self.requestParams = request.requestParams;
        self.isCache = NO;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data{
    self = [super init];
    if (self) {
        self.status = [self responseStatusWithError:nil];
        self.requestId = 0;
        self.request = nil;
        self.responseData = [data copy];
        self.content = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:NULL];
        self.isCache = YES;
    }
    return self;
}

#pragma mark - private methods
- (ZHYURLResponseStatus)responseStatusWithError:(NSError *)error{
    if (error) {
        ZHYURLResponseStatus result = ZHYURLResponseStatusErrorNoNetwork;
        // 除了超时以外，所有错误都当成是无网络
        if (error.code == NSURLErrorTimedOut) {
            result = ZHYURLResponseStatusErrorNoNetwork;
        }
        return result;
    } else {
        return ZHYURLResponseStatusSuccess;
    }
}


@end
