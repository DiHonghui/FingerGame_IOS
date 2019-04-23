//
//  ZHYAPIProxy.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZHYURLResponse.h"

@interface ZHYAPIProxy : NSObject

+ (instancetype)sharedInstance;

- (NSInteger)callGETWithParams:(NSDictionary *)params
             serviceIdentifier:(NSString *)servieIdentifier
                    methodName:(NSString *)methodName
             completionHandler:(void (^)(ZHYURLResponse *response, NSError *error))completionHandler;


- (NSInteger)callPOSTWithParams:(NSDictionary *)params
             serviceIdentifier:(NSString *)servieIdentifier
                    methodName:(NSString *)methodName
             completionHandler:(void (^)(ZHYURLResponse *response, NSError *error))completionHandler;






- (void)cancelRequestWithRequestID:(NSNumber *)requestID;

- (void)cancelRequestWithRequestIDList:(NSArray *)requestIDList;

@end
