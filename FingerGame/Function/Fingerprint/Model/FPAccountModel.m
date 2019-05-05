//
//  FPAccountModel.m
//  FingerGame
//
//  Created by lisy on 2019/5/5.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "FPAccountModel.h"

@implementation FPAccountModel

#pragma mark - NSCoding Delegate
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userId forKey:@"userId"];
    [aCoder encodeObject:self.fpAccountId forKey:@"fpAccountId"];
    [aCoder encodeObject:self.fpAccountName forKey:@"fpAccountName"];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self.userId = [aDecoder decodeObjectForKey:@"userId"];
    self.fpAccountId = [aDecoder decodeObjectForKey:@"fpAccountId"];
    self.fpAccountName = [aDecoder decodeObjectForKey:@"fpAccountName"];
    return self;
}

@end
