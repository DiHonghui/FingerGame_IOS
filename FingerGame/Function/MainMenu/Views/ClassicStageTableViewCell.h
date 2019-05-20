//
//  ClassicStageTableViewCell.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/19.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissionModel.h"

NS_ASSUME_NONNULL_BEGIN
@protocol ClassicStageTableViewCellDelegate <NSObject>

@end


@interface ClassicStageTableViewCell : UITableViewCell

@property (nonatomic, weak) id<ClassicStageTableViewCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableview;
+(ClassicStageTableViewCell *)createCellbyTableView:(UITableView *)tableView;

-(void)configureCell:(MissionModel *)model;
-(void)configureCell;

@end

NS_ASSUME_NONNULL_END
