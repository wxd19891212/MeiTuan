//
//  JGDiscountCell.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/30.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGDiscountCellDelegate <NSObject>

@optional
-(void)didSelectUrl:(NSString *)urlStr withType:(NSNumber *)type withId:(NSNumber *)ID withTitle:(NSString *)title;

@end


@interface JGDiscountCell : UITableViewCell

@property(nonatomic, strong) NSMutableArray *discountArray;

@property(nonatomic, assign) id<JGDiscountCellDelegate> delegate;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
