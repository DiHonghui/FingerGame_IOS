//
//  ZHYCacheObject.h
//  ZHYNetworking
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 ZhouYuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZHYCacheObject : NSObject

@property (strong, nonatomic, readonly) NSData *content;
@property (strong, nonatomic, readonly) NSDate *lastUpdateTime;

@property (assign, nonatomic, readonly) BOOL isOutdated;
@property (assign, nonatomic, readonly) BOOL isEmpty;

- (instancetype)initWithContent:(NSData *)content;
- (instancetype)initWithContent:(NSData *)content outdateTimeSeconds:(NSTimeInterval)cacheOutdateTimeSeconds;

- (void)updateContent:(NSData *)content;


@end
