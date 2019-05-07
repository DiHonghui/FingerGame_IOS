//
//  PersonalInfoBasicTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/4/27.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "PersonalInfoBasicTableViewCell.h"
#import "GVUserDefaults+Properties.h"

@interface PersonalInfoBasicTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *nickNameLb;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@end

@implementation PersonalInfoBasicTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.nickNameLb.text = [GVUserDefaults standardUserDefaults].userName;
    
    [self.avatarImage setImage:[UIImage imageNamed:@"personal-info"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
+ (CGFloat)heightForcell{
    return 180;
}
@end
