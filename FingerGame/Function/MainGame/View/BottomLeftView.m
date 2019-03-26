//
//  BottomLeftView.m
//  FingerGame
//
//  Created by lisy on 2019/2/25.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "BottomLeftView.h"

@implementation BottomLeftView

- (void)configView{
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-9)/2+4, 30)];
    headLabel.backgroundColor = [UIColor grayColor];
    headLabel.text = @"左手";
    headLabel.textColor = [UIColor whiteColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, (SCREEN_WIDTH-9)/10, 50)];
    l1.backgroundColor = [UIColor grayColor];
    l1.text = @"小指";
    l1.textColor = [UIColor blackColor];
    l1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+1)/10, 30, (SCREEN_WIDTH-9)/10, 50)];
    l2.backgroundColor = [UIColor grayColor];
    l2.text = @"无名指";
    l2.textColor = [UIColor blackColor];
    l2.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+1)/5, 30, (SCREEN_WIDTH-9)/10, 50)];
    l3.backgroundColor = [UIColor grayColor];
    l3.text = @"中指";
    l3.textColor = [UIColor blackColor];
    l3.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l4 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+1)/10*3, 30, (SCREEN_WIDTH-9)/10, 50)];
    l4.backgroundColor = [UIColor grayColor];
    l4.text = @"食指";
    l4.textColor = [UIColor blackColor];
    l4.textAlignment = NSTextAlignmentCenter;

    UILabel *l5 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH+1)/5*2, 30, (SCREEN_WIDTH-9)/10, 50)];
    l5.backgroundColor = [UIColor grayColor];
    l5.text = @"拇指";
    l5.textColor = [UIColor blackColor];
    l5.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:headLabel];
    [self addSubview:l1];
    [self addSubview:l2];
    [self addSubview:l3];
    [self addSubview:l4];
    [self addSubview:l5];
    NSLog(@"完成configView");
}

+ (CGFloat)heightForView{
    return 80;
}

@end
