//
//  ZHYRequestGenerator.h
//  ZHYNetworking
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHYRequestGenerator : NSObject

+ (instancetype)sharedInstance;

- (NSURLRequest *)generateGETRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;


- (NSURLRequest *)generatePOSTRequestWithServiceIdentifier:(NSString *)serviceIdentifier requestParams:(NSDictionary *)requestParams methodName:(NSString *)methodName;

@end
