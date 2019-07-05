//
//  BottomRightView.m
//  FingerGame
//
//  Created by lisy on 2019/2/25.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "BottomRightView.h"

#import "AppMacro.h"

@implementation BottomRightView

- (void)configView{
    self.backgroundColor = UIColorFromRGB(0x7ea3de);
    
    UILabel *l1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-20)/10, 40)];
    l1.backgroundColor = UIColorFromRGB(0x4069de);
    l1.text = @"大拇指";
    l1.textColor = [UIColor whiteColor];
    l1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l2 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10-1)*1, 0, (SCREEN_WIDTH-20)/10, 40)];
    l2.backgroundColor = UIColorFromRGB(0x63b55b);
    l2.text = @"食指";
    l2.textColor = [UIColor whiteColor];
    l2.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l3 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10-1)*2, 0, (SCREEN_WIDTH-20)/10, 40)];
    l3.backgroundColor = UIColorFromRGB(0xffda46);
    l3.text = @"中指";
    l3.textColor = [UIColor whiteColor];
    l3.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l4 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10-1)*3, 0, (SCREEN_WIDTH-20)/10, 40)];
    l4.backgroundColor = UIColorFromRGB(0xff8746);
    l4.text = @"无名指";
    l4.textColor = [UIColor whiteColor];
    l4.textAlignment = NSTextAlignmentCenter;
    
    UILabel *l5 = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH/10-1)*4, 0, (SCREEN_WIDTH-20)/10, 40)];
    l5.backgroundColor = UIColorFromRGB(0xff5534);
    l5.text = @"小拇指";
    l5.textColor = [UIColor whiteColor];
    l5.textAlignment = NSTextAlignmentCenter;

    [self addSubview:l1];
    [self addSubview:l2];
    [self addSubview:l3];
    [self addSubview:l4];
    [self addSubview:l5];
    NSLog(@"完成configRightView");
}

+ (CGFloat)heightForView{
    return 40;
}

@end
