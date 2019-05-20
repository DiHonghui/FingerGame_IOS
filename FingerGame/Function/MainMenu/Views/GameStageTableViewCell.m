//
//  GameStageTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/7.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "GameStageTableViewCell.h"
#import "GVUserDefaults+Properties.h"
#import "MissionCollectApiManager.h"
#import "HLXibAlertView.h"
#import "MyAlertCenter.h"

@interface GameStageTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *stageNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *auditionButton;
@property (readwrite,nonatomic)NSString *missionIdNumber;
- (IBAction)collectMission:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;
@property(strong,nonatomic)MissionCollectApiManager *missionCollectApiManager;

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
    self.stageNumberLabel.text= @"等级1";
    self.musicNameLabel.text = model.musicName;
    self.collectButton.titleLabel.text = @"已收藏";
    self.missionIdNumber = model.missionID;
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
    [self addSubview:self.collectButton];
}

- (IBAction)collectMission:(id)sender {
    if (self.missionIdNumber!=nil) {
        self.collectButton.titleLabel.text = @"已收藏";
        self.detailTextLabel.text = @"gaibian";
        NSLog(@"触发按钮");
        [self.missionCollectApiManager loadDataWithParams:@{@"user_id":[GVUserDefaults standardUserDefaults].userId,@"game_id":_missionIdNumber,@"service":@"App.User.Like"} CompleteHandle:^(id responseData, ZHYAPIManagerErrorType errorType) {
            NSLog(@"%@", responseData[@"data"][@"message"]);
            NSString *mystring = responseData[@"data"][@"message"];
            [[MyAlertCenter defaultCenter] postAlertWithMessage:mystring];
        }];
        NSLog(@"update sucess");
    }
}


-(MissionCollectApiManager*) missionCollectApiManager{
    if (!_missionCollectApiManager) {
        _missionCollectApiManager = [[MissionCollectApiManager alloc]initWithMissionId:_missionIdNumber :[GVUserDefaults standardUserDefaults].userId];
    }
    return _missionCollectApiManager;
}
@end
