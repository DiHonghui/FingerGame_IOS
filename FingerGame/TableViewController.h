//
//  TableViewController.h
//  FingerGame
//
//  Created by Nao Kunagisa on 2019/3/26.
//  Copyright © 2019年 lisy. All rights reserved.
//

#import "ViewController.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>


NS_ASSUME_NONNULL_BEGIN

@interface TableViewController : ViewController<UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataSource;

/**
 *  必须在init函数里面初始化才有效果
 */
@property (assign, nonatomic) UITableViewStyle tableViewStyle;


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath __attribute__((objc_requires_super)) ;

- (NSString *)showEmptyDate;

@end

NS_ASSUME_NONNULL_END
