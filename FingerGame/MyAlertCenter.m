//
//  MyAlertCenter.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/20.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "MyAlertCenter.h"



@implementation MyAlertCenter

+ (MyAlertCenter *) defaultCenter{
    static MyAlertCenter *defaultCenter;
    if (!defaultCenter) {
        defaultCenter=[[MyAlertCenter alloc]init];
    }
    return defaultCenter;
}

- (id) init{
    if(!(self=[super init])) return nil;
    
    myAlertView = [[MyAlert alloc] init];
    myAlertView.alpha = 0.0f;
    active = NO;
    
    [[UIApplication sharedApplication].keyWindow addSubview:myAlertView];
    
    return self;
}

- (void) postAlertWithMessage:(NSString*)message{
    //判断当前是否在使用中
    if (!active) {
        [self showAlerts:message];
    }
}

- (void) showAlerts:(NSString *) str {
    
    //开始使用，设置当前为使用状态
    active = YES;
    myAlertView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:myAlertView];
    [myAlertView setMessageText:str];
    myAlertView.center = [UIApplication sharedApplication].keyWindow.center;
    
    //设置动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStep2)];
    myAlertView.alpha = 0.8;
    [UIView commitAnimations];
}

- (void) animationStep2{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelay:0.5];//显示时间
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStep3)];
    myAlertView.alpha = 0;
    [UIView commitAnimations];
}


- (void) animationStep3{
    
    [myAlertView removeFromSuperview];
    active=NO;
    
}
@end




@implementation MyAlert

CGRect messageRect;
NSString *text;

-(id)init{
    
    self=[super initWithFrame:CGRectMake(0, 0, 150, 10)];
    if (self) {
        messageRect =CGRectInset(self.bounds, 10, 10);
    }
    return self;
}
-(void)setMessageText:(NSString *)message{
    
    text=message;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
    
    CGSize s=[text boundingRectWithSize:CGSizeMake(200, 0) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    
    self.bounds = CGRectMake(0, 0, s.width+40, s.height+15+15);
    
    messageRect.size = s;
    messageRect.size.height += 5;
    messageRect.origin.x = 20;
    messageRect.origin.y = 15;
    
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect
{
    NSDictionary* attrs =@{NSForegroundColorAttributeName:[UIColor whiteColor]
                           ,NSFontAttributeName:[UIFont fontWithName:@"AmericanTypewriter" size:18]
                           };
    [text drawInRect:messageRect withAttributes:attrs]; //给文本限制个矩形边界，防止矩形拉伸；
}


@end
