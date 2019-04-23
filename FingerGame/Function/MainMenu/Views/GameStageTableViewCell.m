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

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

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

+(GameStageTableViewCell *)createCellbyTableView:(UITableView *)tableView{
    GameStageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GameStageTableViewCell class])];
    if (!cell) {
        cell = [[GameStageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GameStageTableViewCell class])];
        [tableView registerClass:[GameStageTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GameStageTableViewCell class])];
    }
    return cell;
}

-(void)configureCell:(MissionModel *)model{
    self.stageNumberLabel.text= @"1";
    self.musicNameLabel.text = model.musicName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setup{
    
    
    [self addSubview:self.musicNameLabel];
    [self addSubview:self.stageNumberLabel];
    [self addSubview:self.textLabel];
    [self addSubview:self.actionButton];
    [self addSubview:self.auditionButton];
}

@end
