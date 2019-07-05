//
//  GameStageTeseTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/7/1.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTeseTableViewCell.h"
#import "GVUserDefaults+Properties.h"
#import "MissionCollectApiManager.h"
#import "HLXibAlertView.h"
#import "MyAlertCenter.h"

@interface GameStageTeseTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundColor;
@property (weak, nonatomic) IBOutlet UILabel *musicName;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property (weak, nonatomic) IBOutlet UIImageView *likeIcon;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak,nonatomic)NSString *missionIdNumber;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (strong,nonatomic)MissionCollectApiManager *missionCollectApiManager;
@property (weak,nonatomic)NSString *likeOrNot;
@property(nonatomic,strong)NSString *missionId;

@end


@implementation GameStageTeseTableViewCell

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype) cellWithTableVew:(UITableView *)tableview{
    static NSString *cellID = @"cell";
    GameStageTeseTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"GameStageTaseTableViewCell" owner:self options:nil]lastObject ];
    }
    
    return cell;
}

+(GameStageTeseTableViewCell *)createCellbyTableView:(UITableView *)tableView{
    GameStageTeseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GameStageTeseTableViewCell class])];
    if (!cell) {
        cell = [[GameStageTeseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([GameStageTeseTableViewCell class])];
        [tableView registerClass:[GameStageTeseTableViewCell class] forCellReuseIdentifier:NSStringFromClass([GameStageTeseTableViewCell class])];
    }
    return cell;
}
/**
 cell内容
 */
-(void)configureCell:(MissionModel *)model{
    self.rankNum.text = model.missionLevel;
    self.musicName.text = model.musicName;
    self.authorName.text = model.missionName;
    self.missionId = model.missionID;
    self.likeOrNot = model.like;
    if ([self.likeOrNot isEqualToString:@"1"]) {
        UIImage *image = [UIImage imageNamed:@"收藏2"];
        [self.likeIcon setImage:image];
    }
    
}

-(void)setup{
    
    
    [self addSubview:self.rankNum];
    [self addSubview:self.musicName];
    [self addSubview:self.authorName];
    [self addSubview:self.backgroundColor];
    [self addSubview:self.actionButton];
    [self addSubview:self.likeIcon];
    [self addSubview:self.star1];
    [self addSubview:self.star2];
    [self addSubview:self.star3];
    [self.likeIcon setUserInteractionEnabled:YES];
//    [self.likeIcon addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collect)]];
    
}

/**
 收藏按钮
 */
- (IBAction)collect:(id)sender {
    NSLog(@"触发收藏按钮");
    if (self.missionId!=nil) {
        [self.missionCollectApiManager loadDataWithParams:@{@"user_id":[GVUserDefaults standardUserDefaults].userId,@"game_id":_missionId,@"service":@"App.User.Like"} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            NSLog(@"收藏状态为%@", responseData[@"data"][@"message"]);
        }];
    }
    if ([self.likeOrNot isEqualToString:@"1"]) {
        UIImage *image = [UIImage imageNamed:@"收藏1"];
        [self.likeIcon setImage:image];
        self.likeOrNot = @"0";
    }else{
        UIImage *image = [UIImage imageNamed:@"收藏2"];
        [self.likeIcon setImage:image];
        self.likeOrNot = @"1";
    }
}

-(MissionCollectApiManager*) missionCollectApiManager{
    if (!_missionCollectApiManager) {
        _missionCollectApiManager = [[MissionCollectApiManager alloc]initWithMissionId:_missionIdNumber :[GVUserDefaults standardUserDefaults].userId];
    }
    return _missionCollectApiManager;
}

@end
