//
//  GameStageTableViewCell.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/7.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GameStageTableViewCellDelegate <NSObject>

@end

@interface GameStageTableViewCell : UITableViewCell
@property (nonatomic, weak) id<GameStageTableViewCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableview;
+(GameStageTableViewCell *)createCellbyTableView:(UITableView *)tableView;

-(void)configureCell:(MissionModel *)model;
@end

NS_ASSUME_NONNULL_END
