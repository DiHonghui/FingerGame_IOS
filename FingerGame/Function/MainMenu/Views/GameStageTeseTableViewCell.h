//
//  GameStageTeseTableViewCell.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/7/1.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GameStageTeseTableViewCellDelegate <NSObject>


@end

@interface GameStageTeseTableViewCell : UITableViewCell
@property (nonatomic, weak) id<GameStageTeseTableViewCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableview;
+(GameStageTeseTableViewCell *)createCellbyTableView:(UITableView *)tableView;

-(void)configureCell:(MissionModel *)model;

@end

NS_ASSUME_NONNULL_END
