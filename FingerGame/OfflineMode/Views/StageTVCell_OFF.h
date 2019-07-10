//
//  StageTVCell_OFF.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/7/10.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol StageTVCell_OFFDelegate <NSObject>
-(void)changeLike:(NSString *)missionId;

@end

@interface StageTVCell_OFF : UITableViewCell
@property (nonatomic, weak) id<StageTVCell_OFFDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableview;
+(StageTVCell_OFF *)createCellbyTableView:(UITableView *)tableView;

-(void)configureCell:(MissionModel *)model;
@property(strong,nonatomic)MissionModel *missionCellModel;
@end

NS_ASSUME_NONNULL_END
