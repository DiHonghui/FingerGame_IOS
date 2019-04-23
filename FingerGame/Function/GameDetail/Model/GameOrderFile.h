//
//  GameOrderFile.h
//  FingerGame
//
//  Created by lisy on 2019/3/7.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GameOrderFile : NSObject<NSCoding>

@property (strong,nonatomic) NSString *gameId;
@property (strong,nonatomic) NSString *gameName;
@property (strong,nonatomic) NSMutableArray *gameOrders;

@end

NS_ASSUME_NONNULL_END
