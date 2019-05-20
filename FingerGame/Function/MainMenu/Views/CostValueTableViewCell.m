//
//  CostValueTableViewCell.m
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/19.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "CostValueTableViewCell.h"
#import "GVUserDefaults+Properties.h"
#import "HLXibAlertView.h"

@interface CostValueTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *diomondLabel;
@property (weak, nonatomic) IBOutlet UILabel *diomondNumber;
@property (weak, nonatomic) IBOutlet UIButton *addDiomond;
@property (weak, nonatomic) IBOutlet UILabel *HealthybeanLabel;
@property (weak, nonatomic) IBOutlet UILabel *HealthyBeansNumber;
@property (weak, nonatomic) IBOutlet UIButton *addBeans;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyNumber;
@property (weak, nonatomic) IBOutlet UIButton *addEnergy;
- (IBAction)addDiomondAction:(id)sender;
- (IBAction)addEnergyAction:(id)sender;

@end

@implementation CostValueTableViewCell

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
    static NSString *cellID = @"costCell";
    CostValueTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CostValueTableViewCell" owner:self options:nil]lastObject ];
    }
    return cell;
}

+(CostValueTableViewCell *)createCellbyTableView:(UITableView *)tableView{
    CostValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CostValueTableViewCell class])];
    if (!cell) {
        cell = [[CostValueTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([CostValueTableViewCell class])];
        [tableView registerClass:[CostValueTableViewCell class] forCellReuseIdentifier:NSStringFromClass([CostValueTableViewCell class])];
    }
    return cell;
}

-(void)configureCell{
    self.energyNumber.text= [GVUserDefaults standardUserDefaults].energy;
    self.HealthyBeansNumber.text = [GVUserDefaults standardUserDefaults].healthyBeans;
    self.diomondNumber.text = [GVUserDefaults standardUserDefaults].diamond;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



-(void)setup{
    [self addSubview:self.addBeans];
    [self addSubview:self.addEnergy];
    [self addSubview:self.addDiomond];
    [self addSubview:self.diomondLabel];
    [self addSubview:self.diomondNumber];
    [self addSubview:self.HealthybeanLabel];
    [self addSubview:self.HealthyBeansNumber];
    [self addSubview:self.energyLabel];
    [self addSubview:self.energyNumber];
}
-(void)wantBuyDiomond{
    NSLog(@"cell触发委托买钻石");
    [self.user_delegate buyDiomond];
}
-(void)wantbuyEnergy{
    NSLog(@"cell触发委托买体力");
    [self.user_delegate buyEnergy];
}

- (IBAction)addDiomondAction:(id)sender {
    [self wantBuyDiomond];
    NSLog(@"cell按钮触发买钻石");
    
}

- (IBAction)addEnergyAction:(id)sender {
    [self wantbuyEnergy];
    NSLog(@"cell按钮触发买体力");
}
@end
