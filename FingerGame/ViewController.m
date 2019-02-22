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
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"动画测试";
    NSLog(@"WIDTH == %f",self.view.frame.size.width);
    NSLog(@"HEIGHT == %f",self.view.frame.size.height);
    [self apply];

//    CATransition *tranAnim = [CATransition animation];
//    tranAnim.type = @"cube";
//    tranAnim.duration = 0.5;
    
}

//dispatch_apply 并发队列异步任务
- (void)apply {
    dispatch_queue_t oncurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_apply(5, oncurrentQueue, ^(size_t i) {
        NSLog(@"%zd --- %@",i,[NSThread currentThread]);
        [self setAnimation:i];
    });
    
    NSLog(@"dispatch_apply end");
}

//绘制动画
- (void)setAnimation:(size_t)i{
    
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(37*(i+1), 700)];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.duration = 10;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(i*5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"enterAnim -- %zd",i);
        UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(37*(i+1), 100, 25, 25)];
        testView.backgroundColor = [UIColor blueColor];
        [testView pop_addAnimation:anim forKey:@"centerAnimation"];
        [self.view addSubview:testView];
        NSLog(@"drawComplete -- %zd",i);
        NSLog(@"Y -- %f",testView.frame.origin.y);
    });
}
@end
