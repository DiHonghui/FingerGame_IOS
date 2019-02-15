//
//  NSURLRequest+Properties.m
//  ZHYFramework
//
//  Created by apple on 16/5/29.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import "NSURLRequest+Properties.h"
#import <objc/runtime.h>

static void *ZHYNetworkingRequestParams;

@implementation NSURLRequest (Properties)

- (void)setRequestParams:(NSDictionary *)requestParams{
    objc_setAssociatedObject(self, &ZHYNetworkingRequestParams, requestParams, OBJC_ASSOCIATION_COPY);
}

- (NSDictionary *)requestParams{
    return objc_getAssociatedObject(self, &ZHYNetworkingRequestParams);
}

@end
