//
//  LoadResourceTipView.m
//  FingerGame
//
//  Created by lisy on 2019/5/17.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "LoadResourceTipView.h"

#import <Masonry/Masonry.h>
#import "AppMacro.h"

#define kAlertViewHeight 200
#define kAlertViewWidth 240

@interface LoadResourceTipView()

@property (nonatomic,strong) UIProgressView *loadProgressView;
@property (nonatomic,strong) UILabel *progressTitleLB;
@property (nonatomic,strong) UILabel *progressPercentLB;


@end

@implementation LoadResourceTipView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self myLayoutSubviews];
    }
    return self;
}

- (void)myLayoutSubviews{
    //弹窗
    UIView *alertView = [[UIView alloc] initWithFrame:CGRectMake( (SCREEN_WIDTH-kAlertViewWidth)/2, (SCREEN_HEIGHT-kAlertViewHeight)/2, kAlertViewWidth, kAlertViewHeight)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 0.02 * kAlertViewWidth;
    [self addSubview:alertView];
    //提示文字
    UILabel *alertLabel = [[UILabel alloc] init];
    alertLabel.lineBreakMode = NSLineBreakByWordWrapping;
    alertLabel.numberOfLines = 0;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.text = @"游戏资源加载中，请稍后\n\n";
    alertLabel.font = [UIFont systemFontOfSize:16];
    alertLabel.textColor = UIColorFromRGB(0x000000);
    [alertLabel sizeToFit];
    [alertView addSubview:alertLabel];
    //加载进度条
    self.loadProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    self.loadProgressView.trackTintColor = [UIColor colorWithRed:199/255.0 green:198/255.0 blue:198/255.0 alpha:0.5];
    self.loadProgressView.progressTintColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
    self.loadProgressView.layer.masksToBounds = YES;
    self.loadProgressView.layer.cornerRadius = 5;
    self.loadProgressView.progress = 0.1;
    [alertView addSubview:self.loadProgressView];
    
    self.progressTitleLB = [[UILabel alloc] init];
    self.progressTitleLB.textAlignment = NSTextAlignmentLeft;
    self.progressTitleLB.textColor = UIColorFromRGB(0xa6a6a6);
    self.progressTitleLB.text = @"加载进度";
    [alertView addSubview:self.progressTitleLB];
    
    self.progressPercentLB = [[UILabel alloc] init];
    self.progressPercentLB.textColor = UIColorFromRGB(0xa6a6a6);
    self.progressPercentLB.textAlignment = NSTextAlignmentRight;
    self.progressPercentLB.text = @"0.00%";
    [alertView addSubview:self.progressPercentLB];
    //
    [alertLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertView.mas_top);
        make.left.equalTo(alertView.mas_left);
        make.width.equalTo(alertView.mas_width);
        make.height.equalTo(@(kAlertViewHeight/2));
    }];
    [self.loadProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertView.mas_bottom).offset(-10);
        make.left.equalTo(alertView.mas_left).offset(10);
        make.width.equalTo(@(kAlertViewWidth-20));
        make.height.equalTo(@(kAlertViewHeight/16));
    }];
    [self.progressTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loadProgressView.mas_top);
        make.left.equalTo(self.loadProgressView.mas_left);
        make.width.equalTo(@(kAlertViewWidth/2));
        make.height.equalTo(@(kAlertViewHeight/4));
    }];
    [self.progressPercentLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.loadProgressView.mas_top);
        make.right.equalTo(self.loadProgressView.mas_right);
        make.width.equalTo(@(kAlertViewWidth/2));
        make.height.equalTo(@(kAlertViewHeight/4));
    }];
}

- (void)updateProgress:(CGFloat)progress{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (progress>=0 && progress<=1){
            self.loadProgressView.progress = progress;
            self.progressPercentLB.text = [NSString stringWithFormat:@"%.2f%%",progress*100];
        }
        if (progress == 1)
            self.progressTitleLB.text = @"加载完成";
    });
}

@end
