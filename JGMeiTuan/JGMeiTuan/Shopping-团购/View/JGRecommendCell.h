//
//  JGRecommendCell.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JGRecommendModel.h"
#import "JGDiscountModel.h"

@interface JGRecommendCell : UITableViewCell


@property(nonatomic, strong) UIImageView *shopImage;
@property(nonatomic, strong) UILabel *shopNameLabel;
@property(nonatomic, strong) UILabel *shopInfoLabel;
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *soldedLabel;


@property(nonatomic, strong) JGRecommendModel *recommendData;

@property(nonatomic, strong) JGDiscountModel *dealData;


+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
