//
//  ViewController.m
//  FingerGame
//
//  Created by lisy on 2019/1/3.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "ViewController.h"
#import "POP.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(100, 700)];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.duration = 10;
    POPBasicAnimation *anim2 = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim2.toValue = [NSValue valueWithCGPoint:CGPointMake(200, 700)];
    anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim2.duration = 10;
    
    UIView *testView1 = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 30, 30)];
    testView1.backgroundColor = [UIColor redColor];
    [testView1 pop_addAnimation:anim forKey:@"centerAnimation1"];
    UIView *testView2 = [[UIView alloc] initWithFrame:CGRectMake(200, 100, 30, 30)];
    testView2.backgroundColor = [UIColor redColor];
    [testView2 pop_addAnimation:anim2 forKey:@"centerAnimation2"];
    
    self.title = @"动画测试";
    self.view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:testView1];
    [self.view addSubview:testView2];
    
    CATransition *tranAnim = [CATransition animation];
    tranAnim.type = @"cube";
    tranAnim.duration = 0.5;
    
}


@end
