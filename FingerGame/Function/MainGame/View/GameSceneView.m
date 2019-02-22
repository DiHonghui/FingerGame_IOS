//
//  GameSceneView.m
//  FingerGame
//
//  Created by lisy on 2019/2/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "GameSceneView.h"

@implementation GameSceneView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        [self setup];
    }
    return self;
}

#pragma mark - private method
- (void)reSet{
}

- (void)setup{
    self.backgroundColor = [UIColor blueColor];
}
@end
