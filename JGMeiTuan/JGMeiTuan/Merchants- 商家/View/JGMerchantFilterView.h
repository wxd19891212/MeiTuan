//
//  JGMerchantFilterView.h
//  JGMeiTuan
//
//  Created by stkcctv on 16/8/31.
//  Copyright © 2016年 stkcctv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JGMerchantFilterViewDelegate <NSObject>

@optional
/**
 *  点击tableview，过滤id
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath withId:(NSNumber *)ID withName:(NSString *)name;

@end


@interface JGMerchantFilterView : UIView

@property(nonatomic, strong) UITableView *tableViewOfGroup;
@property(nonatomic, strong) UITableView *tableViewOfDetail;

@property(nonatomic, assign) id<JGMerchantFilterViewDelegate> delegate;


@end
