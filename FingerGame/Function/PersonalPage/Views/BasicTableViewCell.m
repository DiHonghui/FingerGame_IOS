//
//  BasicTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/28.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "BasicTableViewCell.h"

@interface BasicTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *subtitle;

@end

@implementation BasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSubTitle :(NSString *)titleText{
    self.subtitle.text = titleText;
}

@end
