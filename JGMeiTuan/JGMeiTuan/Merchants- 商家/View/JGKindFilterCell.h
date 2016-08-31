//
//  JGKindFilterCell.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGMerCateGroupModel.h"

@interface JGKindFilterCell : UITableViewCell

@property(nonatomic, strong) JGMerCateGroupModel *groupM;

+ (instancetype)cellWithTableView:(UITableView *)tableView;


@end
