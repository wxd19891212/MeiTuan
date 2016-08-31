//
//  JGRushCell.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGRushCellDelegate <NSObject>

@optional
-(void)didSelectRushIndex:(NSInteger )index;

@end


@interface JGRushCell : UITableViewCell

@property(nonatomic, strong) NSMutableArray *rushData;

@property(nonatomic, assign) id<JGRushCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
