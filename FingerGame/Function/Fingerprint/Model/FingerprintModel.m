//
//  FingerprintModel.m
//  FingerGame
//
//  Created by lisy on 2019/4/12.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "FingerprintModel.h"

@implementation FingerprintModel

#pragma mark - NSCoding Delegate
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.fingerId forKey:@"fingerId"];
    [aCoder encodeObject:self.storeLocation forKey:@"storeLocation"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.fingerId = [aDecoder decodeObjectForKey:@"fingerId"];
    self.storeLocation = [aDecoder decodeObjectForKey:@"storeLocation"];
    return self;
}

@end
