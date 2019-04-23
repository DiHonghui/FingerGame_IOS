//
//  CustomTableViewCell.h
//  FingerGame
//
//  Created by lisy on 2019/4/19.
//  Copyright © 2019 lisy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomTableViewCell : UITableViewCell

- (void)setCellImage:(UIImage *)img;
- (void)setCellTitle:(NSString *)title;
- (void)setCellSubtitle:(NSString *)subtitle;
- (void)setCellThirdtitle:(NSString *)thirdtitle;
- (void)setCellImage:(UIImage *)img Title:(NSString *)title Subtitle:(NSString *)subtitle Thirdtitle:(NSString *)thirdtitle;
- (void)setCellImage:(UIImage *)img Title:(NSString *)title Subtitle:(NSString *)subtitle Thirdtitle:(NSString *)thirdtitle TipColor:(UIColor *)color;
@end

NS_ASSUME_NONNULL_END
