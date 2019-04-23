//
//  CustomTableViewCell.m
//  FingerGame
//
//  Created by lisy on 2019/4/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "AppMacro.h"
#import <Masonry/Masonry.h>

@interface CustomTableViewCell()

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UILabel *title;
@property (nonatomic,strong) UILabel *subtitle;
@property (nonatomic,strong) UILabel *thirdtitle;

@end

@implementation CustomTableViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        [self layoutSubview];
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Object Methods
- (void)setCellImage:(UIImage *)img{
    self.icon.image = img;
}

- (void)setCellTitle:(NSString *)title{
    self.title.text = title;
}

- (void)setCellSubtitle:(NSString *)subtitle{
    self.subtitle.text = subtitle;
}

- (void)setCellThirdtitle:(NSString *)thirdtitle{
    self.thirdtitle.text = thirdtitle;
}

- (void)setCellImage:(UIImage *)img Title:(NSString *)title Subtitle:(NSString *)subtitle Thirdtitle:(NSString *)thirdtitle{
    [self setCellImage:img];
    [self setCellTitle:title];
    [self setCellSubtitle:subtitle];
    [self setCellThirdtitle:thirdtitle];
}

- (void)setCellImage:(UIImage *)img Title:(NSString *)title Subtitle:(NSString *)subtitle Thirdtitle:(NSString *)thirdtitle TipColor:(UIColor *)color{
    [self setCellImage:img];
    [self setCellTitle:title];
    [self setCellSubtitle:subtitle];
    [self setCellThirdtitle:thirdtitle];
    self.thirdtitle.textColor = color;
}
#pragma mark - Private Methods
- (void)layoutSubview{
    [self addSubview:self.icon];
    [self addSubview:self.title];
    [self addSubview:self.subtitle];
    [self addSubview:self.thirdtitle];
    
    @zyweakify(self);
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        @zystrongify(self);
        make.width.equalTo(@13);
        make.height.equalTo(@16);
        make.left.equalTo(self.mas_left).offset(22);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        @zystrongify(self);
        make.left.equalTo(self.icon.mas_right).offset(22);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @zystrongify(self);
        make.left.equalTo(self.title.mas_right).offset(12);
        make.right.lessThanOrEqualTo(self.thirdtitle.mas_left).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.thirdtitle mas_makeConstraints:^(MASConstraintMaker *make) {
        @zystrongify(self);
        make.width.equalTo(@45);
        make.right.equalTo(self.mas_right).offset(-7);
        make.centerY.equalTo(self.mas_centerY);
    }];
}
#pragma mark - Set & Get
- (UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
    }
    return _icon;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = SystemFont(14);
        _title.textColor = UIColorFromRGB(0x666666);
        _title.text = @"";
    }
    return _title;
}

- (UILabel *)subtitle{
    if (!_subtitle) {
        _subtitle = [[UILabel alloc] init];
        _subtitle.adjustsFontSizeToFitWidth = YES;
        _subtitle.textColor = UIColorFromRGB(0x999999);
        _subtitle.text = @"";
    }
    return _subtitle;
}

- (UILabel *)thirdtitle{
    if (!_thirdtitle) {
        _thirdtitle = [[UILabel alloc] init];
        _thirdtitle.adjustsFontSizeToFitWidth = YES;
        _thirdtitle.textColor = UIColorFromRGB(0xFCA83B);
        _thirdtitle.text = @"";
    }
    return _thirdtitle;
}

@end
