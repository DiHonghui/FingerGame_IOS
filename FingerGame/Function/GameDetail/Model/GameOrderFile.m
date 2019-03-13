//
//  GameOrderFile.m
//  FingerGame
//
//  Created by lisy on 2019/3/7.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameOrderFile.h"

@implementation GameOrderFile

#pragma mark - NSCoding Delegate
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.gameId forKey:@"gameId"];
    [aCoder encodeObject:self.gameName forKey:@"gameName"];
    [aCoder encodeObject:self.gameOrders forKey:@"gameOrders"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.gameId = [aDecoder decodeObjectForKey:@"gameId"];
    self.gameName = [aDecoder decodeObjectForKey:@"gameName"];
    self.gameOrders = [aDecoder decodeObjectForKey:@"gameOrders"];
    return self;
}

@end
