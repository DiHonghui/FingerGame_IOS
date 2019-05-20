//
//  CostValueTableViewCell.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/5/19.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CostBuyDelegate <NSObject>

-(void)buyDiomond;
-(void)buyEnergy;

@end

@interface CostValueTableViewCell : UITableViewCell

@property(nonatomic,retain)id<CostBuyDelegate> user_delegate;

-(void)wantBuyDiomond;
-(void)wantbuyEnergy;
+(instancetype)cellWithTableView:(UITableView *)tableview;
+(CostValueTableViewCell *)createCellbyTableView:(UITableView *)tableView;

-(void)configureCell;
@end

NS_ASSUME_NONNULL_END
