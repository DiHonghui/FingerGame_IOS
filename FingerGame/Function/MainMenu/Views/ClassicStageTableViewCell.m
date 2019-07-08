//
//  ClassicStageTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/19.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ClassicStageTableViewCell.h"
#import "GVUserDefaults+Properties.h"
#import "HLXibAlertView.h"

@interface ClassicStageTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *actionBtn;
@property (weak, nonatomic) IBOutlet UILabel *MissionName;
@property (weak, nonatomic) IBOutlet UILabel *costNumber;
@property (weak, nonatomic) IBOutlet UILabel *authorName;
@property (weak, nonatomic) IBOutlet UILabel *costLabe;

@end

@implementation ClassicStageTableViewCell

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
    ClassicStageTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ClassicStageTableViewCell" owner:self options:nil]lastObject ];
    }
    return cell;
}

-(void)configureCell:(MissionModel *)model{
    //有了具体数据后可以使用；
}

-(void)configureCell{
    self.MissionName.text= @"洪湖水浪打浪";
    self.authorName.text = @"常世全";
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

   // Configure the view for the selected state
}

-(void)setup{
    [self addSubview:self.actionBtn];
    [self addSubview:self.costNumber];
    [self addSubview:self.MissionName];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}


@end
