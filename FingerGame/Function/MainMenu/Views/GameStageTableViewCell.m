//
//  GameStageTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/7.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTableViewCell.h"

@interface GameStageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *stageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *auditionButton;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@end

@implementation GameStageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype) cellWithTableVew:(UITableView *)tableview{
    static NSString *cellID = @"cell";
    GameStageTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GameStageTableViewCell" owner:self options:nil]lastObject ];
    }
    return cell;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
