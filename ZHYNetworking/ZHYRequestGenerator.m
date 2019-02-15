//
//  ZHYRequestGenerator.m
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <AFNetworking/AFURLRequestSerialization.h>
#import "ZHYRequestGenerator.h"
#import "ZHYService.h"
#import "ZHYServiceFactory.h"
#import "ZHYLogger.h"
#import "NSURLRequest+Properties.h"

@interface ZHYRequestGenerator ()

@property (strong, nonatomic) AFHTTPRequestSerializer *httpRequestSerializer;


@end

@implementation ZHYRequestGenerator

#pragma mark - life cycle
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ZHYRequestGenerator *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZHYRequestGenerator alloc] init];
    });
    return sharedInstance;
}

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    NSString *urlString = [self generateURLStringWithServiceIdentifier:serviceIdentifier methodName:methodName];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"GET" URLString:urlString parameters:requestParams error:NULL];
    request.requestParams = requestParams;
    [ZHYLogger logDebugInfoWithRequest:request apiName:methodName service:[self generateService:serviceIdentifier] requestParams:requestParams httpMethod:@"GET"];
    return request;
}

- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName{
    
    NSString *urlString = [self generateURLStringWithServiceIdentifier:serviceIdentifier methodName:methodName];
    self.httpRequestSerializer = [AFJSONRequestSerializer serializer];
    NSMutableURLRequest *request = [self.httpRequestSerializer requestWithMethod:@"POST" URLString:urlString parameters:requestParams error:NULL];
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    request.requestParams = requestParams;
    [ZHYLogger logDebugInfoWithRequest:request apiName:methodName service:[self generateService:serviceIdentifier] requestParams:requestParams httpMethod:@"POST"];
    return request;
}

- (NSString *)generateURLStringWithServiceIdentifier:(NSString *)serviceIdentifier methodName:(NSString *)methodName{
    ZHYService *service = [self generateService:serviceIdentifier];
    NSString *urlString = [NSString stringWithFormat:@"%@%@%@", service.apiBaseUrl, service.apiVersion, methodName];
    return urlString;
}

- (ZHYService *)generateService:(NSString *)serviceIdentifier{
    ZHYService *service = [[ZHYServiceFactory sharedInstance] serviceWithIdentifier:serviceIdentifier];
    return service;
}

#pragma mark - get & set

- (AFHTTPRequestSerializer *)httpRequestSerializer{
    if (!_httpRequestSerializer) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
        _httpRequestSerializer.timeoutInterval = 10;
        _httpRequestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
        
    }
    return _httpRequestSerializer;
}

@end
